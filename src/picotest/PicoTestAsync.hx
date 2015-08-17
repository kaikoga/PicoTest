package picotest;

import picotest.tasks.PicoTestDelayedTask;
import picotest.tasks.PicoTestTriggeredTestTask;
import picotest.tasks.PicoTestDelayedTestTask;

import haxe.PosInfos;

#if (flash || js || (java && !picotest_thread))

import haxe.Timer;

/**
	Static class containing async testing tools for PicoTest.
	Note that in some platform settings calls to these methods will actually fail.

	- On non-sys platforms (flash and js) and java, async callback is handled using standard `haxe.Timer.delay()`. 
	- On sys platforms, if compiled with `-D picotest-thread`, async callback is handled internally using PicoTest task system. 
	- Otherwise, attempts to create async callbacks will produce failure.
**/
class PicoTestAsync {

	/**
		`func` will be called after `delayMs`.
		Assertions in `func` are treated as part of current test method.
	**/
	public static function assertLater<T>(func:Void->Void, delayMs:Int):Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		PicoTest.currentRunner.add(new PicoTestDelayedTestTask(taskResult, func, delayMs));
	}

	/**
		`func` will be called later, as long as returned callback is called prior `timeoutMs`.
		When callback is not called in `timeoutMs`, `timeoutFunc` is called if specified, otherwise test will emit a failure.
		Assertions in `func` and `timeoutFunc` are treated as part of current test method.
	**/
	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		var task:PicoTestTriggeredTestTask = new PicoTestTriggeredTestTask(taskResult, func, timeoutFunc);
		if (timeoutMs > 0) {
			Timer.delay(task.createTimeoutCallback(PicoTest.currentRunner, p), timeoutMs);
		}
		return task.createCallback(PicoTest.currentRunner, p);
	}

}

#elseif (sys && picotest_thread)

class PicoTestAsync {

	public static function assertLater<T>(func:Void->Void, delayMs:Int):Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		PicoTest.currentRunner.add(new PicoTestDelayedTestTask(taskResult, func, delayMs));
	}

	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		var taskResult:PicoTestResult = PicoTest.currentRunner.currentTaskResult;
		var task:PicoTestTriggeredTestTask = new PicoTestTriggeredTestTask(taskResult, func, timeoutFunc);
		if (timeoutMs > 0) {
			PicoTest.currentRunner.add(new PicoTestDelayedTask(task.createTimeoutCallback(PicoTest.currentRunner, p), timeoutMs));
		}
		return task.createCallback(PicoTest.currentRunner, p);
	}

}

#else

import picotest.PicoAssert.*;

@:noDoc
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
