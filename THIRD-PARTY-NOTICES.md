# Third-party notices

## Baidu HarmonyOS NEXT map SDK

The adapter imports the `@bdmap/navi_map` package through the local HAR path
declared in `utssdk/app-harmony/config.json`. The source workspace from which
this adapter was extracted contained `navi_map-2.0.5.har`; its embedded package
metadata identified version `2.0.5` and an Apache-2.0 license notice from Baidu.

The HAR is intentionally excluded from this public repository because it is a
large vendor artifact and its redistribution status should be verified against
the current official download and service terms by each maintainer. Obtain the
artifact from Baidu or another authorized source before building.

Baidu's current official product page lists the HarmonyOS NEXT map package as
`@bdmap/map` version `2.0.5`, while this adapter currently targets the
`@bdmap/navi_map` aggregate package used by the extracted integration. Treat
the package name as part of the build contract: if the official artifact you
obtain is `@bdmap/map`, update the imports and dependency mapping together and
verify the exported API before release.

Official references:

- [Baidu HarmonyOS NEXT SDK download](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/sdkandev-download)
- [Baidu HarmonyOS NEXT compliance guide](https://lbsyun.baidu.com/docs/harmony?title=harmonynextsdk/privacyagreemen_new)
- [Baidu product and service privacy policy](https://lbs.baidu.com/index.php?title=openprivacy)

The MIT license in this repository applies only to the adapter source, not to
the Baidu SDK, its assets, or the Baidu Maps service.
