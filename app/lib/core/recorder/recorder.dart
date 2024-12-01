
abstract class Recorder {
  Future<void> init();
  Future<String> start();
  Future<void> stop();
}