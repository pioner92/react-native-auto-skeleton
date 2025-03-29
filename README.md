# React Native Auto Skeleton – Lightweight Skeleton Loader for React Native

**`react-native-auto-skeleton`** is a modern **skeleton loader for React Native**, designed to automatically render **loading placeholders** (shimmer-style) based on your existing layout.

> Ideal replacement for `react-native-skeleton-placeholder` and other manual solutions.


<div align="center" style="max-width: 400px; margin: auto;">
  <a href="https://www.npmjs.com/package/react-native-auto-skeleton">
    <img src="https://img.shields.io/npm/v/react-native-auto-skeleton.svg" alt="npm version" />
  </a>
  <a href="https://www.npmjs.com/package/react-native-auto-skeleton">
    <img src="https://img.shields.io/npm/dm/react-native-auto-skeleton.svg" alt="npm downloads" />
  </a>
  <img src="https://img.shields.io/badge/platform-iOS-blue?logo=apple" alt="iOS" />
  <img src="https://img.shields.io/badge/platform-Android-green?logo=android" alt="Android" />
  <img src="https://img.shields.io/badge/types-TypeScript-blue?logo=typescript" alt="TypeScript" />
  <img src="https://img.shields.io/badge/license-MIT-yellow.svg" alt="MIT License" />
  <a href="https://bundlephobia.com/result?p=react-native-auto-skeleton">
    <img src="https://img.shields.io/bundlephobia/minzip/react-native-auto-skeleton" alt="Bundle size" />
  </a>
</div>

## Demo
<p align="center">
<img src="./assets/demo.gif" width="500" alt="react-native-auto-skeleton demo" />
</p>

## ✅ Platform Support

| Platform | Old Arch | Fabric |
|----------|----------|--------|
| iOS      | ✅        | ✅      |
| Android  | ✅        | ✅      |

## Installation

Using npm:
```bash
npm install react-native-auto-skeleton
```

Using yarn:
```bash
yarn add react-native-auto-skeleton
```

## Usage

> ⚠️ **Warning:** On Android, automatic detection of a view’s border-radius is not supported. You can override it manually via the defaultRadius prop.

Here's a quick example to get started:


```tsx

import { AutoSkeletonView, AutoSkeletonIgnoreView } from 'react-native-auto-skeleton';
...

<AutoSkeletonView isLoading={isLoading}>
    ...YOUR VIEWS
  <AutoSkeletonIgnoreView> // Content that will be ignored by the skeleton
    ... Views without skeleton
  </AutoSkeletonIgnoreView>
</AutoSkeletonView>
```

Full example

```tsx
import { AutoSkeletonView } from 'react-native-auto-skeleton';

interface IProfile {
  name: string;
  jobTitle: string;
  avatar: string;
}

const getProfile = async (): Promise<IProfile> => {
  // Fetch profile data from your API
};

export default function App() {
  const [isLoading, setIsLoading] = useState(true);
  const [profile, setProfile] = useState<IProfile>({} as IProfile);

  useEffect(() => {
    (async () => {
      const res = await getProfile();
      setProfile(res);
      setIsLoading(false);
    })();
  }, []);

  return (
     <AutoSkeletonView isLoading={isLoading}>
      <View style={styles.avatarWithName}>
        <Image style={styles.avatar} source={{ uri: profile.avatar }} />
        <View style={{ flex: 1 }}>
          <Text style={styles.name}>{profile.name}</Text>
          <Text style={styles.jobTitle}>{profile.jobTitle}</Text>
        </View>
      </View>

      {/* This buttons block will have skeleton applied */}
      <View style={styles.buttons}>
        <TouchableOpacity style={styles.button}>
          <Text style={styles.buttonTitle}>Add</Text>
        </TouchableOpacity>
        <TouchableOpacity style={styles.button}>
          <Text style={styles.buttonTitle}>Delete</Text>
        </TouchableOpacity>
      </View>

      {/* Alternatively, to exclude buttons from skeleton rendering: */}
      <AutoSkeletonIgnoreView>
        <View style={styles.buttons}>
           ...
        </View>
      </AutoSkeletonIgnoreView>
    </AutoSkeletonView>
  );
}
```

## API
| Prop | type | Description |
|---|---|---|
| **isLoading** | boolean | Enables or disables the skeleton state|
| **shimmerSpeed** | number | Duration of one shimmer animation cycle in seconds. Lower values = faster shimmer |
| **shimmerBackgroundColor** | string | Background color of skeleton shapes |
| **gradientColors** | [string,string] | Gradient colors for the skeleton gradient |
| **defaultRadius** | number | Default corner radius for skeleton elements that don't have a defined `borderRadius` |   |

## Best Practices

- For rapid implementation, wrap entire UI sections with `<AutoSkeletonView>`.
- For precise control, wrap individual UI components or groups separately.
- Ensure components have clearly defined dimensions, backgrounds, or styles for optimal skeleton rendering.
- To exclude specific components from skeleton rendering, wrap them with `<AutoSkeletonIgnoreView>`. Any content inside this wrapper will not be processed by the skeleton system.

## 🔁 Alternative Solutions

You may also know:

- [`react-native-skeleton-placeholder`](https://github.com/chramos/react-native-skeleton-placeholder)
- [`react-content-loader`](https://github.com/danilowoz/react-content-loader)

If you're looking for a **React Native skeleton loader** that works **automatically**, with **Fabric support**, and no manual configuration, `react-native-auto-skeleton` is your go-to solution.

## License

[MIT](LICENSE)

---

## 📌 Keywords

React Native Skeleton, React Native Placeholder, react-native skeleton loader, react native shimmer, loading indicator React Native, Fabric placeholder view, auto skeleton view, react native content loader.
