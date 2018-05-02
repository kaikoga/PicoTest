package picotest.matcher.predicates;

class HexPredicate implements IPicoMatcherPredicate {

	private var expected:Int;

	public function new(expected:Int) this.expected = expected;

	public function matches(context:PicoMatcherContext, actual:Dynamic):Bool return this.expected == actual;

	public function toString():String return printHex(expected);

	public function describe(context:PicoMatcherContext, actual:Dynamic) {
		if (Std.is(actual, Int)) return printHex(actual);
		return PicoAssert.string(actual, this.expected);
	}

	inline private function printHex(value:Int):String return 'was 0x${StringTools.hex(value)}';
}
