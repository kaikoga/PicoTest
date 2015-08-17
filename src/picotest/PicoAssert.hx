package picotest;

import haxe.Json;
import picotest.PicoMatcher.MatchResult;
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

	inline private static function equals<T>(expected:T, actual:T):Bool {
		if (Reflect.isEnumValue(expected) && Reflect.isEnumValue(actual)) return Type.enumEq(expected, actual);
		return expected == actual;
	}
		
	/**
		Assert that `expected` and `actual` equals each other in Haxe standard equality.
	**/
	public static function assertEquals<T>(expected:T, actual:T, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = 'Expected ${format(expected)} but was ${format(actual)}';
		if (equals(expected, actual)) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure(message, p);
	}

	/**
		Assert that `expected` and `actual` does not equal each other in Haxe standard equality.
	**/
	public static function assertNotEquals<T>(expected:T, actual:T, message:String = null, ?p:PosInfos):Void {
		if (message == null) message = 'Expected not ${format(expected)} but was ${format(actual)}';
		if (!equals(expected, actual)) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure(message, p);
	}

	/**
		Assert that given `func` throws an error, which could be target of further assertions in `checkSuccess`.
	**/
	public static function assertThrows(func:Void->Void, ?checkSuccess:Dynamic->Void, ?p:PosInfos):Void {
		try {
			func();
			PicoTest.currentRunner.failure('Expected a throw but none happened', p);
		} catch (d:Dynamic) {
			if (checkSuccess != null) checkSuccess(d);
		}
	}

	/**
		Assert that `expected` and `actual` matches using PicoMatcher.
	**/
	public static function assertMatch(expected:Dynamic, actual:Dynamic, message:String = null, matcher:PicoMatcher = null, ?p:PosInfos):Void {
		if (matcher == null) matcher = PicoMatcher.standard();
		if (message == null) message = 'Structure mismatch:';
		var result:String = PicoMatcher.printMatchResult(matcher.match(expected, actual));
		if (result == null) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure('$message\n$result', p);
	}

	/**
	**/
	public static function assertJsonMatch<T>(expected:String, actual:String, message:String = null, matcher:PicoMatcher = null, ?p:PosInfos):Void {
		if (matcher == null) matcher = PicoMatcher.standard();
		if (message == null) message = 'JSON structure mismatch:';
		var result:String =  PicoMatcher.printMatchResult(matcher.match(Json.parse(expected), Json.parse(actual)));
		if (result == null) PicoTest.currentRunner.success();
		else PicoTest.currentRunner.failure('$message\n$result', p);
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
