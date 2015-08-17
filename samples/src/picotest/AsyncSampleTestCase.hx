package picotest;

import picotest.thread.PicoTestThread;
import picotest.PicoAssert.*;
import picotest.PicoTestAsync.*;

class AsyncSampleTestCase {

	private var i:Int;

	public function testAssertLater() {
		this.i = 0;
		if (PicoTestThread.available) {
			PicoTestThread.create(function(c):Void{ this.i++; });
		}
		assertLater(onAssertLater, 1000);
	}

	private function onAssertLater() {
		assertTrue(true);
		assertTrue(false);
		assertEquals(2, i);
	}

	public function testCreateCallbackTimeout() {
		createCallback(callback, 10, onTimeout);
	}

	public function testCreateCallbackDefaultTimeout() {
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
		assertTrue(false);
	}

	private function onTimeout() {
		assertTrue(false);
	}

}
