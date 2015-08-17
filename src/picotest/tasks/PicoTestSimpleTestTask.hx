package picotest.tasks;

class PicoTestSimpleTestTask extends PicoTestTestTask {

	public function new(className:String, methodName:String, func:Void->Void) {
		super(new PicoTestResult(className, methodName), func);
	}

}
