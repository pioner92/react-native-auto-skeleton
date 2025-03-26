package com.autoskeleton

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.autoskeleton.oldArch.AutoSkeletonViewManagerPaper
import com.autoskeleton.oldArch.AutoSkeletonIgnoreViewManagerPaper

class AutoSkeletonViewPackage : ReactPackage {
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    return listOf(
      AutoSkeletonViewManagerPaper(),
      AutoSkeletonIgnoreViewManagerPaper()
    )
  }

  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> = emptyList()
}
