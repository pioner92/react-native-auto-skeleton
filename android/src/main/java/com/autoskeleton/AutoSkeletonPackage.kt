package com.autoskeleton

import com.autoskeleton.newArch.AutoSkeletonIgnoreViewManager
import com.autoskeleton.oldArch.AutoSkeletonIgnoreViewManagerPaper
import com.autoskeleton.oldArch.AutoSkeletonViewManagerPaper
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager

class AutoSkeletonViewPackage : ReactPackage {
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
      return listOf(
        AutoSkeletonViewManager(reactContext),
        AutoSkeletonIgnoreViewManager(reactContext)
      )
    }
    else {
      return listOf(
        AutoSkeletonViewManagerPaper(),
        AutoSkeletonIgnoreViewManagerPaper()
      )
    }

  }

  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return emptyList()
  }
}
