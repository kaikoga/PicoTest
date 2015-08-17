package picotest;

import picotest.PicoAssert.*;
import picotest.PicoTestAsync.*;

class AsyncSampleTestCase {

	public function testAssertLater() {
		assertLater(onAssertLater, 1000);
	}

	private function onAssertLater() {
		assertTrue(true);
		assertTrue(false);
	}

	public function testCreateCallbackTimeout() {
		createCallback(callback, 10, onTimeout);
	}

	public function testCreateCallbackDefaultTimeout() {
		createCallback(callback, 10);
	}

	private function callback() {
		assertTrue(false);
	}

	private function onTimeout() {
		assertTrue(false);
	}

}
