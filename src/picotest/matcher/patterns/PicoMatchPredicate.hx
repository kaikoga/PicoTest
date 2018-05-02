package picotest.matcher.patterns;

import picotest.matcher.predicates.IPicoMatcherPredicate;

class PicoMatchPredicate implements IPicoMatcherComponent {

	public function new() return;

	public function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, IPicoMatcherPredicate))  {
			var predicate:IPicoMatcherPredicate = expected;
			if (!predicate.matches(context, actual)) {
				return PicoMatchResult.MismatchDesc(predicate.toString(), predicate.describe(context, actual));
			}
			return PicoMatchResult.Match;
		} else if (Std.is(actual, IPicoMatcherPredicate)) {
			var predicate:IPicoMatcherPredicate = actual;
			return PicoMatchResult.MismatchDesc(predicate.describe(context, expected), '${predicate.toString()} (predicates should go to first argument)');
		}
		return PicoMatchResult.Unknown;
	}
}
