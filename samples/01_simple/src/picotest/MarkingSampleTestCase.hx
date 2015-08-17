package picotest;

/**
	Example of marking test methods.
*/
class MarkingSampleTestCase {

	private var i:Int = 0;

	public function setup() {
		i = 100;
		trace('setup: i = $i');
	}

	public function tearDown() {
		trace('tearDown: i = $i');
	}

	public function testEmpty() {
		trace('testEmpty: i = $i');
	}

	@Ignore
	public function testIgnored() {
		trace('testIgnored: i = $i');
	}

	@Test
	public function meta() {
		trace('meta: i = $i');
	}

	@Ignore @Test
	public function metaIgnored() {
		trace('metaIgnored: i = $i');
	}

}
