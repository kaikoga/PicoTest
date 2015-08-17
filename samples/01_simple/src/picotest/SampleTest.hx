package picotest;

/**
	Example test suite.
*/
class SampleTest {

	public function new() {
		var runner:PicoTestRunner = PicoTest.runner();
		runner.load(BasicAssertionSampleTestCase);
		runner.load(MarkingSampleTestCase);
		#if !picotest_nodep
		runner.load(HamcrestSampleTestCase);
		#end
		runner.load(AsyncSampleTestCase);
		runner.run();
	}

	public static function main():Void {
		new SampleTest();
	}
}
