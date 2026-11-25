package com.example.glow

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetBackgroundIntent

/**
 * Reminders are tied to local clock times, so they must be set again when the
 * time or timezone changes, even if the app is closed (CLAUDE.md section 5).
 */
class TimeChangeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_TIMEZONE_CHANGED &&
            intent.action != Intent.ACTION_TIME_CHANGED
        ) {
            return
        }
        HomeWidgetBackgroundIntent
            .getBroadcast(context, Uri.parse("glow://refresh"))
            .send()
    }
}
