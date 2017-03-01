package picotest.tasks;

import haxe.PosInfos;
import picotest.result.PicoTestResult;

@:access(picotest.PicoTestRunner.runTask)
class PicoTestTriggeredTestTask extends PicoTestTestTask {

	private var timeoutFunc:Void->Void;
	private var state:PicoTestTriggeredTestTaskState = null;

	public function new(result:PicoTestResult, func:Void->Void, timeoutFunc:Void->Void, ?p:PosInfos) {
		super(result, func);
		this._status = PicoTestTaskStatus.Continue;
		this.timeoutFunc = timeoutFunc;
		this.state = PicoTestTriggeredTestTaskState.Initial(p);
	}

	override public function resume(runner:PicoTestRunner):PicoTestTaskStatus {
		switch (this.state) {
			case PicoTestTriggeredTestTaskState.Initial(p):
				runner.failure("PicoTestTriggeredTestTask is not ready", p);
			case PicoTestTriggeredTestTaskState.Called:
				// func will be called
			case PicoTestTriggeredTestTaskState.Twice(p):
				runner.failure("Callback called twice", p);
			case PicoTestTriggeredTestTaskState.Timeout:
				// timeoutFunc will be called
				this.func = this.timeoutFunc;
			case PicoTestTriggeredTestTaskState.TooLate(p):
				runner.failure("Callback called after timeout", p);
				this.func = this.timeoutFunc;
		}
		return super.resume(runner);
	}

	public function createCallback(runner:PicoTestRunner, ?p:PosInfos):Void->Void {
		return function():Void {
			switch (this.state) {
				case PicoTestTriggeredTestTaskState.Initial(_):
					this.state = PicoTestTriggeredTestTaskState.Called;
					runner.prepend(this);
				case PicoTestTriggeredTestTaskState.Called:
					this.state = PicoTestTriggeredTestTaskState.Twice(p);
				case PicoTestTriggeredTestTaskState.Twice(_):
				case PicoTestTriggeredTestTaskState.Timeout:
					this.state = PicoTestTriggeredTestTaskState.TooLate(p);
				case PicoTestTriggeredTestTaskState.TooLate(_):
			}
		}
	}

	public function createTimeoutCallback(runner:PicoTestRunner, ?p:PosInfos):Void->Void {
		if (timeoutFunc == null) {
			this.timeoutFunc = function():Void { PicoAssert.fail("Callback reached timeout", p); };
		}

		return function():Void {
			switch (this.state) {
				case PicoTestTriggeredTestTaskState.Initial(_):
					this.state = PicoTestTriggeredTestTaskState.Timeout;
					runner.prepend(this);
				case PicoTestTriggeredTestTaskState.Called:
				case PicoTestTriggeredTestTaskState.Twice(_):
				case PicoTestTriggeredTestTaskState.Timeout:
				case PicoTestTriggeredTestTaskState.TooLate(_):
			}
		}
	}
}

private enum PicoTestTriggeredTestTaskState {
	Initial(posInfos:PosInfos);
	Called;
	Twice(posInfos:PosInfos);
	Timeout;
	TooLate(posInfos:PosInfos);
}
