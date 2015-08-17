package picotest;

import picotest.thread.PicoTestThread;
import picotest.PicoAssert.*;
import picotest.PicoTestAsync.*;

/**
	Example of async testing.
*/
class AsyncSampleTestCase {

	private var i:Int;

	public function testAssertLater() {
		this.i = 1;
		// launch cross-platform thread for testing, for now.
		if (PicoTestThread.available) {
			PicoTestThread.create(function(c):Void{ this.i++; });
		}
		assertLater(onAssertLater, 1000);
	}

	private function onAssertLater() {
		assertTrue(true);
		if (PicoTestThread.available) {
			assertEquals(2, i);
		} else {
			assertEquals(1, i);
		}
	}

	public function testAssertLaterChain() {
		this.i = 100;
		assertLater(onAssertLater1, 200);
	}

	private function onAssertLater1() {
		this.i += 10;
		assertLater(onAssertLater2, 200);
	}

	private function onAssertLater2() {
		assertEquals(110, i);
	}

	public function testCreateCallbackTimeout() {
		createCallback(callback, 10, onTimeout);
	}

	public function testCreateCallbackDefaultTimeout() {
		// will fail
		createCallback(callback, 10);
	}

	public function testCreateCallbackCalledOnce() {
		var f:Void->Void = createCallback(callback, 10);
		f();
	}

	public function testCreateCallbackCalledTwice() {
		var f:Void->Void = createCallback(callback, 10);
		f();
		f();
	}

	private function callback() {
		fail("callback()");
	}

	private function onTimeout() {
		fail("onTimeout()");
	}

}
