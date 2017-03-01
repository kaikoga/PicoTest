package picotest.tasks;

import picotest.result.PicoTestResult;

enum PicoTestTaskStatus {
	Initial;
	Continue;
	Complete(result:PicoTestResult);
	Done;
}
