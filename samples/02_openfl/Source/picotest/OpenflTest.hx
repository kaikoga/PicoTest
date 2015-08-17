package picotest;

import openfl.display.Sprite;
import openfl.events.Event;

class OpenflTest extends Sprite {

	private var runner:PicoTestRunner;

	public function new() {
		super();
		this.runTest();
	}

	public function runTest():Void {
		var runner:PicoTestRunner = PicoTest.runner();
		runner.load(OpenflTestCase);
		this.runner = runner;
		this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
	}

	private function onEnterFrame(event:Event):Void {
		this.runner.resume();
	}
}
