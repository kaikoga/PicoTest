package picotest.matcher.patterns;

import picotest.matcher.patterns.standard.PicoMatchBool;
import picotest.matcher.patterns.standard.PicoMatchEnum;
import picotest.matcher.patterns.standard.PicoMatchFloat;
import picotest.matcher.patterns.standard.PicoMatchInt;
import picotest.matcher.patterns.standard.PicoMatchNull;
import picotest.matcher.patterns.standard.PicoMatchString;

class PicoMatchPrimitive extends PicoMatchMany {

	public function new() {
		super();

		this.append(new PicoMatchNull());
		this.append(new PicoMatchInt());
		this.append(new PicoMatchFloat());
		this.append(new PicoMatchBool());
		this.append(new PicoMatchString());
		this.append(new PicoMatchEnum());
	}
}
