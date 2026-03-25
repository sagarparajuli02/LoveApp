package com.example.loveday

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import com.example.loveday.R
import es.antonborri.home_widget.HomeWidgetPlugin

class MyHomeWidgetProvider : AppWidgetProvider() {

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        // Ensure we force an update when triggered
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val thisWidget = ComponentName(context, MyHomeWidgetProvider::class.java)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(thisWidget)
        onUpdate(context, appWidgetManager, appWidgetIds)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {




        // The home_widget package usually uses "HomeWidgetPreference"
        val prefs = context.getSharedPreferences("HomeWidgetPreference", Context.MODE_PRIVATE)

        // Read data - checking if they exist
        val partner1 = prefs.getString("partner1", null) ?: "empty"
        val partner2 = prefs.getString("partner2", null) ?: "empty"
        val totalDays = prefs.getInt("totalDays", 0)
        val daysToAnniversary = prefs.getInt("daysToAnniversary", 0)
        

        for (appWidgetId in appWidgetIds) {
            // Use context.packageName to ensure we are referencing the correct R file
            val views = RemoteViews(context.packageName, R.layout.my_home_widget)
            val widgetData= HomeWidgetPlugin.getData(context)

                // Log.d("MyWidget", textFromFlutter)
            // Names
            views.setTextViewText(R.id.namesText, "$partner1 & $partner2")
            
            // Days Together (Optional: you can put this in dateText or titleText)
            views.setTextViewText(R.id.dateText, "$totalDays Days Together")
            
            // Countdown
            views.setTextViewText(R.id.daysLeftText, "$daysToAnniversary Days Left")

            // Progress Bar (Assuming a year cycle for the progress)
            val maxDays = 365
            val progress = if (maxDays > 0) {
                ((maxDays - daysToAnniversary).toFloat() / maxDays.toFloat() * 100).toInt().coerceIn(0, 100)
            } else 0
            
            views.setProgressBar(R.id.progressBar, 100, progress, false)
            views.setTextViewText(R.id.percentText, "$progress%")

            // Apply the update
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
