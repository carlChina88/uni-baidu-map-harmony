# Contributing

Thanks for helping improve `uni-baidu-map-harmony`.

> English is the default language. Expand the Chinese section at the end for
> the Chinese contribution guide.

## Scope

Contributions should stay focused on the generic HarmonyOS UTS adapter. Please
do not add host-application pages, business state, API clients, location
permission flows, private assets, or credentials.

## Before opening a pull request

1. Read the README and third-party notices.
2. Run `node scripts/verify-sdk.mjs`.
3. Describe the HarmonyOS, HBuilderX, uni-app, and Baidu SDK versions used for
   any runtime behavior change.
4. Include the exact device or simulator behavior for native changes.
5. Explain any permission, privacy, license, or vendor-SDK impact.

Harmony compilation and device testing require a real host application and
vendor SDK artifact. Do not upload that artifact, an AK, signing files, or
private application resources in a pull request.

## Pull requests

Keep pull requests small and document behavior changes in `CHANGELOG.md` when
appropriate. Maintainers may request a reproducer before accepting changes to
the native bridge.

<details>
<summary>中文</summary>

感谢你帮助改进 `uni-baidu-map-harmony`。

## 范围

贡献应聚焦于通用的 HarmonyOS UTS 适配器。请不要加入宿主应用页面、业务状态、
API 客户端、定位权限流程、私有资源或凭据。

## 创建 Pull Request 前

1. 阅读 README 和第三方声明。
2. 运行 `node scripts/verify-sdk.mjs`。
3. 如果涉及运行时行为变化，请说明使用的 HarmonyOS、HBuilderX、uni-app 和
   百度 SDK 版本。
4. 对原生改动说明真实设备或模拟器上的具体表现。
5. 说明权限、隐私、许可证或 Vendor SDK 影响。

Harmony 编译和设备测试需要真实的宿主应用与 Vendor SDK 文件。Pull Request 中
不要上传该文件、AK、签名文件或私有应用资源。

## Pull Request

保持 Pull Request 范围小而明确；如有必要，在 `CHANGELOG.md` 中记录行为变化。
维护者可能会要求提供最小复现，以便接收原生桥接改动。

</details>
