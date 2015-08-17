package picotest.tasks;

import haxe.ds.Option;

class PicoTestIgnoreTestTask implements IPicoTestTask {

	private var message:String;

	private var _result:PicoTestResult;
	public var result(get, never):Option<PicoTestResult>;
	private function get_result():Option<PicoTestResult> {
		return Option.Some(this._result);
	}

	public function new(className:String, methodName:String, message:String) {
		this._result = new PicoTestResult(className, methodName);
		this.message = message;
	}

	public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		runner.ignore(this.message, this._result.className, this._result.methodName);
		return PicoTestTaskStatus.Complete(this._result);
	}

}
