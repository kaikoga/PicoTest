package picotest.matcher.patterns.standard;

class PicoMatchString extends PicoMatchBasic {

	public function new() super();

	override public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, String) || Std.is(actual, String)) {
			return super.tryMatch(context, expected, actual);
		}
		return PicoMatchResult.Unknown;
	}
}
