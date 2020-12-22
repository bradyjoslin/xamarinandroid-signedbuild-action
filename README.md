# Xamarin.Android Signed Build GitHub Action

Creates signed `apk` files for Xamarin.Android projects using GitHub Actions.

## Usage

Example usage in a worfklow:

```yaml
name: Build

on: workflow_dispatch

jobs:
  Android:
    name: Android
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: bradyjoslin/xamarinandroid-signedbuild-action@v1
        with:
          csproj_path: src/sample.Android/sample.Android.csproj
          signing_keystore: ${{ secrets.KEYSTORE }}
          keystore_password: ${{ secrets.KEYSTORE_PASS }}
          signing_key_alias: ${{ secrets.KEY_ALIAS }}
          signing_key_password: ${{ secrets.KEY_PASS }}
          configuration: "Release"
          mono_version: "preview"
          xamarin_android_version: "preview"
      - uses: actions/upload-artifact@v2
        with:
          name: ipa
          path: src/*.Android/bin/Android/Release/**Signed.apk
```

## Inputs

| input                   | value                                                                           | required?             |
| ----------------------- | ------------------------------------------------------------------------------- | --------------------- |
| csproj_path             | Path to csproj file                                                             | Y                     |
| signing_keystore        | Base64 representation of the keystore                                           | Y                     |
| keystore_password       | Keystore password                                                               | Y                     |
| signing_key_alias       | Signing key alias                                                               | Y                     |
| signing_key_password    | Signing key password                                                            | Y                     |
| configuration           | Build configuration                                                             | N - Default `Release` |
| mono_version            | Version of mono to use for build. `stable`, `preview` or url to pkg.            | N - Default `stable`  |
| xamarin_android_version | Version of Xamarin.Android to use for build. `stable`, `preview` or url to pkg. | N - Default `stable`  |

## FAQ

**How do you create base64 of the keystore file?**

`base64 keys.keystore > keystore.txt`

The contents of the text file is the keystore file in base64 format, which you can store as a GitHub Secret.

**How do I use specific versions of mono/Xamarin.Android for my build?**

This action uses [boots](https://github.com/jonathanpeppers/boots/). To install a specific version of mono and Xamarin.Android pass in the URL to the package of the version you would like to use. For details on how to find the URL to use, see the [boots doc](https://github.com/jonathanpeppers/boots/blob/master/docs/HowToFindBuilds.md).
