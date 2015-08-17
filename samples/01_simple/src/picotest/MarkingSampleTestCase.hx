package picotest;

/**
	Example of marking test methods.
*/
class MarkingSampleTestCase {

	public function testEmpty() {
		trace("testEmpty");
	}

	@Ignore
	public function testIgnored() {
		trace("testIgnored");
	}

	@Test
	public function meta() {
		trace("meta");
	}

	@Ignore @Test
	public function metaIgnored() {
		trace("metaIgnored");
	}

}
