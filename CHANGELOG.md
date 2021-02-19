# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added

- Initial implementation ([#1])
- Manage NetworkPolicy/NetNS and client RBAC ([#2])
- Only create RoleBinding for proxy client if subjects is not empty ([#4])

[Unreleased]: https://github.com/appuio/component-openshift-prometheus-proxy/compare/feb66d43c1cc1c6e2031db9f04ea11fd7bd346a0...HEAD
[#1]: https://github.com/appuio/component-openshift-prometheus-proxy/pull/1
[#2]: https://github.com/appuio/component-openshift-prometheus-proxy/pull/2
[#4]: https://github.com/appuio/component-openshift-prometheus-proxy/pull/4
