package picotest;

#if flash
import flash.errors.Error;
#end

import picotest.PicoAssert.*;

class SampleTestCase {

	@Test
	public function meta() {
		trace("fuga");
		assertTrue(false);
	}

	public function testEmpty() {
		trace("hoge");
	}

	public function testAssertTrue() {
		assertTrue(true);
		assertTrue(true);
		assertTrue(false);
		assertTrue(false);
		assertTrue(false);
	}

	public function testAssertFalse() {
		assertFalse(true);
		assertFalse(true);
		assertFalse(false);
		assertFalse(false);
		assertFalse(false);
	}

	public function testFails() {
		fail();
		fail("message");
	}

	public function testThrow() {
		throw "some error";
	}

	#if flash
	public function testError() {
		throw new Error();
	}
	#end
}
