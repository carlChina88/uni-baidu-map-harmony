# Contributing

Thanks for helping improve `uni-baidu-map-harmony`.

## Scope

Contributions should stay focused on the generic HarmonyOS UTS adapter. Please
do not add host-application pages, stores, API clients, location permission
flows, private assets, or credentials.

## Before opening a pull request

1. Read the README and third-party notice.
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
