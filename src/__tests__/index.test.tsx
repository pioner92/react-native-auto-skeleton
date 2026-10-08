import React from 'react';
import { Platform } from 'react-native';
import TestRenderer, { act } from 'react-test-renderer';
import { AutoSkeletonView } from '../index';

jest.mock('../AutoSkeletonViewNativeComponent', () => 'AutoSkeletonView');

const renderNativeProps = (element: React.ReactElement) => {
  let renderer!: TestRenderer.ReactTestRenderer;
  act(() => {
    renderer = TestRenderer.create(element);
  });
  return renderer.root.findByType('AutoSkeletonView' as never).props;
};

describe('AutoSkeletonView', () => {
  const originalOS = Platform.OS;

  afterEach(() => {
    Platform.OS = originalOS;
    // @ts-ignore
    delete global._IS_FABRIC;
  });

  it('applies the documented defaults', () => {
    const props = renderNativeProps(<AutoSkeletonView isLoading />);

    expect(props.isLoading).toBe(true);
    expect(props.gradientColors).toEqual(['#D3D3D3', '#FFFFFF']);
    expect(props.shimmerBackgroundColor).toBe('#CECECE');
    expect(props.defaultRadius).toBe(4);
    expect(props.shimmerSpeed).toBe(1.0);
  });

  it('passes user values through unchanged', () => {
    const props = renderNativeProps(
      <AutoSkeletonView
        isLoading={false}
        gradientColors={['red', 'blue']}
        shimmerBackgroundColor="#000000"
        defaultRadius={12}
        shimmerSpeed={2}
        animationType="pulse"
      />
    );

    expect(props.gradientColors).toEqual(['red', 'blue']);
    expect(props.shimmerBackgroundColor).toBe('#000000');
    expect(props.defaultRadius).toBe(12);
    expect(props.shimmerSpeed).toBe(2);
    expect(props.animationType).toBe('pulse');
  });

  // The native view config converts colors (processColorArray on Old Arch, codegen on Fabric);
  // converting in JS as well would hand native already-processed numbers to convert again.
  it.each([
    ['ios', undefined],
    ['ios', false],
    ['ios', true],
    ['android', false],
  ])(
    'never pre-processes gradientColors in JS (OS=%s, _IS_FABRIC=%s)',
    (os, isFabric) => {
      Platform.OS = os as typeof Platform.OS;
      // @ts-ignore
      global._IS_FABRIC = isFabric;

      const props = renderNativeProps(
        <AutoSkeletonView isLoading gradientColors={['#cccccc', '#F0F0F0']} />
      );

      expect(props.gradientColors).toEqual(['#cccccc', '#F0F0F0']);
    }
  );
});
