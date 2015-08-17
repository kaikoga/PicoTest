package picotest.tasks;

import haxe.Timer;
import haxe.ds.Option;

class PicoTestDelayedTask extends PicoTestTask {

	private var waitUntil:Float;

	public function new(func:Void->Void, delayMs:Int) {
		super(func);
		this.waitUntil = Timer.stamp() + delayMs / 1000;
	}

	override public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		if (Timer.stamp() < waitUntil) return PicoTestTaskStatus.Continue;
		return super.resume(runner);
	}
}
