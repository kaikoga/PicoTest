package picotest;

import haxe.PosInfos;

#if !picotest_nodep
import org.hamcrest.AssertionException;
import org.hamcrest.Exception;
import org.hamcrest.Matcher;
import org.hamcrest.MatcherAssert;
#end

/**
	Static class containing assertions of PicoTest.
**/
class PicoAssert {

	private static function format( d:Dynamic ) {
		return if (Std.is(d, String)) '"$d"' else '$d';
	}

	/**
		Force generate an assertion failure. 
	**/
	public static function fail(message:String = null, ?p:PosInfos):Void {
		if (message == null) message = "Assertion failed";
		PicoTest.currentRunner.failure(message, p);
	}

	/**
		Assert that given `value` is `true`.
	**/
	public static function assertTrue(value:Bool, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = "Expected true but was false";
		if (value) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure(message, p);
	}

	/**
		Assert that given `value` is `false`.
	**/
	public static function assertFalse(value:Bool, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = "Expected false but was true";
		if (value) PicoTest.currentRunner.failure(message, p);
		else PicoTest.currentRunner.success();
	}

	/**
		Assert that `expected` and `actual` equals each other in Haxe standard equality.
	**/
	public static function assertEquals<T>(expected:T, actual:T, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = 'Expected ${format(expected)} but was ${format(actual)}';
		if (expected == actual) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure(message, p);
	}

	/**
		Assert that `expected` and `actual` does not equal each other in Haxe standard equality.
	**/
	public static function assertNotEquals<T>(expected:T, actual:T, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = 'Expected not ${format(expected)} but was ${format(actual)}';
		if (expected != actual) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure(message, p);
	}

	#if !picotest_nodep
	/**
		Assert that a hamcrest Matcher successfully matches.
		PicoTest version of `assertThat()` records assertion result and continue test execution
		instead of throwing an error.
	**/
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

	/**
		An alias of `assertThat()` for convenience.
	**/
	public static function assertWhich<T>(actual:Dynamic, matcher:Matcher<T>, message:String = null, ?p:PosInfos):Void {
		PicoAssert.assertThat(actual, matcher, message, p);
	}
	#end
}
