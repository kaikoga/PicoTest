package picotest;

import picotest.PicoAssert.*;

/**
	Example of marking test methods.
*/
class ParametrizedSetupSampleTestCase {

	private var a:String;
	@Parameter("setupParameterProvider")
	public function setup(a:String) {
		this.a = a;
	}

	public function tearDown() {
	}

	@Parameter("parameterProvider")
	public function testParameter(x:String) {
		assertTrue(a.length > x.length);
	}

	public function setupParameterProvider():Iterable<Array<Dynamic>> {
		return [["foo"], ["bar"], ["baz"]];
	}

	public function parameterProvider():Iterable<Array<Dynamic>> {
		return [["hoge"], ["fuga"], ["piyo"]];
	}

}
