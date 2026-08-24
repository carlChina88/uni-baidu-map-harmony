# uni-baidu-map-harmony

An open-source HarmonyOS NEXT native map embed for uni-app and UTS.

This repository contains the adapter layer that registers a native
`<embed tag="baidu-map" />` component and connects it to Baidu's HarmonyOS
NEXT map SDK. It was extracted from a working uni-app Harmony integration and
keeps the host application responsible for business state, location
permissions, coordinate conversion, navigation, and privacy-policy UI.

> The wrapper code in this repository is MIT-licensed. The Baidu SDK is a
> separate third-party dependency and is not covered by the wrapper license.
> See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

## Features

- HarmonyOS NEXT and `APP-HARMONY` only.
- Native `<embed tag="baidu-map" />` registration through `defineNativeEmbed`.
- Lazy, process-wide SDK initialization with a concurrent initialization guard.
- Explicit privacy-consent input before SDK initialization.
- Configurable BD09 map center and zoom level.
- Debounced `centerchange` events after map gestures.
- Optional single marker with an optional native `PopView` containing a name,
  distance, and address.
- No dependency on a host app's pages, stores, APIs, images, or location
  plugin.

## Non-goals

This plugin does not provide:

- H5 or WeChat map rendering.
- Device location or location permission requests.
- WGS84/GCJ02/BD09 coordinate conversion.
- Reverse geocoding, POI search, route planning, or navigation.
- A privacy dialog or a host application's privacy-policy implementation.

## Requirements

- A uni-app project that targets HarmonyOS NEXT.
- A recent HBuilderX/uni-app toolchain with native embed support. The official
  uni-app documentation introduced Harmony native embed support in HBuilderX
  4.62; verify the toolchain used by your application before integrating.
- HarmonyOS SDK/API level 12 or newer.
- A Baidu Maps HarmonyOS SDK AK whose package name and signing information
  match the host application.
- A legally obtained copy of the vendor HAR referenced by
  `utssdk/app-harmony/config.json`.

## Installation

### 1. Copy the plugin into the uni-app project

Copy the contents of this repository into:

```text
<your-uni-app-project>/src/uni_modules/uni-baidu-map-harmony/
```

The resulting plugin directory must contain `package.json` and `utssdk/`.

### 2. Add the Baidu SDK HAR locally

The repository intentionally does not commit the 47 MB vendor binary. Obtain
the SDK from Baidu's official distribution or from a source whose
redistribution terms you have verified, then place the file at:

```text
src/uni_modules/uni-baidu-map-harmony/utssdk/app-harmony/libs/navi_map-2.0.5.har
```

The current adapter targets the `@bdmap/navi_map` 2.0.5 HAR that was used by
the source integration. Baidu's current product page also lists the
`@bdmap/map` 2.0.5 package. Do not silently substitute a different package:
confirm its exported symbols and update `config.json` and imports together if
you choose to migrate.

Run the repository check from this directory:

```bash
node scripts/verify-sdk.mjs --require-sdk
```

### 3. Register Harmony permissions in the host app

The plugin does not edit the host application's generated Harmony project.
Add the permissions required by the SDK to the host app's Harmony module
configuration. At minimum, the Baidu compliance guide identifies these map
permissions:

```json5
{
  "requestPermissions": [
    {
      "name": "ohos.permission.INTERNET"
    },
    {
      "name": "ohos.permission.GET_NETWORK_INFO"
    }
  ]
}
```

Only add `ohos.permission.APP_TRACKING_CONSENT` when your app has chosen to
enable OAID collection and has completed the corresponding disclosure and
consent work. This adapter defaults `oaidEnabled` to `false`.

### 4. Obtain and protect an AK

Create a HarmonyOS SDK application in the Baidu Maps console. The AK must be
configured for the host app's package name and signing information. Keep it in
the host app's environment or release configuration; do not commit a real AK
to this repository.

## Basic usage

Import the plugin for its registration side effect, then use the native embed
on the Harmony branch:

