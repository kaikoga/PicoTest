package picotest.matcher.patterns;

class PicoMatchCustom implements IPicoMatcherComponent {

	public function new(tryMatch:PicoMatcherContext->Dynamic->Dynamic->PicoMatchResult) {
		this.doTryMatch = tryMatch;
	}

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		return this.doTryMatch(context, expected, actual);
	}

	public dynamic function doTryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		throw "PicoMatchCustom.match()";
	}
}
