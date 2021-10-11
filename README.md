# flutter_social_share

Share your media on social media

## Getting Started

### Android

Add uses permission in  `android/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="dev.aislandener.flutter_social_share_example">
    
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    
    ...
</manifest>
```

Add provider in  `android/src/main/AndroidManifest.xml`

```xml
<provider android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.flutter.social_share"
    android:exported="false"
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
    <files-path name="files" path="." />
</paths>
```

On Android 11 or higher it is necessary to enter a `queries` in `android/src/main/AndroidManifest.xml`

For Images:
```xml
<queries>
    <intent>
        <action android:name='com.instagram.share.ADD_TO_STORY' />
        <data android:mimeType='image/*' />
    </intent>
</queries>
```

For Video:
```xml
<queries>
    <intent>
        <action android:name='com.instagram.share.ADD_TO_STORY' />
        <data android:mimeType='video/*' />
    </intent>
</queries>
```

### iOS

Add in `ios\Runner\Info.plist`

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>instagram-stories</string>
</array>
```


## Usage

### Share to Instagram Story

```dart
FlutterSocialShare.shareToInstagram(
  backgroundAssetUri: image_or_movie,
  stickerAssetUri: image,
  topColor: Colors.deepPurple,
  bottomColor: Colors.pinkAccent
);
```

