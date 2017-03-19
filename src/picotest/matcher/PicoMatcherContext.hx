package picotest.matcher;

import picotest.matcher.patterns.PicoMatchBasic;

class PicoMatcherContext {

	public var matcher:PicoMatcher;
	public var matched:Array<Array<Dynamic>>;

	public function new(matcher:PicoMatcher) {
		this.matcher = matcher;
		this.matched = [];
	}

	public function match(expected:Dynamic, actual:Dynamic):PicoMatchResult {
		return switch (this.matcher.tryMatch(this, expected, actual)) {
			case PicoMatchResult.Unknown:
				new PicoMatchBasic().tryMatch(this, expected, actual);
			case x:
				x;
		};
	}
}
