package picotest;

import picotest.macros.PicoTestConfig;
import picotest.asyncImpl.IPicoTestAsyncImpl;
import picotest.asyncImpl.PicoTestAsyncUnavailable;
import picotest.asyncImpl.PicoTestSysAsync;
import picotest.asyncImpl.PicoTestTimerAsync;

import haxe.PosInfos;

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
	public static function assertLater<T>(func:Void->Void, delayMs:Int, ?p:PosInfos):Void {
		return impl.assertLater(func, delayMs, p);
	}

	/**
		`func` will be called later, as long as returned callback is called prior `timeoutMs`.
		When callback is not called in `timeoutMs`, `timeoutFunc` is called if specified, otherwise test will emit a failure.
		Assertions in `func` and `timeoutFunc` are treated as part of current test method.
	**/
	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void {
		return impl.createCallback(func, timeoutMs, timeoutFunc, p);
	}

	private static var impl:IPicoTestAsyncImpl = selectImpl();
	private static function selectImpl():IPicoTestAsyncImpl {
		#if (flash || js || java)
		if (PicoTestConfig.timerAvailable) return new PicoTestTimerAsync();
		#end

		#if sys
		if (PicoTestConfig.thread) return new PicoTestSysAsync();
		#end

		return new PicoTestAsyncUnavailable();
	}
}
