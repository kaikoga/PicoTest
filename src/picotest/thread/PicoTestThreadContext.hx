package picotest.thread;

class PicoTestThreadContext {

	private var state:ThreadState = ThreadState.Running;

	public function new() {

	}

	public var isHaltRequested(get, never):Bool;
	private function get_isHaltRequested():Bool {
		switch (this.state) {
			case ThreadState.Running: return false;
			case ThreadState.Zombie: return true;
			case ThreadState.Halted: return false;
		}
	}

	public var isHalted(get, never):Bool;
	private function get_isHalted():Bool {
		switch (this.state) {
			case ThreadState.Running: return false;
			case ThreadState.Zombie: return false;
			case ThreadState.Halted: return true;
		}
	}

	@:allow(picotest.thread)
	private function haltRequested():Void {
		this.state = ThreadState.Zombie;
	}

	@:allow(picotest.thread)
	private function halted():Void {
		this.state = ThreadState.Halted;
	}
}

private enum ThreadState {
	Running;
	Zombie;
	Halted;
}
