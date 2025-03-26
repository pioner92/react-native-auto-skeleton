package com.autoskeleton

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

interface ViewManagerProvider {
  fun getViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>>
}
