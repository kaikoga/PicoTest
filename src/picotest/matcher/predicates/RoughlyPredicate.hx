package picotest.matcher.predicates;

class RoughlyPredicate implements IPicoMatcherPredicate {

	private var expected:Float;
	private var epsilon:Float;

	public function new(expected:Float, epsilon:Float) {
		this.expected = expected;
		this.epsilon = epsilon;
	}

	public function matches(context:PicoMatcherContext, actual:Dynamic):Bool return Math.abs(actual - this.expected) <= this.epsilon;

	public function toString():String return '$expected±$epsilon';

	public function describe(context:PicoMatcherContext, actual:Dynamic) return 'was ${PicoAssert.string(actual, this.expected)}';
}
