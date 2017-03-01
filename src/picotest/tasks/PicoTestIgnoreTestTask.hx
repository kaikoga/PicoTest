package picotest.tasks;

import haxe.ds.Option;
import picotest.result.PicoTestResult;

class PicoTestIgnoreTestTask implements IPicoTestTask {

	private var message:String;

	private var _status:PicoTestTaskStatus;
	public var status(get, never):PicoTestTaskStatus;
	private function get_status():PicoTestTaskStatus return this._status;

	private var _result:PicoTestResult;
	public var result(get, never):Option<PicoTestResult>;
	private function get_result():Option<PicoTestResult> {
		return Option.Some(this._result);
	}

	public function new(result:PicoTestResult, message:String) {
		this._status = PicoTestTaskStatus.Initial;
		this._result = result;
		this.message = message;
	}

	public function start():Void {
		this._result.startTask(this);
	}

	public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		this._result.setupIfNeeded();
		runner.ignore(this.message, this._result.className, this._result.methodName);
		return this._status = PicoTestTaskStatus.Complete(this._result);
	}

}
