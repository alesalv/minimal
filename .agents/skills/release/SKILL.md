---
name: release
description: Automates the full release process for the Minimal package. Invoke by saying "release X.Y.Z" where X.Y.Z is the version number. Handles Flutter update, dependency upgrades, lint rules refresh, version bumping, changelog, testing, git merge/tag/push, GitHub release, and pub.dev publish preparation.
---

# Release Skill for Minimal

This skill automates the release process for the `minimal_mvn` Flutter package.

## Prerequisites

- `fvm` is installed and available
- `gh` CLI is installed and authenticated
- The working directory is the root of the `minimal` repository
- You are on the `main` branch with a clean working tree

## Steps

### Step 0 — Parse version and create branch

1. Parse the version number `{VERSION}` from the user's request (e.g. "release 2.0.3" → `2.0.3`)
2. Verify we are on `main` with a clean working tree:
   ```
   git status --porcelain
   ```
3. Create and checkout the release branch:
   ```
   git checkout -b rc-{VERSION}
   ```

### Step 1 — Update Flutter to latest stable

1. Check the latest stable Flutter version by running:
   ```
   fvm releases | grep -B1 "stable" | head -5
   ```
   Identify the latest stable version number.
2. Install and use the new version:
   ```
   fvm use {FLUTTER_VERSION}
   ```
   This will automatically update `.fvmrc`.
3. Verify the version:
   ```
   fvm flutter --version
   ```
4. Commit this step:
   ```
   git add -A && git commit -m "Use Flutter {FLUTTER_VERSION}"
   ```

### Step 2 — Update dependencies (minimal package)

1. Upgrade dependencies:
   ```
   fvm flutter pub upgrade --major-versions
   ```
2. Resolve and lock:
   ```
   fvm flutter pub get
   ```
3. Commit:
   ```
   git add -A && git commit -m "Update minimal dependencies"
   ```

### Step 3 — Update lint rules (minimal package)

1. Run the script to automatically fetch the latest active lint rules from the Dart SDK:
   ```
   fvm dart run scripts/update_lint_rules.dart
   ```
   This will automatically update `all_lint_rules.yaml`.
2. Run the analyzer:
   ```
   fvm dart analyze
   ```
3. If the analyzer reports **conflicting rules**, **STOP and ask the user** which rule to disable in `analysis_options.yaml`. Explain the conflict clearly. **Do NOT modify `analysis_options.yaml` yourself — only the user decides which rules to disable.**
4. If there are analysis errors caused by new lint rules (not conflicts), fix the code to comply with the new rules.
5. Run the analyzer again to verify clean:
   ```
   fvm dart analyze
   ```
6. Commit:
   ```
   git add -A && git commit -m "Update lint rules"
   ```

### Step 4 — Update dependencies (example app)

1. Upgrade example dependencies:
   ```
   cd example && fvm flutter pub upgrade --major-versions && cd ..
   ```
2. Resolve and lock:
   ```
   cd example && fvm flutter pub get && cd ..
   ```
3. Commit dependency updates (if any):
   ```
   git add -A && git commit -m "Update example dependencies"
   ```
4. Run the model generation script to update Dart Mappable files:
   ```
   cd example && ./scripts/generate_models.sh && cd ..
   ```
5. Check if there are any changes to the generated files, and if so, commit them separately:
   ```
   git add -A && git commit -m "Update example generated models"
   ```

### Step 5 — Update lint rules (example app)

1. Copy the updated lint rules to the example:
   ```
   cp all_lint_rules.yaml example/all_lint_rules.yaml
   ```
2. Run the analyzer on the example:
   ```
   cd example && fvm dart analyze && cd ..
   ```
3. If the analyzer reports **conflicting rules**, **STOP and ask the user** which rule to disable. Do NOT modify `example/analysis_options.yaml` yourself.
4. If there are analysis errors caused by new lint rules (not conflicts), fix the code to comply.
5. Commit:
   ```
   git add -A && git commit -m "Update example lint rules"
   ```

### Step 6 — Update version and changelog

