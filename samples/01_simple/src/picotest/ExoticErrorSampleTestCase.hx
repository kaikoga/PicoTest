package picotest;

import picotest.PicoAssert.*;

/**
	Example which involves error handlings which appear without safe mode. In fact, we avoid them in safe mode.
*/
class ExoticErrorSampleTestCase {

	public function testToString():Void {
		var a:Array<Dynamic> = [[]];
		a[0][0] = a;
		assertEquals(a, a);

		var b:Dynamic = { b: { b: null } };
		b.b.b = b;
		assertEquals(b, b);

		var c:CyclicObject = new CyclicObject();
		c.c = new CyclicObject();
		c.c.c = c;
		assertEquals(c, c);
	}

}

class CyclicObject {
	public var c:CyclicObject;

	public function new() {}
	
	public function toString():String return '[${c}]';
}
