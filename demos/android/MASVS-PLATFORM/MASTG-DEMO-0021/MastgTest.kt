package org.owasp.mastestapp

import android.app.Activity
import android.content.Context
import android.os.Build
import android.view.WindowManager.LayoutParams

class MastgTest (private val context: Context){

    var shouldRunInMainThread: Boolean = true

    fun mastgTest(): String {
        if (context is Activity) {
            context.window.addFlags(LayoutParams.FLAG_SECURE)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                context.setRecentsScreenshotEnabled(false)
            }

            return "SUCCESS!!\n\nThe FLAG_SECURE has been set"
        } else {
            return "ERROR: Context is not an Activity"
        }
    }
}
