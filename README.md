# flutter_social_share

Share your media on social media

## Getting Started

### Android

Add provider in  `android/src/main/AndroidManifest.xml`

```xml
<provider android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.flutter.social_share" android:exported="false"
    android:grantUriPermissions="true">
    <meta-data android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/file_provider_paths" />
</provider>
```

Create file in `android/src/main/res/xml/file_provider_paths.xml` and add

```xml
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external" path="." />
    <external-files-path name="external_files" path="." />
    <external-cache-path name="external_cache" path="." />
</paths>
```

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/), a specialized package that includes
platform-specific implementation code for Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on
mobile development, and a full API reference.

