package picotest.tasks;

import haxe.ds.Option;

class PicoTestTestTask implements IPicoTestTask {

	private var func:Void->Void;

	private var _result:PicoTestResult;
	public var result(get, never):Option<PicoTestResult>;
	private function get_result():Option<PicoTestResult> {
		return Option.Some(this._result);
	}

	public function new(result:PicoTestResult, func:Void->Void) {
		this._result = result;
		this.func = func;
	}

	public function start():Void {
		this._result.tasks.push(this);
	}

	public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		try {
			this.func();
		} catch (e:Dynamic) {
			runner.error(e);
		}
		return PicoTestTaskStatus.Complete(this._result);
	}

}
