package picotest.tasks;

import haxe.Timer;

class PicoTestDelayedTestTask extends PicoTestTestTask {

	private var waitUntil:Float;

	public function new(result:PicoTestResult, func:Void->Void, delayMs:Int) {
		super(result, func);
		this.waitUntil = Timer.stamp() + delayMs / 1000;
	}

	override public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		if (Timer.stamp() < waitUntil) return PicoTestTaskStatus.Continue;
		return super.resume(runner);
	}

}
