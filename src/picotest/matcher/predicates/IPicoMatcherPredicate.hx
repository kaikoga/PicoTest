package picotest.matcher.predicates;
interface IPicoMatcherPredicate {
	function matches(context:PicoMatcherContext, actual:Dynamic):Bool;
	function toString():String;
	function describe(context:PicoMatcherContext, actual:Dynamic):String;
}
