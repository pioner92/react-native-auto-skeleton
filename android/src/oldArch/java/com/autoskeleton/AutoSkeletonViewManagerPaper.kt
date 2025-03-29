package com.autoskeleton.oldArch

import android.graphics.Color
import com.autoskeleton.AutoSkeletonView
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.WritableArray
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp
import androidx.core.graphics.toColorInt

@ReactModule(name = AutoSkeletonViewManagerPaper.Companion.REACT_CLASS)
class AutoSkeletonViewManagerPaper : ViewGroupManager<AutoSkeletonView>() {

  override fun getName() = REACT_CLASS

  override fun createViewInstance(context: ThemedReactContext): AutoSkeletonView {
    return AutoSkeletonView(context)
  }

  @ReactProp(name = "isLoading")
  fun setIsLoading(view: AutoSkeletonView?, value: Boolean) {
    view?.setIsLoading(value)
  }

  @ReactProp(name = "shimmerSpeed")
  fun setShimmerSpeed(view: AutoSkeletonView?, value: Float) {
    view?.setShimmerSpeed(value)
  }

  @ReactProp(name = "shimmerBackgroundColor")
  fun setShimmerBackgroundColor(view: AutoSkeletonView?, value: String?) {
    val color = try {
      if (value != null) Color.parseColor(value) else  Color.GRAY
    } catch (e: IllegalArgumentException) {
      Color.GRAY
    }
    view?.setShimmerBackgroundColor(color)
  }

  @ReactProp(name = "gradientColors")
  fun setGradientColors(view: AutoSkeletonView?, value: ReadableArray?) {
    if(value != null && value.size() == 2){
      val color1 = value.getString(0)?.toColorInt()
      val color2 =  value.getString(1)?.toColorInt()

      val writableArray: WritableArray = Arguments.createArray()
      writableArray.pushInt(color1?: Color.LTGRAY)
      writableArray.pushInt(color2?: Color.WHITE)

      val colors: ReadableArray = writableArray
      view?.setGradientColors(colors)
    }
  }

  @ReactProp(name = "defaultRadius")
  fun setDefaultRadius(view: AutoSkeletonView?, value: Float) {
    view?.setDefaultRadius(value)
  }

  companion object {
    const val REACT_CLASS = "AutoSkeletonView"
  }
}
