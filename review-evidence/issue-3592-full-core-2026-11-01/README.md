# #3592 full-core verification evidence

See [summary.md](summary.md) for results and [result.json](result.json) for the exact command, JDK, revision, timestamps and per-suite totals. This is the fresh 1 November 2026 run against production commit 566bace5, not the earlier 28-test selection or a reference patch. Tests were executed using JDK 21.0.12. All 390 JUnit XML files are in xml/.

Original local artifacts were checked against sha256.json before publication. Sharing copies replace only the local username path and machine hostname. publication-manifest.json records both original and published SHA256 hashes; sha256.json remains the original-run manifest. Original local files are preserved. The recorded command's init script is included as no-retry.gradle; adjust local paths when rerunning.

Tests ran with retries and build-cache reuse disabled and up-to-date reuse disabled for Test tasks, using one worker. Some compilation and static tasks were UP-TO-DATE. The full log distinguishes executed/reused tasks. This run does not cover every module or the upstream CI matrix. Evidence preparation and execution used Codex assistance for Wancheng Xu; no independent human approval is claimed.
