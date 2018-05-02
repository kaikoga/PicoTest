package picotest;

import picotest.matcher.predicates.HexPredicate;
import picotest.matcher.predicates.RoughlyPredicate;
import picotest.PicoAssert.*;

using picotest.PicoPredicates;

/**
	Example using PicoTest predicates.
*/
class PicoMatcherPredicateSampleTestCase {

	public function testHex() {
		assertMatch(new HexPredicate(1234), 1234);
		assertMatch({a: new HexPredicate(1234)}, {a: 1234});
		assertMatch(PicoPredicates.hex(1234), 1234);
	}

	public function testHexFail() {
		assertMatch(new HexPredicate(0x1234), 1234);
		assertMatch({a: new HexPredicate(0x1234)}, {a: 1234});
	}

	public function testRoughly() {
		assertMatch(new RoughlyPredicate(1.0, 0.1), 1.01);
	}

	public function testRoughlyFail() {
		assertMatch(new RoughlyPredicate(1.0, 0.01), 1.1);
	}

	public function testActualValueIsPredicate() {
		assertMatch(1234, new HexPredicate(0x1234));
	}
}
