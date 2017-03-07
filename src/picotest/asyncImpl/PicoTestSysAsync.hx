package picotest.asyncImpl;

import picotest.result.PicoTestResult;
import picotest.tasks.PicoTestDelayedTask;
import picotest.tasks.PicoTestTriggeredTestTask;
import picotest.tasks.PicoTestDelayedTestTask;

import haxe.PosInfos;

#if sys

@:noDoc
class PicoTestSysAsync implements IPicoTestAsyncImpl {

	public function new() return;

	public function assertLater<T>(func:Void->Void, delayMs:Int, ?p:PosInfos):Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		PicoTest.currentRunner.add(new PicoTestDelayedTestTask(taskResult, func, delayMs));
	}

	public function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		var task:PicoTestTriggeredTestTask = new PicoTestTriggeredTestTask(taskResult, func, timeoutFunc);
		if (timeoutMs > 0) {
			PicoTest.currentRunner.add(new PicoTestDelayedTask(task.createTimeoutCallback(PicoTest.currentRunner, p), timeoutMs));
		}
		return task.createCallback(PicoTest.currentRunner, p);
	}
}

#end
