package picotest.matcher;
interface IPicoMatcherComponent {
	function tryMatch(context:PicoMatcherContext, expected:Dynamic, actual:Dynamic):PicoMatchResult;
}
