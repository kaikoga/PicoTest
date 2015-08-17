package picotest.tasks;

import haxe.ds.Option;

interface IPicoTestTask {
	var result(get, never):Option<PicoTestResult>;
	function resume(runner:PicoTestRunner):PicoTestTaskStatus;
}
