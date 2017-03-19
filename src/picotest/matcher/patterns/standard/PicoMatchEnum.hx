package picotest.matcher.patterns.standard;

class PicoMatchEnum implements IPicoMatcherComponent {

	public function new() return;

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Reflect.isEnumValue(expected) || Reflect.isEnumValue(actual)) {
			if (Type.enumEq(expected, actual)) {
				return PicoMatchResult.Match;
			} else {
				return PicoMatchResult.Mismatch(PicoAssert.string(expected), PicoAssert.string(actual));
			}
		}
		return PicoMatchResult.Unknown;
	}
}
