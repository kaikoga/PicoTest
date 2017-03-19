package picotest.matcher.patterns;

class PicoMatchMany implements IPicoMatcherComponent {

	private var matchers:Array<IPicoMatcherComponent>;

	public function new() {
		this.matchers = [];
	}

	public function prepend(matcher:IPicoMatcherComponent):Void {
		this.matchers.insert(0, matcher);
	}

	public function append(matcher:IPicoMatcherComponent):Void {
		this.matchers.push(matcher);
	}

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		for (matcher in this.matchers) {
			var match:PicoMatchResult = matcher.tryMatch(context, expected, actual);
			switch (match) {
				case PicoMatchResult.Unknown:
					continue;
				case PicoMatchResult.Match, PicoMatchResult.Mismatch(_,_), PicoMatchResult.MismatchDesc(_,_), PicoMatchResult.Complex(_):
					return match;
			}
		}
		return PicoMatchResult.Unknown;
	}
}
