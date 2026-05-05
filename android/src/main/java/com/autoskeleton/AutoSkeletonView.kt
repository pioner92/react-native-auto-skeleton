package com.autoskeleton
import android.animation.ValueAnimator
import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Shader
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import android.view.animation.LinearInterpolator
import com.facebook.react.bridge.ReadableArray
import java.util.WeakHashMap

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
  private var radius = 4f * resources.displayMetrics.density

  private var animationType = AnimationTypes.GRADIENT

  private var shapesBackgroundColor = Color.parseColor("#DDDDDD")

  private var colorA = Color.parseColor("#DDDDDD")

  private var colorB = Color.parseColor("#F3F3F3")

  private val paint = Paint(Paint.ANTI_ALIAS_FLAG)
  private var animationFraction = 0f
  private val originalVisibility = WeakHashMap<View, Int>()
  private val originalAlpha = WeakHashMap<View, Float>()

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
    if (value != null && value.size() == 2) {
      colorA = value.getInt(0)
      colorB = value.getInt(1)
    } else {
      colorA = Color.LTGRAY
      colorB = Color.WHITE
    }

    invalidate()
  }

  fun setDefaultRadius(value: Float) {
    radius = value * resources.displayMetrics.density
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
    child.animate().cancel()
    originalVisibility.remove(child)
    originalAlpha.remove(child)
    super.onViewRemoved(child)
    requestLayout()
    invalidate()
  }

  override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
    setMeasuredDimension(widthMeasureSpec , heightMeasureSpec)
  }

  override fun dispatchDraw(canvas: Canvas) {
    super.dispatchDraw(canvas)

    for (i in 0 until childCount) {
      val child = getChildAt(i)

      val isMyChild = child.getTag(R.id.is_my_custom_child_view) as? Boolean == true

      if(isMyChild){
        continue
      }

      if(isLoading){
        if (!originalVisibility.containsKey(child)) {
          originalVisibility[child] = child.visibility
          originalAlpha[child] = child.alpha
        }

        child.animate().cancel()
        child.visibility = INVISIBLE
        canvas.drawRoundRect(
          child.left.toFloat(),
          child.top.toFloat(),
          child.right.toFloat(),
          child.bottom.toFloat(),
          radius,
          radius,
          paint
        )
      }
      else {
        val visibility = originalVisibility.remove(child)
        val alpha = originalAlpha.remove(child)

        if (visibility != null) {
          child.animate().cancel()
          child.visibility = visibility

          if (visibility == VISIBLE) {
            val targetAlpha = alpha ?: 1f
            child.alpha = 0f
            child.animate()
              .alpha(targetAlpha)
              .setDuration(800)
              .start()
          } else if (alpha != null) {
            child.alpha = alpha
          }
        }
      }
    }
  }

  override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
  }
}
