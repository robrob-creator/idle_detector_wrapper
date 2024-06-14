class IdleDetectorController {
  late Function _resetTimer;
  late Function _stopTimer;

  void setTimerFunctions(Function resetTimer, Function stopTimer) {
    _resetTimer = resetTimer;
    _stopTimer = stopTimer;
  }

  void resetTimer() {
    _resetTimer();
  }

  void stopTimer() {
    _stopTimer();
  }
}
