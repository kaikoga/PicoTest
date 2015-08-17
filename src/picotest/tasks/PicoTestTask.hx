package picotest.tasks;

import haxe.ds.Option;

class PicoTestTask implements IPicoTestTask {

	private var func:Void->Void;

	public var result(get, never):Option<PicoTestResult>;
	private function get_result():Option<PicoTestResult> {
		return Option.None;
	}

	public function new(func:Void->Void) {
		this.func = func;
	}

	public function start():Void {
	}

	public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		this.func();
		return PicoTestTaskStatus.Done;
	}

}
