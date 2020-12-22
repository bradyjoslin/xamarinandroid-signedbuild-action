#!/bin/bash

set -e

# Regenerate the keystore from base64
cd "$RUNNER_TEMP" || exit 1
echo  -n "$SIGNING_KEY" | base64 --decode --output android.keystore

# Setup build tools
export PATH="$PATH:~/.dotnet/tools"
dotnet tool install --global boots

if [ -n "$MONO_VERSION" ]
then
    case "$MONO_VERSION" in
        stable)
            boots --stable Mono
            ;;
        preview)
            boots --preview Mono
            ;;
        *)
            boots "$MONO_VERSION"
            ;;
    esac
else
    boots --stable Mono
fi

if [ -n "$XAMARIN_ANDROID_VERSION" ]
then
    case "$XAMARIN_ANDROID_VERSION" in
        stable)
            boots --stable XamarinAndroid
            ;;
        preview)
            boots --preview XamarinAndroid
            ;;
        *)
            boots "$XAMARIN_ANDROID_VERSION"
            ;;
    esac
else
    boots --stable XamarinAndroid
fi

if [ -z "$CONFIGURATION" ]
then
    CONFIGURATION=Release
fi

msbuild "$CSPROJ_PATH" /t:restore /verbosity:normal /t:Rebuild /t:SignAndroidPackage /p:Configuration="$CONFIGURATION" /p:AndroidKeyStore=true /p:AndroidSigningKeyAlias="$ALIAS" /p:AndroidSigningKeyPass="$SIGNING_KEY_PASS" /p:AndroidSigningKeyStore="$RUNNER_TEMP"/android.keystore /p:AndroidSigningStorePass="$KEY_STORE_PASSWORD"