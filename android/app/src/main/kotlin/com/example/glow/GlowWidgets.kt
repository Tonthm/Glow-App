package com.example.glow

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home screen widgets (CLAUDE.md section 15). They only draw the strings the
 * app saved; all the rules live in core/widget_content.dart.
 */
abstract class GlowWidget(private val layout: Int, private val detailed: Boolean) :
    HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, layout)
            views.setTextViewText(
                R.id.glow_headline,
                widgetData.getString("headline", null) ?: "เปิด Glow",
            )
            views.setTextViewText(
                R.id.glow_subtitle,
                widgetData.getString("subtitle", null) ?: "เพื่อดูเวลานอน",
            )
            val fire = widgetData.getString("fire", "0")?.toIntOrNull() ?: 0
            views.setInt(R.id.glow_lamp, "setImageAlpha", 76 + fire.coerceIn(0, 5) * 35)
            if (detailed) {
                bind(views, R.id.glow_dots, widgetData.getString("dots", ""))
                bind(views, R.id.glow_mode, widgetData.getString("mode", ""))
                bind(views, R.id.glow_now, widgetData.getString("now", ""))
                bind(views, R.id.glow_next, widgetData.getString("next", ""))
            }
            views.setOnClickPendingIntent(
                R.id.glow_root,
                HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("glow://tonight"),
                ),
            )
            appWidgetManager.updateAppWidget(id, views)
        }
    }

    private fun bind(views: RemoteViews, id: Int, value: String?) {
        views.setTextViewText(id, value ?: "")
        views.setViewVisibility(id, if (value.isNullOrEmpty()) View.GONE else View.VISIBLE)
    }
}

class GlowSmallWidget : GlowWidget(R.layout.glow_widget_small, false)

class GlowMediumWidget : GlowWidget(R.layout.glow_widget_medium, true)
