# Release checklist

Use this checklist before creating a public GitHub release.

> English is the default language. Expand the Chinese section at the end for
> the Chinese release checklist.

## Source and dependency checks

- [ ] Run `node scripts/verify-sdk.mjs`.
- [ ] Confirm the adapter imports match the vendor HAR actually used.
- [ ] Confirm the vendor HAR is not committed unless redistribution has been
      explicitly verified.
- [ ] Review the vendor SDK version, changelog, license, privacy policy, and
      required permissions.
- [ ] Update `CHANGELOG.md` and the version in `package.json`.

## Privacy and security checks

- [ ] No real Baidu AK, signing material, user data, or host-app environment
      files are present.
- [ ] The README still requires explicit privacy consent before initialization.
- [ ] `oaidEnabled` and `APP_TRACKING_CONSENT` remain opt-in.
- [ ] The host app's privacy policy identifies Baidu as a third-party SDK.

## GitHub checks

- [ ] Confirm the repository description and topics identify the project as an
      independent, unofficial adapter.
- [ ] Enable Issues and Discussions only if they will be monitored.
- [ ] Review the MIT wrapper license and third-party notice together.
- [ ] Create a signed or annotated tag after the source review.
- [ ] Attach no vendor binary to the release unless its distribution terms are
      clear and the notice is updated.

<details>
<summary>中文</summary>

创建公开 GitHub Release 前使用此清单。

## 源码和依赖检查

- [ ] 运行 `node scripts/verify-sdk.mjs`。
- [ ] 确认适配器导入与实际使用的 Vendor HAR 一致。
- [ ] 确认未提交 Vendor HAR，除非已明确确认再分发许可。
- [ ] 检查 Vendor SDK 版本、变更记录、许可证、隐私政策和所需权限。
- [ ] 更新 `CHANGELOG.md` 和 `package.json` 中的版本。

## 隐私和安全检查

- [ ] 未包含真实百度 AK、签名材料、用户数据或宿主应用环境文件。
- [ ] README 仍要求在初始化前取得明确隐私同意。
- [ ] `oaidEnabled` 和 `APP_TRACKING_CONSENT` 仍保持主动选择启用。
- [ ] 宿主应用隐私政策明确百度是第三方 SDK。

## GitHub 检查

- [ ] 仓库描述和 topics 将项目标识为独立、非官方适配器。
- [ ] 只有在有人维护时才启用 Issues 和 Discussions。
- [ ] 同时检查 MIT 包装器许可证和第三方声明。
- [ ] 源码审查后创建签名或带注释的 tag。
- [ ] 除非分发条款明确且已更新声明，否则不要在 Release 附加 Vendor 二进制文件。

</details>
