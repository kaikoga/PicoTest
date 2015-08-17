package picotest.tasks;

import haxe.ds.Option;

class PicoTestSimpleTestTask implements IPicoTestTask {

	private var func:Void->Void;

	private var _result:PicoTestResult;
	public var result(get, never):Option<PicoTestResult>;
	private function get_result():Option<PicoTestResult> {
		return Option.Some(this._result);
	}

	public function new(className:String, methodName:String, func:Void->Void) {
		this._result = new PicoTestResult(className, methodName);
		this.func = func;
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
