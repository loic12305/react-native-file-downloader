# react-native-file-downloader

Boring to try to use `rn-fetch-blob` or the fork `react-native-fetch-blob` or another fork

This module provide a simple way to download file from API to Download (Android) / Documents(iOS)

## Installation

`$ yarn add rn-file-downloader`

## Permissions

### Android

Add this permissions in `AndroidManifest.xml`

```
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS

Add this permissions in `Info.plist`

```
<key>UIFileSharingEnabled</key>
<true/>
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
```

## Usage

### Methods

| Name               | Description                                                     | Arguments                                         | Return value      |
|--------------------|-----------------------------------------------------------------|---------------------------------------------------|-------------------|
| downloadFile       | Download a file in Download/Document | url: string, filename: string, headers: stringify | storePath: string |


### Sample

```javascript
import { downloadFile } from "rn-file-downloader";

//...

downloadFile(
        'https://picsum.photos/200/300',
        'my-picture.jpg',
        JSON.stringify({
            Authorization: 'Bearer ' + accessToken,
        })
    )
    .then((path: string) => {
        //...
    })
    .catch((error: string) => {
        //...
    });
```
