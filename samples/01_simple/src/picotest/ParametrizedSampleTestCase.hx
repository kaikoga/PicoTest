package picotest;

import picotest.PicoAssert.*;

/**
	Example of marking test methods.
*/
class ParametrizedSampleTestCase {


	public function setup() {
	}

	public function tearDown() {
	}

	@Parameter("parameterProvider")
	public function testParameter(a:Int, b:Int) {
		assertEquals(a, b);
	}

	@Parameter("parameterProviderFail")
	public function testParameterFail(a:Int, b:Int) {
		assertEquals(a, b);
	}

	@Parameter
	public function testDefaultParameter(a:Int, b:Int) {
		assertEquals(a, b);
	}

	public function parameterProvider() {
		return [[1, 1], [2, 2]];
	}

	public function parameterProviderFail() {
		return [[1, 2], [2, 1]];
	}

}
