// export { default as AutoSkeletonView } from './AutoSkeletonViewNativeComponent';
export { default as AutoSkeletonIgnoreView } from './AutoSkeletonIgnoreViewNativeComponent';
import { ColorValue, Platform, processColor } from 'react-native';
import { default as AutoSkeletonView__ } from './AutoSkeletonViewNativeComponent';
import { useMemo } from 'react';
import React from 'react';

interface IProps {
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
  shimmerSpeed?: number;

  /**
   * Background color for the skeleton shapes.
   *
   * @example "#E0E0E0"
   */
  shimmerBackgroundColor?: string;

  /**
   * Gradient colors for the skeleton gradient.
   *
   * @example ["#cccccc", "#F0F0F0"]
   */
  gradientColors?: [string, string];

  /**
   * Default corner radius applied to skeleton elements that don't have an explicit `borderRadius`.
   *
   * @default 4
   */
  defaultRadius?: number;

  /**
   * The animation type to use for the skeleton view.
   *
   * - `gradient`: A gradient animation.
   * - `pulse`: A pulse animation.
   * - `none`: No animation.
   *
   * @default 'gradient'
   */
  animationType?: 'gradient' | 'pulse' | 'none';
}

const DEFAULT_GRADIENT_COLORS: ColorValue[] = ['#D3D3D3', '#FFFFFF'];
const DEFAULT_BORDER_RADIUS = 4;
const DEFAULT_ANIMATION_DURATION = 1.0; // seconds

export const AutoSkeletonView: React.FC<React.PropsWithChildren<IProps>> =
  React.memo((props) => {
    const gColors = useMemo(() => {
      //@ts-ignore
      if (Platform.OS === 'ios' && global._IS_FABRIC === false) {
        return (props.gradientColors ?? DEFAULT_GRADIENT_COLORS).map((color) =>
          processColor(color)
        ) as ColorValue[];
      }

      return props.gradientColors ?? DEFAULT_GRADIENT_COLORS;
    }, [props.gradientColors]);

    return (
      <AutoSkeletonView__
        {...props}
        gradientColors={gColors}
        shimmerBackgroundColor={props.shimmerBackgroundColor ?? '#CECECE'}
        defaultRadius={props.defaultRadius ?? DEFAULT_BORDER_RADIUS}
        shimmerSpeed={props.shimmerSpeed ?? DEFAULT_ANIMATION_DURATION}
      />
    );
  });
