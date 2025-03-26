package com.autoskeleton
import android.view.View
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.IViewGroupManager
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.AutoSkeletonViewManagerInterface
import com.facebook.react.viewmanagers.AutoSkeletonViewManagerDelegate

@ReactModule(name = AutoSkeletonViewManager.REACT_CLASS)
class AutoSkeletonViewManager(context: ReactApplicationContext) : SimpleViewManager<AutoSkeletonView>(),
  AutoSkeletonViewManagerInterface<AutoSkeletonView>,
  IViewGroupManager<AutoSkeletonView>
{
  private val mDelegate: ViewManagerDelegate<AutoSkeletonView> = AutoSkeletonViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<AutoSkeletonView> = mDelegate

  override fun getName(): String = REACT_CLASS

  public override fun createViewInstance(context: ThemedReactContext): AutoSkeletonView = AutoSkeletonView(context)
  @ReactProp(name = "isLoading")
  override fun setIsLoading(view: AutoSkeletonView?, value: Boolean) {
    view?.setIsLoading(value)
  }

  @ReactProp(name = "shimmerSpeed")
  override fun setShimmerSpeed(view: AutoSkeletonView?, value: Float) {
    view?.setShimmerSpeed(value)
  }

  @ReactProp(name = "shimmerBackgroundColor")
  override fun setShimmerBackgroundColor(view: AutoSkeletonView?, value: Int?) {
    view?.setShimmerBackgroundColor(value)
  }

  @ReactProp(name = "defaultRadius")
  override fun setDefaultRadius(view: AutoSkeletonView?, value: Float) {
    view?.setDefaultRadius(value)
  }
  companion object {
    const val REACT_CLASS = "AutoSkeletonView"
  }

  override fun getChildAt(parent: AutoSkeletonView, index: Int): View {
    return parent.getChildAt(index)
  }

  override fun getChildCount(parent: AutoSkeletonView): Int {
    return parent.childCount
  }

  override fun addView(parent: AutoSkeletonView, child: View, index: Int) {
    parent.addView(child, index)
  }

  override fun removeViewAt(parent: AutoSkeletonView, index: Int) {
    parent.removeViewAt(index)
  }

  override fun needsCustomLayoutForChildren(): Boolean {
    return false
  }
}
