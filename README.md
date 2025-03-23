# react-native-auto-skeleton

`react-native-auto-skeleton` is a lightweight and flexible skeleton loader for React Native apps. It automatically generates skeleton placeholders based on your UI components while data is loading, with no need to manually configure individual skeleton elements.

The library intelligently analyzes your layout structure, detecting the dimensions, position, and `borderRadius` of each component such as `View`, `Text`, `Image`, `TouchableOpacity`, and others. Based on this information, it renders a skeleton that precisely matches the shape and size of your original components, ensuring a smooth and native-like loading experience.

You can either wrap entire blocks of UI or individual components, giving you granular control over where and how the skeletons appear.

⚠️ **Currently supports only iOS with the New Architecture (Fabric)**.

## Features

- Automatically detects and applies skeletons based on component size, position, and shape.
- Supports `View`, `Text`, `Image`, `TouchableOpacity`, and other common React Native components.
- Automatically inherits `borderRadius` and dimensions from existing styles.
- Flexible API: wrap full layouts or specific elements.

## Installation

```bash
npm install react-native-auto-skeleton
```

or

```bash
yarn add react-native-auto-skeleton
```

## Example
<img src="./assets/demo.gif" width="300" />


## Usage

```tsx
import { AutoSkeletonView } from 'react-native-auto-skeleton';

interface IProfile {
  name: string;
  jobTitle: string;
  avatar: string;
}


const getProfile = async (): Promise<IProfile> => {
...
};

export default function App() {
  const [isLoading, setIsLoading] = React.useState(false);
  const [profile, setProfile] = React.useState<IProfile>({} as IProfile);

  const init = async () => {
    setIsLoading(true);
    const res = await getProfile();
    setProfile(res);
    setIsLoading(false);
  };

  useEffect(() => {
    init();
  }, []);

  return (
    <View style={s.container}>
      <AutoSkeletonView isLoading={isLoading}>
        <View style={s.avatarWithName}>
          <Image style={s.avatar} source={{ uri: profile.avatar }} />
          <View style={{ flex: 1 }}>
            <Text style={s.name}>{profile.name}</Text>
            <Text style={s.jobTitle}>{profile.jobTitle}</Text>
          </View>
        </View>
        <View style={s.buttons}>
          <TouchableOpacity style={s.button}>
            <Text style={s.buttonTitle}>Add</Text>
          </TouchableOpacity>
          <TouchableOpacity style={s.button}>
            <Text style={s.buttonTitle}>Delete</Text>
          </TouchableOpacity>
        </View>
      </AutoSkeletonView>
    </View>
  );
}
```

## Notes

- Skeleton applies automatically to any child components with `backgroundColor`, `Image`, `Text`, and buttons.
- Works out-of-the-box with your current styles (e.g., respects `borderRadius` and layout).
- Recommended to wrap entire sections for faster development or individual elements for granular control.

## License

MIT

