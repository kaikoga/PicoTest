package picotest.matcher.patterns.standard;

class PicoMatchCircular implements IPicoMatcherComponent {

	public function new() return;

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		for (ea in context.matched) {
			var e:Dynamic = ea[0];
			var a:Dynamic = ea[1];
			if (expected == e && actual == a) {
				return PicoMatchResult.Match;
			} else if (expected == e || actual == a) {
				return PicoMatchResult.Mismatch(PicoAssert.string(expected), PicoAssert.string(actual));
			}
		}
		context.matched.push([expected, actual]);
		return PicoMatchResult.Unknown;

	}
}
