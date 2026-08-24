# Example

`basic-map.vue` is a focused host-page example. It is not a complete uni-app
project and must be copied into a HarmonyOS-capable uni-app application.

> English is the default language. Expand the Chinese section at the end for
> the Chinese example guide.

Before opening the page:

1. Install the plugin under `src/uni_modules/uni-baidu-map-harmony/`.
2. Add the legally obtained Baidu HAR to the plugin `libs` directory.
3. Configure `VITE_BAIDU_MAP_HARMONY_KEY` in the host app.
4. Add the required Harmony permissions.
5. Replace `acceptPrivacyPolicy()` with the host app's real consent flow.
6. Add `marker.png` to the host app's rawfile resources if a marker is used.

The example intentionally starts with `privacyAgreed: false`; do not change
that default to `true` before the host app has obtained explicit user consent.

## Configuration and usage

Configure `VITE_BAIDU_MAP_HARMONY_KEY` in the host app, copy the legally obtained
HAR into the plugin's `libs` directory, and add the required Harmony permissions.
Import `examples/basic-map.vue` into a Harmony-capable uni-app page. After the
host privacy-consent flow completes, set `privacyAgreed` to `true`; the example
then initializes the native map without remounting the page.

<details>
<summary>中文</summary>

`basic-map.vue` 是一个精简的宿主页面示例，不是完整的 uni-app 项目，需要复制到
支持 HarmonyOS 的 uni-app 应用中使用。

打开页面前：

1. 将插件安装到 `src/uni_modules/uni-baidu-map-harmony/`。
2. 将合法取得的百度 HAR 添加到插件的 `libs` 目录。
3. 在宿主应用中配置 `VITE_BAIDU_MAP_HARMONY_KEY`。
4. 添加所需的 Harmony 权限。
5. 将 `acceptPrivacyPolicy()` 替换为宿主应用真实的隐私同意流程。
6. 如果使用 Marker，将 `marker.png` 添加到宿主应用的 rawfile 资源。

示例默认使用 `privacyAgreed: false`。宿主应用取得明确隐私同意前，不要将默认值
改为 `true`。

## 配置和使用

在宿主应用配置 `VITE_BAIDU_MAP_HARMONY_KEY`，将合法取得的 HAR 放入插件的
`libs` 目录，并添加所需 Harmony 权限。将 `examples/basic-map.vue` 引入支持
HarmonyOS 的 uni-app 页面。隐私同意流程完成后，将 `privacyAgreed` 更新为 `true`；
示例会在不重新挂载页面的情况下初始化原生地图。

</details>
