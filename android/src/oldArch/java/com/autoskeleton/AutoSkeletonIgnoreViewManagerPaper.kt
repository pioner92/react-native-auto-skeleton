package com.autoskeleton.oldArch

import com.autoskeleton.AutoSkeletonIgnore
import com.autoskeleton.AutoSkeletonViewManager
import com.autoskeleton.R
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext

@ReactModule(name = AutoSkeletonViewManager.Companion.REACT_CLASS)
class AutoSkeletonIgnoreViewManagerPaper : SimpleViewManager<AutoSkeletonView>() {

  override fun getName() = REACT_CLASS

  override fun createViewInstance(context: ThemedReactContext): AutoSkeletonView {
    return AutoSkeletonView(context).apply {
      setTag(R.id.is_my_custom_child_view,true)
    }
  }

  companion object {
    const val REACT_CLASS = "AutoSkeletonIgnoreView"
  }
}