```vue
<template>
  <view class="map-page">
    <!-- #ifdef APP-HARMONY -->
    <embed
      class="map"
      tag="baidu-map"
      :options="mapOptions"
      @ready="handleMapReady"
      @centerchange="handleCenterChange"
    />
    <!-- #endif -->
  </view>
</template>

<script setup>
import { ref } from 'vue'
import '@/uni_modules/uni-baidu-map-harmony'

const mapOptions = ref({
  apiKey: import.meta.env.VITE_BAIDU_MAP_HARMONY_KEY,
  // Set this to true only after the host app's privacy policy has been
  // explicitly accepted by the user.
  privacyAgreed: false,
  oaidEnabled: false,
  center: {
    lat: 22.147624,
    lon: 113.580231,
  },
  zoom: 16,
})

function handleMapReady(event) {
  if (event?.detail?.err) {
    console.error('Baidu Map failed to initialize:', event.detail.err)
  }
}

function handleCenterChange(event) {
  const { lat, lon } = event.detail
  console.log('Map center in BD09:', lat, lon)
}

// Call this after the host app's privacy consent flow completes:
// mapOptions.value = { ...mapOptions.value, privacyAgreed: true }
</script>

<style>
.map-page,
.map {
  width: 100%;
  height: 100%;
}
</style>
```

The host app should own the consent state. Passing `privacyAgreed: false`
prevents SDK initialization and reports an error through `ready`; changing it
to `true` allows the embed to initialize without remounting the page.

## Marker usage

`storeMarker` is optional. When it is supplied, the host app must provide a
marker image through `logo` or `defaultMarkerIcon`. The image path must be
valid in the host app's Harmony `rawfile` resources.

```js
const mapOptions = ref({
  apiKey: import.meta.env.VITE_BAIDU_MAP_HARMONY_KEY,
  privacyAgreed: true,
  oaidEnabled: false,
  defaultMarkerIcon: 'rawfile://marker.png',
  center: { lat: 22.147624, lon: 113.580231 },
  storeMarker: {
    lat: 22.147624,
    lon: 113.580231,
    logo: 'rawfile://store-logo.png',
    name: 'Example Store',
    distance: '350 m',
    address: 'Example address',
  },
})
```

When marker data changes, the previous marker is removed before the new marker
is added. In-flight marker updates are guarded so an older update cannot leave
an obsolete marker visible.

## Options and events

### `options`

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `apiKey` | `string` | required | Baidu Maps HarmonyOS SDK AK. |
| `privacyAgreed` | `boolean` | `false` | True only after host consent. |
| `oaidEnabled` | `boolean` | `false` | Whether the SDK may use OAID. |
| `center` | `{ lat, lon }` | Beijing | Initial and controlled center in BD09. |
| `zoom` | `number` | `16` | Initial zoom level. |
| `defaultMarkerIcon` | `string` | `rawfile://marker.png` | Fallback. |
| `storeMarker` | object | omitted | Optional single marker and PopView data. |

### `ready`

The event detail has the following shape:

```js
{
  err: Error | null,
  controller: null,
}
```

The native controller is intentionally kept on the ArkTS side and is not
serialized across the uni-app embed boundary. Treat `err === null` as the
successful readiness signal.

### `centerchange`

The event is emitted after a 500 ms debounce when the user finishes moving the
map:

```js
{
  lat: number,
  lon: number,
}
```

Coordinates are returned in Baidu BD09, matching the map SDK. No coordinate
conversion is performed by this plugin.

## Privacy and data handling

The host app must show its own privacy policy and obtain explicit consent
before setting `privacyAgreed: true`. It must also disclose that Baidu Maps is
a third-party SDK and link to the applicable Baidu privacy policy. The adapter
does not display consent UI and does not decide whether the host app's consent
is legally sufficient.

If OAID is not needed, keep `oaidEnabled: false` and do not request
`ohos.permission.APP_TRACKING_CONSENT`. Review the vendor's current compliance
guide whenever the SDK version changes.

## Development

This repository is intentionally dependency-light. The source check requires
Node.js only and does not build Harmony code:

```bash
node scripts/verify-sdk.mjs
```

To validate the vendor artifact as well:

```bash
node scripts/verify-sdk.mjs --require-sdk
```

Harmony compilation and device verification must be performed in a real
uni-app/HBuilderX host project with a valid AK, matching package/signature,
permissions, and the vendor HAR.

## License

The adapter source is released under the [MIT License](LICENSE). Baidu's SDK
and its embedded assets remain subject to their own license and service terms;
see [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).

## Official references

- [uni-app Harmony native embed](https://uniapp.dcloud.net.cn/tutorial/harmony/native-component.html)
- [Baidu HarmonyOS NEXT map SDK product download](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/sdkandev-download)
- [Baidu map display guide](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/guide/create-map/showmap)
- [Baidu marker guide](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/guide/render-map/point)
- [Baidu HarmonyOS compliance guide](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/privacyagreemen_new)
