package com.autoskeleton
import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Shader
import android.transition.Fade
import android.transition.TransitionManager
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import android.view.animation.LinearInterpolator
import com.facebook.react.bridge.ReadableArray

enum class AnimationTypes(val value: String) {
  GRADIENT("gradient"),
  PULSE("pulse"),
  NONE("none");
}

class AutoSkeletonView : ViewGroup {
  constructor(context: Context?) : super(context)
  constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)
  constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(
    context,
    attrs,
    defStyleAttr
  )

  private var isLoading = false
  private var shimmerSpeed = 1.0f
  private var radius = 10f

  private var animationType = AnimationTypes.GRADIENT

  private var shapesBackgroundColor = Color.parseColor("#DDDDDD")

  private var colorA = Color.parseColor("#DDDDDD")

  private var colorB = Color.parseColor("#F3F3F3")

  private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
  private var animationFraction = 0f

  private var animator: ValueAnimator? = null

  init {
    setWillNotDraw(false)
  }

  fun setIsLoading(value: Boolean) {
    if (isLoading == value) return
    isLoading = value

    if(value){
      startShimmer()
    }
    else {
      stopShimmer()
    }

    requestLayout()
    invalidate()
  }

  fun setShimmerSpeed(value: Float) {
    shimmerSpeed = value
    if (isLoading) {
      stopShimmer()
      startShimmer()
    }
  }

  fun setShimmerBackgroundColor(value: Int?) {
    shapesBackgroundColor = value ?: Color.LTGRAY
    paint.color = shapesBackgroundColor
    invalidate()
  }

  fun setGradientColors(value: ReadableArray?) {
    if(value != null){
      colorA = value.getInt(0)
      colorB = value.getInt(1)
    }
    invalidate()
  }

  fun setDefaultRadius(value: Float) {
    radius = value
    invalidate()
  }

  fun setAnimationType(value: String?) {
    animationType = AnimationTypes.values().find {
      it.value.equals(value, ignoreCase = true)
    } ?: AnimationTypes.GRADIENT

    paint.shader = null
    paint.alpha = 255
    invalidate()
  }

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    stopShimmer()
  }

  private fun startShimmer() {
    if (animator != null) return

    animator = ValueAnimator.ofFloat(0.0f,1.0f).apply {
      duration = (shimmerSpeed * 1000).toLong()
      repeatMode = ValueAnimator.REVERSE
      repeatCount = ValueAnimator.INFINITE
      interpolator = LinearInterpolator()
      addUpdateListener {
        animationFraction = it.animatedFraction

        when(animationType){
          AnimationTypes.GRADIENT ->{
            val shader = LinearGradient(
              0f, 0f, width.toFloat(), 0f,
              intArrayOf(blendColors(colorA,colorB,animationFraction), blendColors(colorB,colorA,animationFraction), blendColors(colorA,colorB,animationFraction)),
              floatArrayOf(0f, 0.5f, 1f),
              Shader.TileMode.CLAMP
            )
            paint.shader = shader
          }
          AnimationTypes.PULSE -> {
            val scaled = 0.5f + animationFraction * 0.5f
            paint.alpha = (scaled * 255).toInt().coerceIn(0, 255)
          }
          AnimationTypes.NONE -> {}
        }

        invalidate()
      }
      start()
    }
  }

  private fun stopShimmer() {
    animator?.cancel()
    animator = null
  }

  private fun blendColors(from: Int, to: Int, ratio: Float): Int {
    val inverse = 1f - ratio
    val r = Color.red(from) * inverse + Color.red(to) * ratio
    val g = Color.green(from) * inverse + Color.green(to) * ratio
    val b = Color.blue(from) * inverse + Color.blue(to) * ratio
    return Color.rgb(r.toInt(), g.toInt(), b.toInt())
  }

  override fun onViewAdded(child: View?) {
    super.onViewAdded(child)
    requestLayout()
    invalidate()
  }

  override fun onViewRemoved(child: View) {
    super.onViewRemoved(child)
    requestLayout()
    invalidate()
  }

  override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
    setMeasuredDimension(widthMeasureSpec , heightMeasureSpec)
  }

  override fun dispatchDraw(canvas: Canvas) {
    super.dispatchDraw(canvas)

    if(!isLoading){
      TransitionManager.beginDelayedTransition(this, Fade().apply {
        duration = 800
      })
    }

    for (i in 0 until childCount) {
      val child = getChildAt(i)

      val isMyChild = child.getTag(R.id.is_my_custom_child_view) as? Boolean == true

      if(isMyChild){
        continue
      }

      if(isLoading){
        child.visibility = INVISIBLE
        canvas.drawRoundRect(
          child.left.toFloat(),
          child.top.toFloat(),
          child.right.toFloat(),
          child.bottom.toFloat(),
          radius * 2,
          radius * 2,
          paint
        )
      }
      else {
        child.visibility = VISIBLE
      }
    }
  }

  override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
  }
}
