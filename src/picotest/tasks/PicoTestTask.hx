package picotest.tasks;

import haxe.ds.Option;
import picotest.result.PicoTestResult;

class PicoTestTask implements IPicoTestTask {

	private var func:Void->Void;

	private var _status:PicoTestTaskStatus;
	public var status(get, never):PicoTestTaskStatus;
	private function get_status():PicoTestTaskStatus return this._status;

	public var result(get, never):Option<PicoTestResult>;
	private function get_result():Option<PicoTestResult> {
		return Option.None;
	}

	public function new(func:Void->Void) {
		this._status = PicoTestTaskStatus.Initial;
		this.func = func;
	}

	public function start():Void {
	}

	public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		this.func();
		return this._status = PicoTestTaskStatus.Done;
	}

}
