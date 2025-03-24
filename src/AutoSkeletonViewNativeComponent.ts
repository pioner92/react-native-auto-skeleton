import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { Float } from 'react-native/Libraries/Types/CodegenTypes';
import type { ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  isLoading: boolean;
  shimmerSpeed?: Float; // default = 1.0; speed of the shimmer effect;
  shimmerBackgroundColor?: string; // color in hex format; skeleton shapes background color;
  defaultRadius?: Float; // Radius for elements that don't have borderRadius; default = 4
}

export default codegenNativeComponent<NativeProps>('AutoSkeletonView');
