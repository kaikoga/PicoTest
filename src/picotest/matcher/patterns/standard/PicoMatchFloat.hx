package picotest.matcher.patterns.standard;

class PicoMatchFloat extends PicoMatchBasic {

	public function new() super();

	override public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, Float) || Std.is(actual, Float)) {
			if (Math.isNaN(expected) && Math.isNaN(actual)) {
				return PicoMatchResult.Match;
			} else {
				return super.tryMatch(context, expected, actual);
			}
		}
		return PicoMatchResult.Unknown;
	}
}
