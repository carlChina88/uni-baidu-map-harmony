# Release checklist

Use this checklist before creating a public GitHub release.

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
