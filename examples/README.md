# Example

`basic-map.vue` is a focused host-page example. It is not a complete uni-app
project and must be copied into a HarmonyOS-capable uni-app application.

Before opening the page:

1. Install the plugin under `src/uni_modules/uni-baidu-map-harmony/`.
2. Add the legally obtained Baidu HAR to the plugin `libs` directory.
3. Configure `VITE_BAIDU_MAP_HARMONY_KEY` in the host app.
4. Add the required Harmony permissions.
5. Replace `acceptPrivacyPolicy()` with the host app's real consent flow.
6. Add `marker.png` to the host app's rawfile resources if a marker is used.

The example intentionally starts with `privacyAgreed: false`; do not change
that default to `true` before the host app has obtained explicit user consent.
