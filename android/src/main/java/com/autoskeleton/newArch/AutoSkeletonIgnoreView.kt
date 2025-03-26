package com.autoskeleton.newArch

import android.content.Context
import android.util.AttributeSet
import android.view.ViewGroup

class AutoSkeletonIgnoreView : ViewGroup {
  constructor(context: Context?) : super(context)
  constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)
  constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(
    context,
    attrs,
    defStyleAttr
  )

  init {
    setWillNotDraw(true)
  }

  override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {

  }
}
