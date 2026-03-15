# Gallery App

A Flutter photo gallery app with full integration test suite, Allure reporting, and a Makefile-driven test runner.

---

## Table of Contents

- [App Overview](#app-overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [App Features](#app-features)
- [Project Structure](#project-structure)
- [Testing](#testing)
  - [Test Architecture](#test-architecture)
  - [Test IDs](#test-ids)
  - [Running Tests](#running-tests)
  - [Allure Reports](#allure-reports)
- [Troubleshooting](#troubleshooting)

---

## App Overview

A dark-themed photo gallery that displays 12 photos in a scrollable grid. Users can view photo details, inspect metadata, and delete photos. Deleted photos can be bulk-restored via a hidden double-tap gesture on the title.

---

## Prerequisites

Install all of the following before attempting to run the app or tests.

### 1. Flutter SDK (3.41.4+)

```bash
# macOS — via Homebrew
brew install --cask flutter

# Verify installation
flutter doctor
```

All items in `flutter doctor` should be green before continuing. Pay attention to:
- Android toolchain (for Android testing)
- Xcode (for iOS/macOS testing)
- Connected device

### 2. Android Emulator (for Android testing)

Open Android Studio → Virtual Device Manager → create an emulator (API 30+ recommended).

Start it before running tests:
```bash
# List available emulators
flutter emulators

# Launch one
flutter emulators --launch <emulator_id>
```

### 3. Allure CLI (for HTML reports)

```bash
brew install allure

# Verify
allure --version
```

### 4. junitreport (for converting test output to Allure format)

```bash
dart pub global activate junitreport

# Add to PATH — add this line to your ~/.zshrc or ~/.bashrc
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Reload shell
source ~/.zshrc

# Verify
tojunit --help
```

### 5. make (pre-installed on macOS)

```bash
make --version
```

---

## Installation

```bash
# 1. Clone the repository
git clone <repo-url>
cd gallary

# 2. Install Flutter dependencies — required before opening in your IDE
#    Skipping this step will cause all Dart files to show red errors in the editor.
flutter pub get

# 3. Verify connected devices
flutter devices
```

---

## Running the App

```bash
# Run on the default connected device
flutter run

# Run on a specific device
flutter run -d emulator-5554   # Android emulator
flutter run -d macos           # macOS desktop
```

---

## App Features

| Feature | How to use |
|---|---|
| Browse photos | Scroll the grid on the home screen |
| View photo details | Tap any photo tile |
| View photo metadata | On the detail screen, tap the **ⓘ info** button |
| Dismiss info sheet | Tap outside the sheet or swipe it down |
| Delete a photo | On the detail screen, tap the **🗑 delete** button → confirm |
| Restore all photos | Double-tap the **"Gallery"** title on the home screen |

---

## Project Structure

```
gallary/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── models/
│   │   └── photo.dart                 # Photo data model
│   ├── data/
│   │   └── mock_photos.dart           # Static photo dataset (12 photos)
│   └── screens/
│       ├── home_screen.dart           # Gallery grid screen
│       └── detail_screen.dart         # Photo detail screen
│
├── integration_tests/
│   ├── tests/
│   │   ├── gallery_screen_test.dart   # Gallery screen test suite (TID:1,2,11–15)
│   │   └── detail_screen_test.dart    # Detail screen test suite (TID:3–10)
│   ├── pages/
│   │   ├── gallery.page.dart          # Page object — gallery screen actions & assertions
│   │   └── detail.page.dart           # Page object — detail screen actions & assertions
│   ├── locators/
│   │   ├── gallary.screen.dart        # Widget finders for gallery screen
│   │   └── detail.screen.dart         # Widget finders for detail screen
│   ├── data/
│   │   ├── gallery.screen.dart        # Test data constants for gallery tests
│   │   └── detail.screen.dart         # Test data constants for detail tests
│   └── utils/
│       ├── test_utils.dart            # Shared helpers (launchApp, settle, swipe, etc.)
│       └── test_logger.dart           # Step-level logger (prints to test output)
│
├── Makefile                           # All test run commands
└── reports/                           # Generated test reports (git-ignored)
```

---

## Testing

### Test Architecture

The test suite follows the **Page Object Model (POM)** pattern:

```
Test file  →  Page Object  →  Locators  →  Flutter widget tree
```

- **Tests** (`tests/`) — describe what to verify, call page methods only
- **Pages** (`pages/`) — encapsulate all actions and assertions per screen
- **Locators** (`locators/`) — all widget finders in one place, isolated from test logic
- **Data** (`data/`) — all hardcoded expected values (titles, counts, messages) centralised per screen
- **Utils** (`utils/`) — shared infrastructure (app launch, settling, logging)

Each test gets a **fresh app instance** automatically — `setUp()` calls `pumpWidget(MyApp())` which tears down and rebuilds the entire widget tree before every test.

---

### Test IDs

Every test has a unique `[TID:N]` identifier used for filtering.

#### Gallery Screen (`gallery_screen_test.dart`)

| TID | Test |
|---|---|
| TID:1 | Verify Gallery Screen Loads Correctly |
| TID:2 | Verify Photo Count Matches Grid Items |
| TID:11 | Verify Photo Deletion |
| TID:12 | Verify Gallery Updates After Deletion |
| TID:13 | Verify Multiple Deletions |
| TID:14 | Verify Restore Deleted Photos Feature |
| TID:15 | Verify App State Consistency After Restore |

#### Detail Screen (`detail_screen_test.dart`)

| TID | Test |
|---|---|
| TID:3 | Verify Opening Photo Details |
| TID:4 | Verify Photo Display in Details Screen |
| TID:5 | Verify Info Popover Opens |
| TID:6 | Verify Info Popover Content |
| TID:7 | Verify Popover Can Be Closed by Tapping Outside |
| TID:8 | Verify Popover Can Be Closed by Swiping Down |
| TID:9 | Verify Delete Dialog Appears |
| TID:10 | Verify Cancel Delete Action |

---

### Running Tests

All test commands are run from the **project root** via `make`.

#### Run all tests

```bash
make test-android       # Android emulator (default)
make test-macos         # macOS desktop
```

#### Run by screen

```bash
make test-gallery               # Gallery tests → Android
make test-detail                # Detail tests  → Android
make test-gallery-android       # Gallery tests → Android (explicit)
make test-gallery-macos         # Gallery tests → macOS
make test-detail-android        # Detail tests  → Android
make test-detail-macos          # Detail tests  → macOS
```

#### Run a single test by TID

```bash
make test-android id=1          # Run TID:1 on Android
make test-macos id=6            # Run TID:6 on macOS
make test-gallery id=2          # Run TID:2, gallery file only
make test-detail id=9           # Run TID:9, detail file only
```

#### Override device on the fly

```bash
make test DEVICE=emulator-5554 id=11
make test-gallery DEVICE=macos id=1
```

#### Change the default device permanently

Edit the top of `Makefile`:
```makefile
DEVICE ?= emulator-5554   # change this to your preferred device ID
```

---

### Allure Reports

Example report:

<img width="1324" height="836" alt="Screenshot 2026-03-15 at 12 49 16 PM" src="https://github.com/user-attachments/assets/d59aefcf-8ccd-43f2-aa53-4d8e963daf22" />


Allure provides a full HTML report with step-by-step logs, timelines, and pass/fail history.

#### Generate and open report

```bash
make report-android             # Run all tests on Android → open report
make report-macos               # Run all tests on macOS   → open report
make report id=15               # Run TID:15 only          → open report
```

#### Re-open the last generated report (without re-running tests)

```bash
make report-open
```

#### Delete all report files

```bash
make report-clean
```

The report opens automatically at `http://127.0.0.1:<port>` in your default browser. Press `Ctrl+C` in the terminal to stop the server when done.

#### What the report shows

- Pass / fail / broken status per test
- Full step-by-step log for each test (every action, assertion, and result)
- Duration per test and total suite duration
- Error message and stack trace for failures
- History trend across multiple runs

---

## Troubleshooting

### `make: 'test' is up to date`
Flutter projects have a `test/` directory which confuses Make. This is already fixed with `.PHONY` in the Makefile. If you see this, ensure you're running the latest `Makefile` from the project root.

### `tojunit: command not found`
The Dart pub cache bin directory is not on your PATH.
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```
Add this to your `~/.zshrc` or `~/.bashrc` to make it permanent.

### `allure: command not found`
```bash
brew install allure
```

### `No connected devices found`
```bash
flutter devices          # list what's connected
flutter emulators        # list available emulators
flutter emulators --launch <id>   # start one
```

### Tests pass locally but fail on a slow emulator
Increase the settle timeout in `integration_tests/utils/test_utils.dart`:
```dart
static const Duration _settleTimeout = Duration(seconds: 20); // was 10
```

### `flutter doctor` shows issues
Run `flutter doctor -v` for verbose output and fix each item flagged with `✗` before running the app or tests.
