package picotest;

import picotest.PicoAssert.*;

/**
	Example using PicoMatcher.
*/
class PicoMatcherSampleTestCase {

	public function testAssertMatch() {
		assertMatch(1, 1);
		assertMatch(true, true);
		assertMatch(TestEnum.Default, TestEnum.Default);
		assertMatch(TestEnum.Some(1), TestEnum.Some(1));
		assertMatch([1, 2], [1, 2]);
		assertMatch([[], [1, 5, 6], [1, 2]], [[], [1, 5, 6], [1, 2]]);
		assertMatch({a:1, b:2, c:0}, {b:2, c:0, a:1});
		assertMatch({a:1, b:2, c:{a:1, b:2, c:0}}, {b:2, c:{a:1, b:2, c:0}, a:1});
		var a:Array<Dynamic> = [];
		assertMatch(a, a, "", new PicoMatcher());
	}

	public function testAssertMatchFail() {
		assertMatch(1, 2);
		assertMatch(true, false);
		assertMatch(TestEnum.Default, TestEnum.Another);
		assertMatch(TestEnum.Some(1), TestEnum.Some(2));
		assertMatch([1, 2], [3, 4]);
		assertMatch([1, 2], [3, 4, 5]);
		assertMatch([[], [1, 5, 6], [1, 2]], [[], [3, 4, 5], [1, 2, 3]]);
		assertMatch({a:1, b:2, c:0}, {b:2, c:0, a:22});
		assertMatch({a:1}, cast {});
		assertMatch({a:1, b:2, c:{a:1, b:2, c:0}}, {b:2, c:{a:1, b:22, c:0}, a:22});
		assertMatch([], [], "", new PicoMatcher());
	}

}
