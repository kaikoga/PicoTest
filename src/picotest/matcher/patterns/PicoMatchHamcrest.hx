package picotest.matcher.patterns;

#if !picotest_nodep

import org.hamcrest.Matcher;
import org.hamcrest.StringDescription;

class PicoMatchHamcrest implements IPicoMatcherComponent {

	public function new() return;

	public function tryMatch<T>(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult {
		if (Std.is(expected, Matcher))  {
			var matcher:Matcher<T> = expected;
			if (!matcher.matches(actual))
			{
				var e:StringDescription = new StringDescription();
				e.appendDescriptionOf(matcher);
				var a:StringDescription = new StringDescription();
				matcher.describeMismatch(actual, a);
				return PicoMatchResult.MismatchDesc(e.toString(), a.toString());
			}
			return PicoMatchResult.Match;
		}
		return PicoMatchResult.Unknown;
	}
}

#end
