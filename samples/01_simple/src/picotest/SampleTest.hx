package picotest;

/**
	Example test suite.
*/
class SampleTest {

	public function new() {
		var runner:PicoTestRunner = PicoTest.runner();
		runner.load(BasicAssertionSampleTestCase);
		runner.load(ErrorSampleTestCase);
		runner.load(MarkingSampleTestCase);
		runner.load(ParametrizedSampleTestCase, [[1, 1], [2, 2]]);
		runner.load(ParametrizedSetupSampleTestCase);
		runner.load(PicoMatcherSampleTestCase);
		#if !picotest_nodep
		runner.load(HamcrestSampleTestCase);
		runner.load(PicoMatcherHamcrestSampleTestCase);
		#end
		runner.load(AsyncSampleTestCase);
		runner.run();
	}

	public static function main():Void {
		new SampleTest();
	}
}
