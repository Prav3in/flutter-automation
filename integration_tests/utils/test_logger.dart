// ignore_for_file: avoid_print
class TestLogger {
  TestLogger._();

  static void action(String page, String message) {
    print('[$page] ▶  $message');
  }

  static void verify(String page, String message) {
    print('[$page] ✓  $message');
  }

  static void result(String page, String message) {
    print('[$page] ◎  $message');
  }
}
