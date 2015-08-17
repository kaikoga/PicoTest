package picotest.tasks;

enum PicoTestTaskStatus {
	Continue;
	Complete(result:PicoTestResult);
}
