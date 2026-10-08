import fs from 'fs';
import path from 'path';

const root = path.resolve(__dirname, '../..');
const read = (relative: string) =>
  fs.readFileSync(path.join(root, relative), 'utf8');

describe('Old Architecture view config', () => {
  // The Old Arch JS view config is built from the type the manager exports for each prop.
  const exportedPropType = (prop: string) => {
    const manager = read('ios/React/AutoSkeletonViewManager.mm');
    const match = manager.match(
      new RegExp(`RCT_CUSTOM_VIEW_PROPERTY\\(${prop},\\s*([\\w<>* ]+?),`)
    );
    if (!match?.[1]) {
      throw new Error(`${prop} is not exported by AutoSkeletonViewManager`);
    }
    return match[1].trim();
  };

  const viewConfigFor = (nativeProps: Record<string, string>) => {
    jest.resetModules();
    jest.doMock('react-native/Libraries/ReactNative/UIManager', () => ({
      getViewManagerConfig: (name: string) =>
        name === 'AutoSkeletonView' ? { NativeProps: nativeProps } : null,
      // iOS does not use lazy view managers, so there are no constants to merge.
      getConstants: () => ({}),
    }));
    // Asset resolution pulls in Dimensions, whose Flow syntax this babel preset cannot parse.
    jest.doMock('react-native/Libraries/Image/resolveAssetSource', () =>
      jest.fn()
    );
    const getNativeComponentAttributes = require('react-native/Libraries/ReactNative/getNativeComponentAttributes');
    return getNativeComponentAttributes('AutoSkeletonView');
  };

  // Without a processor, raw color strings reach RCTConvert and become an empty array (#20).
  it('converts gradientColors to native colors before they reach the manager', () => {
    const processColorArray = require('react-native/Libraries/StyleSheet/processColorArray');
    const colors = ['#D3D3D3', '#FFFFFF'];

    const attribute = viewConfigFor({
      gradientColors: exportedPropType('gradientColors'),
    }).validAttributes.gradientColors;

    expect(typeof attribute.process).toBe('function');
    expect(attribute.process(colors)).toEqual(processColorArray(colors));
    expect(attribute.process(colors).every(Number.isInteger)).toBe(true);
  });

  it('converts shimmerBackgroundColor to a native color', () => {
    const attribute = viewConfigFor({
      shimmerBackgroundColor: exportedPropType('shimmerBackgroundColor'),
    }).validAttributes.shimmerBackgroundColor;

    expect(typeof attribute.process).toBe('function');
    expect(Number.isInteger(attribute.process('#CECECE'))).toBe(true);
  });
});

describe('Fabric component registration', () => {
  const pkg = JSON.parse(read('package.json'));
  const provider: Record<string, string> =
    pkg.codegenConfig?.ios?.componentProvider ?? {};

  const specComponents = fs
    .readdirSync(path.join(root, 'src'))
    .filter((file) => file.endsWith('NativeComponent.ts'))
    .map((file) => {
      const match = read(`src/${file}`).match(
        /codegenNativeComponent<\w+>\(\s*'(\w+)'/
      );
      return match?.[1];
    })
    .filter((name): name is string => Boolean(name))
    .sort();

  const objcSources = fs
    .readdirSync(path.join(root, 'ios/React'))
    .filter((file) => file.endsWith('.mm'))
    .map((file) => read(`ios/React/${file}`))
    .join('\n');

  it('declares a component provider entry for every codegen component', () => {
    expect(specComponents.length).toBeGreaterThan(0);
    expect(Object.keys(provider).sort()).toEqual(specComponents);
  });

  it.each(specComponents)(
    'maps %s to a Fabric component view class',
    (name) => {
      const className = provider[name];

      expect(className).toBeDefined();
      expect(objcSources).toMatch(
        new RegExp(`@implementation ${className}\\b`)
      );
      expect(objcSources).toMatch(
        new RegExp(`Class<RCTComponentViewProtocol> ${name}Cls\\(void\\)`)
      );
    }
  );
});
