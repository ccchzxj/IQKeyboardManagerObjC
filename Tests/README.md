# Toolbar regression

This fixture compiles the actual Objective-C source and presents two text fields with IQ's automatic keyboard toolbar. It checks the Chinese done title, 44pt height, solid capsule background, safe-area width, default/custom/black bar colors, shared-background suppression, previous/next/done actions, and keyboard reopening.

```sh
python3 Tests/run_checks.py --device SIMULATOR_UDID
```

An arm64 iOS simulator and the active Xcode SDK are required. Use `--output` for a result directory and `--display` when the simulator has multiple screens. The runner installs a separate test app and saves its result, compiler log and screenshot. Tests are excluded from the published Pod's source glob. This does not replace physical-device testing in the consuming apps.