1. Update the `version:` field in `pubspec.yaml` to `{VERSION}`.
2. Check if the `environment` constraints in `pubspec.yaml` need widening. The range should be as broad as possible, but the upper limits must accommodate the new Flutter/Dart versions. Only widen — never narrow.
3. Prepend a new changelog section to `CHANGELOG.md`. The format is:
   ```markdown
   ## {VERSION}

   * Update to Flutter {FLUTTER_VERSION}
   * Update all lint rules
   * Update dependencies
   * Update example dependencies
   ```
   Add any additional bullet points for changes made during this release.
4. Commit:
   ```
   git add -A && git commit -m "Version {VERSION}"
   ```

### Step 7 — Run tests and verify

1. Run tests for the minimal package:
   ```
   fvm flutter test
   ```
2. Run tests for the example:
   ```
   cd example && fvm flutter test && cd ..
   ```
3. Run analysis on both:
   ```
   fvm dart analyze
   cd example && fvm dart analyze && cd ..
   ```
4. Run formatting check:
   ```
   fvm dart format --set-exit-if-changed .
   ```
5. Verify that the example app builds successfully for key platforms:
   ```
   cd example
   fvm flutter build web
   fvm flutter build macos
   fvm flutter build ios --simulator
   cd ..
   ```
6. If any test, check, or build fails, fix the issue and re-run.
7. Commit any fixes:
   ```
   git add -A && git commit -m "Fix tests, analysis, and builds"
   ```

### Step 8 — Ask for additional changes

**STOP and ask the user:**

> All automated updates are done and tests pass. Here's a summary of what changed:
> - Flutter updated to {FLUTTER_VERSION}
> - Dependencies upgraded (list any notable changes)
> - Lint rules updated (list any new rules added)
>
> Would you like to:
> 1. **Add more changes** to this release (new tests, API changes, example improvements)?
> 2. **Manually run the example app** to verify everything works?
> 3. **Proceed to finalize** the release?

If the user wants more changes, make them, commit each change separately, re-run tests, and ask again.

If the user wants to run the example app manually, wait for them to confirm it works before proceeding.

Loop until the user says to proceed.

### Step 9 — Squash merge, tag, and push

1. Switch to main:
   ```
   git checkout main
   ```
2. Squash merge the release branch (single commit on main):
   ```
   git merge --squash rc-{VERSION}
   git commit -m "Minimal {VERSION}"
   ```
3. Tag the release:
   ```
   git tag v{VERSION}
   ```
4. Push main and the tag:
   ```
   git push origin main
   git push origin v{VERSION}
   ```
   **If the push fails**, display a generic message: *"Push failed. Please check your GitHub identity and try again."* Do not include any specific account names, SSH key details, or commands to switch identity.
5. Delete the release branch:
   ```
   git branch -d rc-{VERSION}
   ```

### Step 10 — Create GitHub release

1. Extract the changelog section for `{VERSION}` from `CHANGELOG.md` (everything between `## {VERSION}` and the next `## ` heading).
2. Create the release:
   ```
   gh release create v{VERSION} --repo alesalv/minimal --title "Minimal {VERSION}" --notes "{CHANGELOG_CONTENT}"
   ```

### Step 11 — Publish to pub.dev (manual)

**Do NOT publish automatically.** Instead, display this message:

> ✅ Release v{VERSION} is complete!
>
> **To publish to pub.dev, run this command manually:**
> ```
> fvm flutter pub publish
> ```
>
> After publishing, verify at: https://pub.dev/packages/minimal_mvn

## Important Rules

- **Never modify `analysis_options.yaml`** in either root or example. Only the user decides which lint rules to disable.
- **Never include sensitive data** (credentials, account names, SSH key paths) in commits, messages, or any file that goes into the repository.
- **Each step gets its own commit** on the `rc-` branch. The final merge to `main` is a single squash commit.
- **Always use `fvm flutter` and `fvm dart`** instead of bare `flutter` and `dart` commands.
- **On push failure**, only display a generic identity check message.
