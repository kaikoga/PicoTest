package picotest.out;

import picotest.result.PicoTestResultMark;
import picotest.out.impl.PicoTestOutputUnavailable;
import picotest.macros.PicoTestConfig;

#if macro
import picotest.out.impl.PicoTestMacroOutput;
#elseif flash
import picotest.out.impl.PicoTestFlashOutput;
#elseif js
import picotest.out.impl.PicoTestJsOutput;
import picotest.out.impl.PicoTestJsRemoteOutput;
#elseif sys
import picotest.out.impl.PicoTestSysOutput;
import picotest.out.impl.PicoTestSysRemoteOutput;
#end


class PicoTestOutput implements IPicoTestOutput {

	private var impl:IPicoTestOutput;

	public function new() this.impl = selectImpl();

	public function output(value:String):Void this.impl.output(value);
	public function progress(rate:Float, completed:Int, total:Int):Void this.impl.progress(rate, completed, total);
	public function complete(status:PicoTestResultMark):Void this.impl.complete(status);
	public function close():Void this.impl.close();

	private static function selectImpl():IPicoTestOutput {
		#if macro
		// remote not available
		return new PicoTestMacroOutput();
		#elseif flash
		if (PicoTestConfig.remote) return new PicoTestOutputUnavailable();
		return new PicoTestFlashOutput();
		#elseif js
		if (PicoTestConfig.remote) return new PicoTestJsRemoteOutput();
		return new PicoTestJsOutput();
		#elseif sys
		if (PicoTestConfig.remote) return new PicoTestSysRemoteOutput();
		return new PicoTestSysOutput();
		#else
		return null;
		#end
	}
}

