package picotest.tasks;

import haxe.Timer;

class PicoTestDelayedTestTask extends PicoTestSimpleTestTask {

	private var waitUntil:Float;

	public function new(className:String, methodName:String, func:Void->Void, delayMs:Int) {
		super(className, methodName, func);
		this.waitUntil = Timer.stamp() + delayMs / 1000;
	}

	override public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		if (Timer.stamp() < waitUntil) return PicoTestTaskStatus.Continue;
		return super.resume(runner);
	}

}
