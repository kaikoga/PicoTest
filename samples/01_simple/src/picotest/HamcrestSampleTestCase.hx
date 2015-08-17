package picotest;

import org.hamcrest.Matchers.*;

import picotest.PicoAssert.*;

/**
	Example using Hamcrest.
*/
class HamcrestSampleTestCase {

	public function testHamcrest() {
		assertThat(1, equalTo(1));
		assertThat(true, equalTo(true));
		assertThat([1, 2], equalTo([1, 2]));
		assertThat(TestEnum.Default, equalTo(TestEnum.Default));
		assertThat(TestEnum.Some(1), equalTo(TestEnum.Some(1)));
		assertWhich(2, greaterThan(1));
	}

	public function testHamcrestFail() {
		assertThat(1, equalTo(2));
		assertThat(true, equalTo(false));
		assertThat([1, 2], equalTo([3, 4]));
		assertThat(TestEnum.Default, equalTo(TestEnum.Another));
		assertThat(TestEnum.Some(1), equalTo(TestEnum.Some(2)));
		assertWhich(1, greaterThan(2));
	}

}
