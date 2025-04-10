package com.autoskeleton
import AutoSkeletonIgnoreView
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager

@ReactModule(name = AutoSkeletonIgnoreViewManager.Companion.REACT_CLASS)
class AutoSkeletonIgnoreViewManager(context: ReactApplicationContext) : ViewGroupManager<AutoSkeletonIgnoreView>() {

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
