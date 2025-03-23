import React, { useEffect } from 'react';
import { View, StyleSheet, Text, Image, TouchableOpacity } from 'react-native';
import { AutoSkeletonView } from 'react-native-auto-skeleton';

interface IProfile {
  name: string;
  jobTitle: string;
  avatar: string;
}

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

const getProfile = async (): Promise<IProfile> => {
  await delay(2000);
  return {
    name: 'Alex Last-Name',
    jobTitle: 'React Native Developer',
    avatar: require('../assets/avatar.png'),
  };
};

export default function App() {
  const [isLoading, setIsLoading] = React.useState(false);
  const [profile, setProfile] = React.useState<IProfile>({});

  const init = async () => {
    setIsLoading(true);
    const res = await getProfile();
    setProfile(res);
    setIsLoading(false);

    await delay(2000);

    setIsLoading(true);
    // await delay(3000);
    const res2 = await getProfile();
    setProfile(res2);
    setIsLoading(false);
  };

  useEffect(() => {
    init();
  }, []);

  return (
    <>
      <View style={s.container}>
        <Text style={{ fontSize: 20, textAlign: 'center', marginBottom: 20 }}>
          IS LOADING: {isLoading ? 'true' : 'false'}
        </Text>
        <AutoSkeletonView isLoading={isLoading}>
          <View style={s.avatarWithName}>
            <Image style={s.avatar} source={profile.avatar} />
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
    </>
  );
}

const s = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 70,
    paddingHorizontal: 20,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  avatarWithName: {
    flexDirection: 'row',
    columnGap: 20,
  },
  avatar: {
    width: 100,
    height: 100,
    borderRadius: 12,
  },
  name: {
    width: '100%',
    fontSize: 30,
    fontWeight: 'bold',
    marginTop: 10,
  },
  jobTitle: {
    width: '100%',
    fontSize: 20,
    color: '#666',
    marginTop: 5,
  },
  buttons: {
    marginTop: 20,
    flexDirection: 'row',
    justifyContent: 'center',
    columnGap: 20,
  },
  button: {
    flex: 1,
    alignItems: 'center',
    paddingVertical: 10,
    backgroundColor: 'black',
    borderRadius: 10,
  },
  buttonTitle: {
    color: 'white',
    fontSize: 20,
    fontWeight: 'bold',
  },
});
