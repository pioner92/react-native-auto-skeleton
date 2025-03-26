/**
 * @type {import('@react-native-community/cli-types').UserDependencyConfig}
 */
module.exports = {
  dependency: {
    platforms: {
      android: {
        javaPackageName: 'com.autoskeleton',
        cmakeListsPath: 'generated/jni/CMakeLists.txt',
      },
      ios: {
        // включаем codegen для iOS
        codegenConfig: {
          name: 'MyNativeModuleSpec', // может быть любым
          type: 'components',
          jsSrcsDir: './src', // папка где лежат ваши *.ts или *.tsx компоненты
        },
      },
    },
  },
};
