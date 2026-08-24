# Third-party notices

> English is the default language. Expand the Chinese section at the end for
> the Chinese third-party notices.

## Baidu HarmonyOS NEXT map SDK

The adapter imports the `@bdmap/navi_map` package through the local HAR path
declared in `utssdk/app-harmony/config.json`. The expected vendor artifact is
named `navi_map-2.0.5.har`; verify its embedded package metadata, version, and
license notice when obtaining the artifact.

The HAR is intentionally excluded from this public repository because it is a
large vendor artifact and its redistribution status should be verified against
the current official download and service terms by each maintainer. Obtain the
artifact from Baidu or another authorized source before building.

Baidu's current official product page lists the HarmonyOS NEXT map package as
`@bdmap/map` version `2.0.5`, while this adapter currently targets the
`@bdmap/navi_map` aggregate package declared in `config.json`. Treat the package
name as part of the build contract: if the official artifact you obtain is
`@bdmap/map`, update the imports and dependency mapping together and verify the
exported API before release.

Official references:

- [Baidu HarmonyOS NEXT SDK download](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/sdkandev-download)
- [Baidu HarmonyOS NEXT compliance guide](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/privacyagreemen_new)
- [Baidu product and service privacy policy](https://lbs.baidu.com/index.php?title=openprivacy)

The MIT license in this repository applies only to the adapter source, not to
the Baidu SDK, its assets, or the Baidu Maps service.

<details>
<summary>中文</summary>

## 百度 HarmonyOS NEXT 地图 SDK

适配器通过 `utssdk/app-harmony/config.json` 中声明的本地 HAR 路径导入
`@bdmap/navi_map`。预期的 Vendor 文件名为 `navi_map-2.0.5.har`；取得文件后，
请核对其中的包元数据、版本和许可证声明。

该 HAR 文件较大，仓库有意不提交。每位维护者都应根据当前官方发布信息和服务
条款确认其再分发状态，并从百度或其他授权来源取得文件后再构建。

百度当前官方产品页列出的 HarmonyOS NEXT 地图包为 `@bdmap/map` 2.0.5，而本适配器
当前使用 `config.json` 中声明的 `@bdmap/navi_map` 聚合包。包名属于构建契约的一
部分；如果取得的是 `@bdmap/map`，必须同时更新导入、依赖映射并验证导出 API。

官方参考：

- [百度 HarmonyOS NEXT SDK 下载](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/sdkandev-download)
- [百度 HarmonyOS NEXT 合规指南](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/privacyagreemen_new)
- [百度产品及服务隐私政策](https://lbs.baidu.com/index.php?title=openprivacy)

本仓库的 MIT 许可证只适用于适配器源码，不适用于百度 SDK、其资源或百度地图
服务。

</details>
