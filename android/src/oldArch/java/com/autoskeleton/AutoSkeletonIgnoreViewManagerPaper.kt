package com.autoskeleton.oldArch


import AutoSkeletonIgnoreView
import com.autoskeleton.R
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager

@ReactModule(name = AutoSkeletonIgnoreViewManagerPaper.Companion.REACT_CLASS)
class AutoSkeletonIgnoreViewManagerPaper : ViewGroupManager<AutoSkeletonIgnoreView>() {

  override fun getName() = REACT_CLASS

  override fun createViewInstance(context: ThemedReactContext): AutoSkeletonIgnoreView {
    return AutoSkeletonIgnoreView(context).apply {
      setTag(R.id.is_my_custom_child_view,true)
    }
  }

  companion object {
    const val REACT_CLASS = "AutoSkeletonIgnoreView"
  }
}
