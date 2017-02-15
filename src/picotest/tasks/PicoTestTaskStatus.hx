package picotest.tasks;

import picotest.result.PicoTestResult;

enum PicoTestTaskStatus {
	Continue;
	Complete(result:PicoTestResult);
	Done;
}
