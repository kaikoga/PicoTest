package picotest.matcher.patterns.standard;

class PicoMatchBool extends PicoMatchBasic {

	public function new() super();

	override public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, Bool) || Std.is(actual, Bool)) {
			return super.tryMatch(context, expected, actual);
		}
		return PicoMatchResult.Unknown;
	}
}
