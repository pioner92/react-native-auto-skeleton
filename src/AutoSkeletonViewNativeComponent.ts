import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { Float } from 'react-native/Libraries/Types/CodegenTypes';
import type { ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  isLoading: boolean;
  shimmerSpeed?: Float;
  shimmerBackgroundColor?: string;
}

export default codegenNativeComponent<NativeProps>('AutoSkeletonView');
