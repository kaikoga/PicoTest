package picotest;

import picotest.PicoAssert.*;

/**
	Example which makes basic assertions.
*/
class BasicAssertionSampleTestCase {

	public function testAssertTrue() {
		assertTrue(true);
	}

	public function testAssertTrueFail() {
		assertTrue(false);
	}

	public function testAssertFalse() {
		assertFalse(true);
	}

	public function testAssertFalseFail() {
		assertFalse(false);
	}

	public function testAssertEquals() {
		var a = [];
		var d = {};
		assertEquals(1, 1);
		assertEquals("foo", "foo");
		assertEquals(a, a);
		assertEquals(d, d);
		assertEquals(TestEnum.Default, TestEnum.Default);
		assertEquals(TestEnum.Some(1), TestEnum.Some(1));
	}

	public function testAssertEqualsFail() {
		assertEquals(1, 2);
		assertEquals("foo", "bar");
		assertEquals([], []);
		assertEquals({}, {});
		assertEquals(TestEnum.Default, TestEnum.Another);
		assertEquals(TestEnum.Some(1), TestEnum.Some(2));
	}

	public function testAssertNotEquals() {
		assertNotEquals(1, 2);
		assertNotEquals("foo", "bar");
		assertNotEquals([], []);
		assertNotEquals({}, {});
		assertNotEquals(TestEnum.Default, TestEnum.Another);
		assertNotEquals(TestEnum.Some(1), TestEnum.Some(2));
	}

	public function testAssertNotEqualsFail() {
		var a = [];
		var d = {};
		assertNotEquals(1, 1);
		assertNotEquals("foo", "foo");
		assertNotEquals(a, a);
		assertNotEquals(d, d);
		assertNotEquals(TestEnum.Default, TestEnum.Default);
		assertNotEquals(TestEnum.Some(1), TestEnum.Some(1));
	}

	public function testAssertNull() {
		assertNull(null);
		assertNull([][0]);
	}

	public function testAssertNullFail() {
		assertNull("");
		assertNull([""][0]);
	}

	public function testAssertNotNull() {
		assertNotNull("");
		assertNotNull([""][0]);
	}

	public function testAssertNotNullFail() {
		assertNotNull(null);
		assertNotNull([][0]);
	}

}
