.PHONY: test test-android test-macos test-gallery test-detail \
        test-gallery-android test-gallery-macos test-detail-android test-detail-macos \
        report report-android report-open report-clean

# ─── Defaults (override on the fly: make test-gallery DEVICE=macos id=5) ──────
DEVICE      ?= emulator-5554
FILE        ?= integration_tests/tests/
REPORT_DIR  := reports

# ─── Base target — all other targets delegate here ────────────────────────────
test:
	flutter test $(FILE) -d $(DEVICE) $(if $(id),--name "\[TID:$(id)\]",) --reporter expanded

# ─── By device ────────────────────────────────────────────────────────────────
test-android:
	$(MAKE) test DEVICE=emulator-5554

test-macos:
	$(MAKE) test DEVICE=macos

# ─── By screen ────────────────────────────────────────────────────────────────
test-gallery:
	$(MAKE) test FILE=integration_tests/tests/gallery_screen_test.dart

test-detail:
	$(MAKE) test FILE=integration_tests/tests/detail_screen_test.dart

# ─── By screen + device ───────────────────────────────────────────────────────
test-gallery-android:
	$(MAKE) test FILE=integration_tests/tests/gallery_screen_test.dart DEVICE=emulator-5554

test-gallery-macos:
	$(MAKE) test FILE=integration_tests/tests/gallery_screen_test.dart DEVICE=macos

test-detail-android:
	$(MAKE) test FILE=integration_tests/tests/detail_screen_test.dart DEVICE=emulator-5554

test-detail-macos:
	$(MAKE) test FILE=integration_tests/tests/detail_screen_test.dart DEVICE=macos

# ─── Allure report ────────────────────────────────────────────────────────────
report:
	@echo "▶  Running tests on device: $(DEVICE)..."
	mkdir -p $(REPORT_DIR)/junit-results
	flutter test $(FILE) -d $(DEVICE) $(if $(id),--name "\[TID:$(id)\]",) --reporter json \
		| tojunit --output $(REPORT_DIR)/junit-results/junit.xml
	@echo "◎  Generating Allure report..."
	allure generate $(REPORT_DIR)/junit-results --clean -o $(REPORT_DIR)/allure-html
	@echo "✓  Opening report in browser..."
	allure open $(REPORT_DIR)/allure-html

report-android:
	$(MAKE) report DEVICE=emulator-5554

report-macos:
	$(MAKE) report DEVICE=macos

report-open:
	allure open $(REPORT_DIR)/allure-html

report-clean:
	rm -rf $(REPORT_DIR)
