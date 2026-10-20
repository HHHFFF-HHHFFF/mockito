# Mockito #3592 regression-test evidence

Group task: [HHHFFF-HHHFFF/mockito#2](https://github.com/HHHFFF-HHHFFF/mockito/issues/2).

Test commit: [`e1fc0d5baeb5966c789a2f4f7dd2d8bd6307a05e`](https://github.com/HHHFFF-HHHFFF/mockito/commit/e1fc0d5baeb5966c789a2f4f7dd2d8bd6307a05e).

This evidence branch supports internal review. Its files are kept outside the test branch so the proposed code change contains only two test source files.

## Results from the recorded Windows runs

The two runs use the same 12 new tests and 16 existing tests, Microsoft OpenJDK 17.0.18 and Gradle Wrapper 8.14.2. Build-cache reuse, test retries and up-to-date skipping of the test task were disabled.

| Implementation | New tests | Existing tests | Spotless Java |
|---|---|---|---|
| Original production code | 5 pass, 7 fail on message assertions | 16 pass | Pass |
| Isolated reference modification | 12 pass | 16 pass | Pass |

The reference modification follows the suggestion already made in [upstream #3592](https://github.com/mockito/mockito/issues/3592). It is not Wancheng's production fix. These results validate the test patch; the actual implementation and full-core/CI verification remain outstanding.

## Original artifacts

- Red run: [log](red-v2/gradle.log), [command](red-v2/command.txt), [run record](red-v2/run.json), [new-test XML](red-v2/TEST-org.mockitousage.annotation.DoNotMockMessageTest.xml), [existing-test XML](red-v2/TEST-org.mockitousage.annotation.DoNotMockTest.xml).
- Reference-green run: [log](green-reference-v2/gradle.log), [command](green-reference-v2/command.txt), [run record](green-reference-v2/run.json), [new-test XML](green-reference-v2/TEST-org.mockitousage.annotation.DoNotMockMessageTest.xml), [existing-test XML](green-reference-v2/TEST-org.mockitousage.annotation.DoNotMockTest.xml).
- [Verification summary](verification-summary.json).
- [Test-only patch](tests-only-v2.patch), SHA-256 `31D081387B3D09C6EAEE55CE3232A65053C6FA1A81873ACD6C0460010FF38A72`.
- [Original reference modification](reference-candidate-v1.patch).
- [Original Windows evidence runner](Original-Windows-Runner.ps1), [local rerun helper](Invoke-RegressionChecks.ps1), [no-retry / forced-execution init script](no-retry.init.gradle).
- [Original artifact hashes](SHA256-manifest.json).

The copied files retain their original bytes, including execution-time paths. Local attributes disable text normalization for this evidence directory; original log whitespace and line endings are retained. The verification summary describes the state when validation finished, before the subsequent review and commit; its historical pending/uncommitted fields have not been rewritten.

## Rerunning in another checkout

Use JDK 17 and a checkout of the test commit above. Download or check out this evidence branch separately. Run from the test checkout, replacing the init-script path with its actual location:

```text
java -jar gradle/wrapper/gradle-wrapper.jar :mockito-core:test --tests org.mockitousage.annotation.DoNotMockMessageTest --tests org.mockitousage.annotation.DoNotMockTest :mockito-core:spotlessJavaCheck --continue --no-build-cache --no-daemon --no-scan --console=plain --init-script /absolute/path/to/no-retry.init.gradle
```

The original implementation should give seven failed tests. To reproduce the reference-green experiment, use a separate worktree at the same test commit, apply only `reference-candidate-v1.patch`, and run the same command. Record that change separately from the real production fix. The original PowerShell runners contain the original machine paths; the command above is the checkout-independent equivalent.

## Review and attribution

Yifan Hou owns the regression-test task. Test drafting and the recorded Windows executions were assisted by Codex. Wancheng Xu owns the production repair.

Chenze Deng (@Forgottttt) posted a [pre-commit review](https://github.com/HHHFFF-HHHFFF/mockito/issues/2#issuecomment-6286105612) of the exact test-patch hash and reported no blocking comments. He requested accessible original logs and scripts; the links above address that request. His separately reported macOS validation is recorded in his comment and is not presented as an independently rerun result here.

Formal PR review, validation against Wancheng's actual revision and the remaining group/tutor checks still need to be completed before an upstream PR is considered.
