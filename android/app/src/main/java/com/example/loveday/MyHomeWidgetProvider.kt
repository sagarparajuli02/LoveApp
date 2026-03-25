package com.example.loveday

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of Love Day Widget functionality.
 */
class MyHomeWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {

        for (appWidgetId in appWidgetIds) {

            // Get data saved from Flutter
            val widgetData = HomeWidgetPlugin.getData(context)

            val partner1 = widgetData.getString("partner1", null)
            val partner2 = widgetData.getString("partner2", null)
            val totalDays = widgetData.getInt("totalDays", 0)
            val daysToAnniversary = widgetData.getInt("daysToAnniversary", 0)

            val views = RemoteViews(context.packageName, R.layout.my_home_widget).apply {

                // Names
                setTextViewText(
                    R.id.namesText,
                    "${partner1 ?: "Partner 1"} & ${partner2 ?: "Partner 2"}"
                )

                // Days Together
                setTextViewText(
                    R.id.dateText,
                    "$totalDays Days Together"
                )

                // Countdown
                setTextViewText(
                    R.id.daysLeftText,
                    "$daysToAnniversary Days Left"
                )

                // Progress (365-day anniversary cycle)
                val maxDays = 365
                val progress = ((maxDays - daysToAnniversary).toFloat() / maxDays * 100)
                    .toInt()
                    .coerceIn(0, 100)

                setProgressBar(R.id.progressBar, 100, progress, false)
                setTextViewText(R.id.percentText, "$progress%")
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}