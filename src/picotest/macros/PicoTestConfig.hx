package picotest.macros;

import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr;

class PicoTestConfig {

	#if !macro
	private static var defines:Map<String, String> = createDefines();
	private static function createDefines():Map<String, String> {
		getDefines();
	}
	#end

	macro private static function getDefines() {
		var initMap:Array<Expr> = [];
		var defines:Map<String, String> = Context.getDefines();
		for (key in defines.keys()) {
			initMap.push(macro { map.set($v{key}, $v{defines.get(key)}); });
		}
		return macro {
			var map:Map<String, String> = new haxe.ds.StringMap();
			$b{initMap};
			return map;
		}
	}

	inline private static function getDefine(name:String):String {
		#if macro
		return Context.definedValue(name);
		#else
		return defines.get(name);
		#end
	}
	inline private static function getFlag(name:String):Bool {
		return getDefine(name) != null;
	}

	inline private static function setDefine(name:String, value:String):String {
		#if macro
		Compiler.define(name, value);
		return value;
		#else
		throw "PicoTestConfig.setDefine()";
		#end
	}
	inline private static function setFlag(name:String, value:Bool):Bool {
		setDefine(name, value ? "1" : null);
		return value;
	}

	public static var dryRun(get, never):Bool;
	private static function get_dryRun():Bool return getFlag("picotest_dryrun");

	public static var reportJson(get, set):Bool;
	private static function get_reportJson():Bool return getFlag("picotest_report_json");
	private static function set_reportJson(value:Bool):Bool return setFlag("picotest_report_json", value);

	public static var reportDir(get, never):String;
	private static function get_reportDir():String return getDefine("picotest_report_dir");

	public static var remote(get, set):Bool;
	private static function get_remote():Bool return getFlag("picotest_remote");
	private static function set_remote(value:Bool):Bool return setFlag("picotest_remote", value);

	public static var remotePort(get, never):String;
	private static function get_remotePort():String return getDefine("picotest_remote_port");

	public static var browser(get, never):String;
	private static function get_browser():String return getDefine("picotest_browser");

	public static var safeMode(get, never):Bool;
	private static function get_safeMode():Bool return getFlag("picotest_safe_mode");

	public static var showTrace(get, never):Bool;
	private static function get_showTrace():Bool return getFlag("picotest_show_trace");

	public static var showIgnore(get, never):Bool;
	private static function get_showIgnore():Bool return getFlag("picotest_show_ignore");

	public static var showStack(get, never):Bool;
	private static function get_showStack():Bool return getFlag("picotest_show_stack");

	public static var thread(get, never):Bool;
	private static function get_thread():Bool return getFlag("picotest_thread");

	public static var fp(get, never):String;
	private static function get_fp():String return getDefine("picotest_fp");

	public static var flog(get, never):String;
	private static function get_flog():String return getDefine("picotest_flog");

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
