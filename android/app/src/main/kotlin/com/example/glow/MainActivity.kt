package com.example.glow

import android.Manifest
import android.content.ContentUris
import android.content.pm.PackageManager
import android.view.WindowManager
import android.provider.CalendarContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.concurrent.thread

private const val CHANNEL = "glow/calendar"
private const val PERMISSION_REQUEST = 4201

/**
 * Read-only access to the phone calendar. Written in-app because the common
 * calendar plugins also require WRITE_CALENDAR, and Glow only ever reads.
 */
class MainActivity : FlutterActivity() {
    private var pendingPermission: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "glow/screen")
            .setMethodCallHandler { call, result ->
                if (call.method != "keepOn") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                if (call.arguments == true) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                }
                result.success(null)
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestPermission" -> requestCalendarPermission(result)
                    "listCalendars" -> runQuery(result) { listCalendars() }
                    "listEvents" -> runQuery(result) { listEvents(call) }
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasCalendarPermission() =
        checkSelfPermission(Manifest.permission.READ_CALENDAR) ==
            PackageManager.PERMISSION_GRANTED

    private fun requestCalendarPermission(result: MethodChannel.Result) {
        if (hasCalendarPermission()) {
            result.success(true)
            return
        }
        pendingPermission?.success(false)
        pendingPermission = result
        requestPermissions(arrayOf(Manifest.permission.READ_CALENDAR), PERMISSION_REQUEST)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        if (requestCode == PERMISSION_REQUEST) {
            pendingPermission?.success(hasCalendarPermission())
            pendingPermission = null
            return
        }
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    /** Runs a provider query off the UI thread. */
    private fun runQuery(result: MethodChannel.Result, query: () -> Any) {
        thread {
            try {
                val value = query()
                runOnUiThread { result.success(value) }
            } catch (e: Exception) {
                runOnUiThread { result.error("calendar", e.message, null) }
            }
        }
    }

    private fun listCalendars(): List<Map<String, Any?>> {
        val rows = mutableListOf<Map<String, Any?>>()
        contentResolver.query(
            CalendarContract.Calendars.CONTENT_URI,
            arrayOf(
                CalendarContract.Calendars._ID,
                CalendarContract.Calendars.CALENDAR_DISPLAY_NAME,
                CalendarContract.Calendars.ACCOUNT_NAME,
            ),
            null,
            null,
            CalendarContract.Calendars.CALENDAR_DISPLAY_NAME,
        )?.use { cursor ->
            while (cursor.moveToNext()) {
                rows.add(
                    mapOf(
                        "id" to cursor.getString(0),
                        "name" to cursor.getString(1),
                        "account" to cursor.getString(2),
                    ),
                )
            }
        }
        return rows
    }

    /** Instances expands repeating events into their individual occurrences. */
    private fun listEvents(call: MethodCall): List<Map<String, Any?>> {
        val calendarId = call.argument<String>("calendarId")!!
        val uri = CalendarContract.Instances.CONTENT_URI.buildUpon()
        ContentUris.appendId(uri, call.argument<Number>("start")!!.toLong())
        ContentUris.appendId(uri, call.argument<Number>("end")!!.toLong())

        val rows = mutableListOf<Map<String, Any?>>()
        contentResolver.query(
            uri.build(),
            arrayOf(
                CalendarContract.Instances.EVENT_ID,
                CalendarContract.Instances.TITLE,
                CalendarContract.Instances.BEGIN,
                CalendarContract.Instances.END,
                CalendarContract.Instances.ALL_DAY,
                CalendarContract.Instances.RRULE,
            ),
            "${CalendarContract.Instances.CALENDAR_ID} = ?",
            arrayOf(calendarId),
            CalendarContract.Instances.BEGIN,
        )?.use { cursor ->
            while (cursor.moveToNext()) {
                rows.add(
                    mapOf(
                        "eventId" to cursor.getString(0),
                        "title" to cursor.getString(1),
                        "begin" to cursor.getLong(2),
                        "end" to cursor.getLong(3),
                        "allDay" to (cursor.getInt(4) == 1),
                        "rrule" to cursor.getString(5),
                    ),
                )
            }
        }
        return rows
    }
}
