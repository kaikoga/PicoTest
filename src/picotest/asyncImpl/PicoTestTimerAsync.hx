package picotest.asyncImpl;

import picotest.result.PicoTestResult;
import picotest.tasks.PicoTestTriggeredTestTask;
import picotest.tasks.PicoTestDelayedTestTask;
import haxe.Timer;

import haxe.PosInfos;

#if (flash || js || java)

@:noDoc
class PicoTestTimerAsync {

	public static function assertLater<T>(func:Void->Void, delayMs:Int, ?p:PosInfos):Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		PicoTest.currentRunner.add(new PicoTestDelayedTestTask(taskResult, func, delayMs));
	}

	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		var task:PicoTestTriggeredTestTask = new PicoTestTriggeredTestTask(taskResult, func, timeoutFunc);
		if (timeoutMs > 0) {
			Timer.delay(task.createTimeoutCallback(PicoTest.currentRunner, p), timeoutMs);
		}
		return task.createCallback(PicoTest.currentRunner, p);
	}

}

#end
