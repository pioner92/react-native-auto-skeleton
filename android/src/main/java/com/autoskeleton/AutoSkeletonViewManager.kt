package com.autoskeleton

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.AutoSkeletonViewManagerInterface
import com.facebook.react.viewmanagers.AutoSkeletonViewManagerDelegate

@ReactModule(name = AutoSkeletonViewManager.NAME)
class AutoSkeletonViewManager : SimpleViewManager<AutoSkeletonView>(),
  AutoSkeletonViewManagerInterface<AutoSkeletonView> {
  private val mDelegate: ViewManagerDelegate<AutoSkeletonView>

  init {
    mDelegate = AutoSkeletonViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<AutoSkeletonView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): AutoSkeletonView {
    return AutoSkeletonView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: AutoSkeletonView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "AutoSkeletonView"
  }
}
