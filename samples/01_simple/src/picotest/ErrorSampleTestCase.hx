package picotest;

#if flash
import flash.errors.Error;
#end

import picotest.PicoAssert.*;

/**
	Example which involves error handlings.
*/
class ErrorSampleTestCase {

	public function testThrow() {
		assertThrows(
			function() {
				throw "some error";
			},
			function(error:Dynamic) {
				assertEquals('some error', error);
			}
		);
	}

	public function testThrowFail() {
		assertThrows(
			function() {
				throw "random error";
			},
			function(error:Dynamic) {
				assertEquals('some error', error);
			}
		);
	}

	public function testThrowError() {
		throw "some error";
	}

	public function testEmpty() {
	}

	@Parameter("bogus")
	public function testInvalid() {
		assertEquals(1, 2);
	}

	#if flash
	public function testThrowErrorError() {
		throw new Error();
	}
	#end

	public function testThrowErrorInternal() {
		throwErrorInternal();
	}

	public function throwErrorInternal() {
		throw "some internal error";
	}

}
