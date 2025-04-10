package com.autoskeleton

import AutoSkeletonIgnoreView
import android.view.View
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.IViewGroupManager
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.AutoSkeletonIgnoreViewManagerDelegate
import com.facebook.react.viewmanagers.AutoSkeletonIgnoreViewManagerInterface

@ReactModule(name = AutoSkeletonIgnoreViewManager.REACT_CLASS)
class AutoSkeletonIgnoreViewManager(context: ReactApplicationContext) : SimpleViewManager<AutoSkeletonIgnoreView>(),
    AutoSkeletonIgnoreViewManagerInterface<AutoSkeletonIgnoreView>,
    IViewGroupManager<AutoSkeletonIgnoreView>
{
  private val mDelegate: ViewManagerDelegate<AutoSkeletonIgnoreView> =
      AutoSkeletonIgnoreViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<AutoSkeletonIgnoreView> = mDelegate

  override fun getName(): String = REACT_CLASS

  public override fun createViewInstance(context: ThemedReactContext): AutoSkeletonIgnoreView {
    return AutoSkeletonIgnoreView(context).apply {
      setTag(R.id.is_my_custom_child_view,true)
    }
  }

  companion object {
    const val REACT_CLASS = "AutoSkeletonIgnoreView"
  }

  override fun getChildAt(parent: AutoSkeletonIgnoreView, index: Int): View {
    return parent.getChildAt(index)
  }

  override fun getChildCount(parent: AutoSkeletonIgnoreView): Int {
    return parent.childCount
  }

  override fun addView(parent: AutoSkeletonIgnoreView, child: View, index: Int) {
    parent.addView(child, index)
  }

  override fun removeViewAt(parent: AutoSkeletonIgnoreView, index: Int) {
    parent.removeViewAt(index)
  }

  override fun needsCustomLayoutForChildren(): Boolean {
    return false
  }
}
