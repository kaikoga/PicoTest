package picotest.tasks;

import haxe.ds.Option;
import picotest.result.PicoTestResult;

interface IPicoTestTask {
	var result(get, never):Option<PicoTestResult>;
	function start():Void;
	function resume(runner:PicoTestRunner):PicoTestTaskStatus;
}
