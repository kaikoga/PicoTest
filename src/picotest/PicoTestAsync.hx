package picotest;

import haxe.PosInfos;

#if (flash || js || java)

import haxe.Timer;
import picotest.tasks.PicoTestTriggeredTestTask;
import picotest.tasks.PicoTestDelayedTestTask;

class PicoTestAsync {

	public static function assertLater<T>(func:Void->Void, delayMs:Int):Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		PicoTest.currentRunner.add(new PicoTestDelayedTestTask(taskResult.className, taskResult.methodName, func, delayMs));
	}

	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		var task:PicoTestTriggeredTestTask = new PicoTestTriggeredTestTask(taskResult.className, taskResult.methodName, func, timeoutFunc);
		if (timeoutMs > 0) {
			Timer.delay(task.createTimeoutCallback(PicoTest.currentRunner, p), timeoutMs);
		}
		return task.createCallback(PicoTest.currentRunner, p);
	}

}

#else

import picotest.PicoAssert.*;

class PicoTestAsync {

	public static function assertLater<T>(func:Void->Void, delayMs:Int):Void {
		fail("assertLater() not supported in platform");
	}

	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		fail("createCallback() not supported in platform");
		return emptyCallback;
	}

	private static function emptyCallback():Void {}

}
#end
