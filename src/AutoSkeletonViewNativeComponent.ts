import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { Float } from 'react-native/Libraries/Types/CodegenTypes';
import type { ViewProps, ColorValue } from 'react-native';

export interface NativeProps extends ViewProps {
  /**
   * Enables or disables the skeleton state.
   * When `true`, skeleton placeholders will be shown over eligible views.
   */
  isLoading: boolean;

  /**
   * Duration of one shimmer animation cycle in seconds.
   *
   * - `1.0` second is the default speed (1 shimmer per second).
   * - Lower values will make the shimmer animate faster (e.g., `0.5` = 2 shimmers per second).
   * - Higher values will slow it down (e.g., `2.0` = 1 shimmer every 2 seconds).
   *
   * @default 1.0
   * @units seconds
   */
  shimmerSpeed?: Float;

  /**
   * Background color for the skeleton shapes.
   *
   * @example "#E0E0E0"
   */
  shimmerBackgroundColor?: ColorValue;

  /**
   * Gradient colors for the skeleton gradient.
   *
   * @example ["#cccccc", "#F0F0F0"]
   */
  gradientColors?: ColorValue[];

  /**
   * Default corner radius applied to skeleton elements that don't have an explicit `borderRadius`.
   *
   * @default 4
   */
  defaultRadius?: Float;
}

export default codegenNativeComponent<NativeProps>('AutoSkeletonView');
