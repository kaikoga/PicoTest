package picotest;

/**
	Example test suite.
*/
class SampleTest {

	public static var EXOTIC:Bool = true;
	public static var MALICIOUS:Bool = true;

	public static var FORCE_EXOTIC:Bool = false;
	public static var FORCE_MALICIOUS:Bool = false;

	public function new() {
		#if !picotest_safemode
		// these tests could only be safely handled in safe mode, will do all bad things otherwise
		// (eating all your memory in neko, for example)
		EXOTIC = FORCE_EXOTIC;
		#end

		#if cpp
		// we are sure cpp will segv and stop, preventing further compiling
		MALICIOUS = FORCE_MALICIOUS;
		#elseif php
		// and php will run out of memory, also preventing further compiling
		MALICIOUS = FORCE_MALICIOUS;
		#end

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
		if (EXOTIC) {
			runner.load(ExoticErrorSampleTestCase);
		}
		if (MALICIOUS) {
			runner.load(MaliciousErrorSampleTestCase);
		}
		runner.run();
	}

	public static function main():Void {
		new SampleTest();
	}
}
