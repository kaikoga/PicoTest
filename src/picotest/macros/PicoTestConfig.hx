package picotest.macros;

import haxe.macro.Compiler;

class PicoTestConfig {

	inline public static var PICOTEST_DRYRUN:String = "picotest_dryrun";
	inline public static var PICOTEST_REPORT:String = "picotest_report";
	inline public static var PICOTEST_REPORT_JSON:String = "json";
	inline public static var PICOTEST_REPORT_DIR:String = "picotest_report_dir";
	inline public static var PICOTEST_REPORT_REMOTE:String = "picotest_remote";
	inline public static var PICOTEST_REPORT_REMOTE_PORT:String = "picotest_remote_port";
	inline public static var PICOTEST_BROWSER:String = "picotest_browser";
	inline public static var PICOTEST_SAFE_MODE:String = "picotest_safe_mode";
	inline public static var PICOTEST_SHOW_TRACE:String = "picotest_show_trace";
	inline public static var PICOTEST_SHOW_IGNORE:String = "picotest_show_ignore";
	inline public static var PICOTEST_SHOW_STACK:String = "picotest_show_stack";

	inline public static var PICOTEST_THREAD:String = "picotest_thread";

	inline public static var PICOTEST_FP:String = "picotest_fp";
	inline public static var PICOTEST_FLOG:String = "picotest_flog";

	public static var dryRun:Bool = Compiler.getDefine("picotest_dryrun") != null;
	public static var report:String = Compiler.getDefine("picotest_report");
	public static var reportDir:String = Compiler.getDefine("picotest_report_dir");
	public static var remote:Bool = Compiler.getDefine("picotest_remote") != null;
	public static var remotePort:String = Compiler.getDefine("picotest_remote_port");
	public static var browser:String = Compiler.getDefine("picotest_browser");
	public static var safeMode:Bool = Compiler.getDefine("picotest_safe_mode") != null;
	public static var showTrace:Bool = Compiler.getDefine("picotest_show_trace") != null;
	public static var showIgnore:Bool = Compiler.getDefine("picotest_show_ignore") != null;
	public static var showStack:Bool = Compiler.getDefine("picotest_show_stack") != null;

	public static var thread:Bool = Compiler.getDefine("picotest_thread") != null;

	public static var fp:String = Compiler.getDefine("picotest_fp");
	public static var flog:String = Compiler.getDefine("picotest_flog");

	public static var timerAvailable(get, never):Bool;
	private static function get_timerAvailable():Bool {
		#if (flash || js)
		return true;
		#elseif java
		return !thread;
		#else
		return false;
		#end
	}


	private function new() {

	}
}
