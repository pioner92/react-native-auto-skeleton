// import {
//   withPlugins,
//   withInfoPlist,
//   withAndroidManifest,
// } from '@expo/config-plugins';

const {
  withPlugins,
  withInfoPlist,
  withAndroidManifest,
} = require('@expo/config-plugins');

// если нужно что-то дописать в Info.plist — можно здесь
const withAutoSkeletonIOS = (config) => {
  return withInfoPlist(config, (config) => {
    // config.modResults — это сам Info.plist в JS-виде
    // можно добавить, если нужно:
    // config.modResults.MySetting = 'Enabled';
    return config;
  });
};

// если нужно что-то дописать в AndroidManifest.xml — можно здесь
const withAutoSkeletonAndroid = (config) => {
  return withAndroidManifest(config, (config) => {
    // config.modResults.manifest — это AndroidManifest в JS-объекте
    // например, можно добавить permissions, metadata и т.п.
    return config;
  });
};

const withAutoSkeleton = (config) => {
  return withPlugins(config, [withAutoSkeletonIOS, withAutoSkeletonAndroid]);
};

module.exports = withAutoSkeleton;
