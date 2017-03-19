package picotest.matcher.patterns;

class PicoMatchBasic implements IPicoMatcherComponent {

	public function new() return;

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		return if (expected == actual) {
			PicoMatchResult.Match;
		} else {
			PicoMatchResult.Mismatch(PicoAssert.string(expected), PicoAssert.string(actual));
		}
	}
}
