package picotest;

import org.hamcrest.Matchers.*;

import picotest.PicoAssert.*;

class HamcrestSampleTestCase {

	public function testEmpty() {
		assertThat(1, equalTo(2), null);
		assertThat(true, equalTo(false), null);
		assertThat([1, 2], equalTo([3, 4]), null);
		assertWhich(1, greaterThan(2), null);
	}

}
