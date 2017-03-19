package picotest.matcher.patterns.standard;

class PicoMatchInt extends PicoMatchBasic {

	public function new() super();

	override public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, Int) || Std.is(actual, Int)) {
			return super.tryMatch(context, expected, actual);
		}
		return PicoMatchResult.Unknown;
	}
}
