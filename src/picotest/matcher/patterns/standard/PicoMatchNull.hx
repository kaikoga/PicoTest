package picotest.matcher.patterns.standard;

class PicoMatchNull extends PicoMatchBasic {

	public function new() super();

	override public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (expected == null || actual == null) {
			return super.tryMatch(context, expected, actual);
		}
		return PicoMatchResult.Unknown;
	}
}
