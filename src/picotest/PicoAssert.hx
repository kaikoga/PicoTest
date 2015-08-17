package picotest;

import haxe.PosInfos;

#if !picotest_nodep
import org.hamcrest.AssertionException;
import org.hamcrest.Exception;
import org.hamcrest.Matcher;
import org.hamcrest.MatcherAssert;
#end

class PicoAssert {

	public static function fail(message:String = null, ?p:PosInfos):Void {
		if (message == null) message = "Assertion failed";
		PicoTest.currentRunner.failure(message, p);
	}

	public static function assertTrue(value:Bool, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = "Expected true but was false";
		if (value) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure(message, p);
	}

	public static function assertFalse(value:Bool, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = "Expected false but was true";
		if (value) PicoTest.currentRunner.failure(message, p);
		else PicoTest.currentRunner.success();
	}

	#if !picotest_nodep
	public static function assertThat<T>(actual:Dynamic, matcher:Matcher<T>, message:String = null, ?p:PosInfos):Void {
		try {
			MatcherAssert.assertThat(actual, matcher, message, p);
			PicoTest.currentRunner.success();
		} catch (e:AssertionException) {
			PicoTest.currentRunner.failure(e.message, e.info);
		} catch (e:IllegalArgumentException) {
			PicoTest.currentRunner.failure(e.message, e.info);
		} catch (e:Dynamic) {
			PicoTest.currentRunner.failure(Std.string(e), p);
		}
	}

	public static function assertWhich<T>(actual:Dynamic, matcher:Matcher<T>, message:String = null, ?p:PosInfos):Void {
		PicoAssert.assertThat(actual, matcher, message, p);
	}
	#end
}
