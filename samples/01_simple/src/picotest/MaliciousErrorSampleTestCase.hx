package picotest;

import picotest.PicoAssert.*;

/**
	Example which involves error handlings of really strange test cases.
*/
class MaliciousErrorSampleTestCase {

	public function testStackOverflow():Void {
		testStackOverflow();
	}

	// just to make sure, we can't detect:
	// - infinite loops
	// - out of memory errors
	// - memory leaks
	// - bugs in specifications
	// - failure of your business model
}
