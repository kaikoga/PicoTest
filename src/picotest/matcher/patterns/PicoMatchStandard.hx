package picotest.matcher.patterns;

import picotest.matcher.patterns.standard.PicoMatchArray;
import picotest.matcher.patterns.standard.PicoMatchCircular;
import picotest.matcher.patterns.standard.PicoMatchStruct;

class PicoMatchStandard extends PicoMatchMany {

	public function new() {
		super();

		#if !picotest_nodep
		this.append(new PicoMatchHamcrest());
		#end

		this.append(new PicoMatchPrimitive());

		this.append(new PicoMatchCircular());
		this.append(new PicoMatchArray());
		this.append(new PicoMatchStruct());

		this.append(new PicoMatchBasic());
	}
}
