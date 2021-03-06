package picotest.tasks;

import haxe.ds.Option;
import picotest.result.PicoTestResult;

class PicoTestTestTask implements IPicoTestTask {

	private var func:Void->Void;

	private var _status:PicoTestTaskStatus;
	public var status(get, never):PicoTestTaskStatus;
	private function get_status():PicoTestTaskStatus return this._status;

	private var _result:PicoTestResult;
	public var result(get, never):Option<PicoTestResult>;
	private function get_result():Option<PicoTestResult> {
		return Option.Some(this._result);
	}

	public function new(result:PicoTestResult, func:Void->Void) {
		this._status = PicoTestTaskStatus.Initial;
		this._result = result;
		this.func = func;
	}

	public function start():Void {
		this._result.startTask(this);
	}

	public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		try {
			this._result.setupIfNeeded();
			this.func();
		} catch (e:Dynamic) {
			runner.error(e);
		}
		return this._status = PicoTestTaskStatus.Complete(this._result);
	}

}
