package picotest.matcher.patterns;

import picotest.matcher.patterns.standard.PicoMatchArray;
import picotest.matcher.patterns.standard.PicoMatchBool;
import picotest.matcher.patterns.standard.PicoMatchCircular;
import picotest.matcher.patterns.standard.PicoMatchEnum;
import picotest.matcher.patterns.standard.PicoMatchFloat;
import picotest.matcher.patterns.standard.PicoMatchInt;
import picotest.matcher.patterns.standard.PicoMatchNull;
import picotest.matcher.patterns.standard.PicoMatchString;
import picotest.matcher.patterns.standard.PicoMatchStruct;

class PicoMatchStandard extends PicoMatchMany {

	public function new() {
		super();

		#if !picotest_nodep
		this.append(new PicoMatchHamcrest());
		#end

		this.append(new PicoMatchNull());
		this.append(new PicoMatchInt());
		this.append(new PicoMatchFloat());
		this.append(new PicoMatchBool());
		this.append(new PicoMatchString());
		this.append(new PicoMatchEnum());
		this.append(new PicoMatchCircular());
		this.append(new PicoMatchArray());
		this.append(new PicoMatchStruct());
		this.append(new PicoMatchBasic());
	}
}
