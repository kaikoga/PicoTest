package picotest;

import picotest.PicoAssert.*;

/**
	Example using PicoMatcher.
*/
class PicoMatcherSampleTestCase {

	public function testAssertMatch() {
		assertMatch(null, null);
		assertMatch(1, 1);
		assertMatch(1.0, 1.0);
		assertMatch(1.0, 1);
		assertMatch(Math.NaN, Math.NaN);
		assertMatch(true, true);
		assertMatch("a", "a");
		assertMatch(TestEnum.Default, TestEnum.Default);
		assertMatch(TestEnum.Some(1), TestEnum.Some(1));
		assertMatch([1, 2], [1, 2]);
		assertMatch([[], [1, 5, 6], [1, 2]], [[], [1, 5, 6], [1, 2]]);
		assertMatch({a:1, b:2, c:0}, {b:2, c:0, a:1});
		assertMatch({a:1, b:2, c:{a:1, b:2, c:0}}, {b:2, c:{a:1, b:2, c:0}, a:1});
		var i:Instance = new Instance();
		assertMatch(i, i);
		var c:ComplexInstance = new ComplexInstance();
		assertMatch(c, c);
		var a:Array<Dynamic> = [];
		assertMatch(a, a, "", new PicoMatcher());
	}

	public function testAssertCircularMatch() {
		var c:ComplexInstance = new ComplexInstance();
		c.c = c;
		var a:Array<Dynamic> = [c];
		assertMatch(a, a);
		a[0] = a;
		assertMatch(a, a);
		var x:Dynamic = { a: null };
		x.a = x;
		assertMatch(x, x);
	}

	public function testAssertMatchFail() {
		assertMatch(1, 2);
		assertMatch(1, null);
		assertMatch(null, 1);
		assertMatch(1.0, 2.0);
		assertMatch(1.0, 2);
		assertMatch(1.0, null);
		assertMatch(null, 2.0);
		assertMatch(1, Math.NaN);
		assertMatch(Math.NaN, 1);
		assertMatch(1.0, Math.NaN);
		assertMatch(Math.NaN, 1.0);
		assertMatch(Math.NaN, null);
		assertMatch(null, Math.NaN);
		assertMatch(true, false);
		assertMatch(true, null);
		assertMatch(null, false);
		assertMatch("a", "b");
		assertMatch("a", null);
		assertMatch(null, "b");
		assertMatch(TestEnum.Default, TestEnum.Another);
		assertMatch(TestEnum.Default, null);
		assertMatch(null, TestEnum.Another);
		assertMatch(TestEnum.Some(1), TestEnum.Some(2));
		assertMatch(TestEnum.Some(1), null);
		assertMatch(null, TestEnum.Some(2));
		assertMatch([1, 2], [3, 4]);
		assertMatch([1, 2], [3, 4, 5]);
		assertMatch([[], [1, 5, 6], [1, 2]], [[], [3, 4, 5], [1, 2, 3]]);
		assertMatch([], null);
		assertMatch(null, []);
		assertMatch([1, 2, 3, [4, 5]], null);
		assertMatch(null, [1, 2, 3, [4, 5]]);
		assertMatch({a:1, b:2, c:0}, {b:2, c:0, a:22});
		assertMatch({a:1}, cast {});
		assertMatch({a:1, b:2, c:{a:1, b:2, c:0}}, null);
		assertMatch(null, {b:2, c:{a:1, b:22, c:0}, a:22});
		assertMatch(new Instance(), new Instance());
		assertMatch(null, new Instance());
		assertMatch(new Instance(), null);
		assertMatch(new ComplexInstance(), new ComplexInstance());
		assertMatch(null, new ComplexInstance());
		assertMatch(new ComplexInstance(), null);
		assertMatch(new Instance(), new ComplexInstance());
		assertMatch([], [], "", new PicoMatcher());
	}

}

class Instance {
	public function new() {
	}
}

class ComplexInstance {
	public var a:String;
	private var i:Int;
	public var c:ComplexInstance;
	public function new() {
	}
}
