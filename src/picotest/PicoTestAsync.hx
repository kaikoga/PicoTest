package picotest;

import picotest.asyncImpl.PicoTestAsyncUnavailable;
import picotest.asyncImpl.PicoTestSysAsync;
import picotest.asyncImpl.PicoTestTimerAsync;

import haxe.PosInfos;

#if doc_gen

/**
	Static class containing async testing tools for PicoTest.
	Note that in some platform settings calls to these methods will actually fail.

	- On non-sys platforms (flash and js) and java, async callback is handled using standard `haxe.Timer.delay()`.
	- On sys platforms, if compiled with `-D picotest-thread`, async callback is handled internally using PicoTest task system.
	- Otherwise, attempts to create async callbacks will produce failure.
**/
extern class PicoTestAsync {

	/**
		`func` will be called after `delayMs`.
		Assertions in `func` are treated as part of current test method.
	**/
	public static function assertLater<T>(func:Void->Void, delayMs:Int, ?p:PosInfos):Void;

	/**
		`func` will be called later, as long as returned callback is called prior `timeoutMs`.
		When callback is not called in `timeoutMs`, `timeoutFunc` is called if specified, otherwise test will emit a failure.
		Assertions in `func` and `timeoutFunc` are treated as part of current test method.
	**/
	public static function createCallback<T>(func:Void->Void, ?timeoutMs:Int, ?timeoutFunc:Void->Void, ?p:PosInfos):Void->Void;

}
#elseif (flash || js || (java && !picotest_thread))
typedef PicoTestAsync = PicoTestTimerAsync;
#elseif (sys && picotest_thread)
typedef PicoTestAsync = PicoTestSysAsync;// wait it's Haxe 3.4 and we'll have Timer in here...
#else
typedef PicoTestAsync = PicoTestAsyncUnavailable;
#end
