package picotest.macros;

#if (macro || macro_doc_gen)

import haxe.macro.Compiler;
import haxe.macro.Context;
import picotest.readers.PicoTestResultReader;
import picotest.reporters.WarnReporter;
import picotest.spawners.CppSpawner;
import picotest.spawners.CsMonoSpawner;
import picotest.spawners.CsSpawner;
import picotest.spawners.FlashStandaloneSpawner;
import picotest.spawners.JavaSpawner;
import picotest.spawners.JsBrowserSpawner;
import picotest.spawners.JsNodeSpawner;
import picotest.spawners.LimeFlashSpawner;
import picotest.spawners.LimeJsBrowserSpawner;
import picotest.spawners.LimeSpawner;
import picotest.spawners.NekoSpawner;
import picotest.spawners.PhpSpawner;
import picotest.spawners.PythonSpawner;
import picotest.spawners.common.TestSpawner;

/**
	Macro definitions of PicoTest. Calling through `picotest.PicoTest` is recommended.
**/
class PicoTestMacros {

	inline public static var PICOTEST_DRYRUN:String = "picotest_dryrun";
	inline public static var PICOTEST_REPORT:String = "picotest_report";
	inline public static var PICOTEST_REPORT_JSON:String = "json";
	inline public static var PICOTEST_REPORT_REMOTE:String = "picotest_remote";
	inline public static var PICOTEST_REPORT_REMOTE_PORT:String = "picotest_remote_port";
	inline public static var PICOTEST_REPORT_DIR:String = "picotest_report_dir";
	inline public static var PICOTEST_BROWSER:String = "picotest_browser";
	inline public static var PICOTEST_FP:String = "picotest_fp";
	inline public static var PICOTEST_FLOG:String = "picotest_flog";

	private function new() {
	}

	public static var spawner(default, set):TestSpawner;
	private static function set_spawner(value:TestSpawner):TestSpawner {
		spawner = value;
		if (spawner.forceRemote) {
			Compiler.define(PicoTestMacros.PICOTEST_REPORT_REMOTE, "1");
		}
		return value;
	}

	private static var _testTarget:TestTarget = null;
	private static var testTarget(get, never):TestTarget;
	private static function get_testTarget():TestTarget {
		if (_testTarget == null) {
			_testTarget = TestTarget.Neko;
			for (target in TestTarget.allTargets) {
				if (Context.defined(target.toString())) _testTarget = target;
			}
		}
		return _testTarget;
	}

	public static function setup(spawnerVariant:String = null):Void {
		Compiler.define(PICOTEST_REPORT, PICOTEST_REPORT_JSON);
		if (spawner == null) spawner = guessSpawner(spawnerVariant);
		if (spawner.forceRemote) Compiler.define(PICOTEST_REPORT_REMOTE, "1");
	}

	public static function warn(spawnerVariant:String = null):Void {
		setup(spawnerVariant);
		Context.onAfterGenerate(runTests);
	}

	public static function runTests():Void {
		println('----------------------------------------');
		println("PicoTest: spawning test runner...");
		println('----------------------------------------');
		spawner.execute();
		readResult(spawner.reportData(), spawner.name);
	}

	public static function readResult(report:String, header:String):Void {
		var runner:PicoTestRunner = PicoTest.runner();
		runner.reporters = [new WarnReporter()];
		new PicoTestResultReader().read(runner, report, header);
		runner.run();
	}

	private static function guessSpawner(spawnerVariant:String = null):TestSpawner {
		if (spawnerVariant == null) {
			if (Context.defined("lime")) {
				spawnerVariant = "lime";
			} else {
				switch (testTarget) {
					case TestTarget.Flash:
						spawnerVariant = "sa";
					case TestTarget.Neko:
					case TestTarget.Js:
						spawnerVariant = "node";
					case TestTarget.Php:
					case TestTarget.Cpp:
					case TestTarget.Java:
					case TestTarget.Cs:
						if (Sys.systemName() != "Windows") spawnerVariant = "mono";
					case TestTarget.Python:
					default:
						throw 'target ${testTarget.toString()} not supported';
				}
			}
		}

		switch [testTarget.toString(), spawnerVariant] {
			case ["flash", "lime"]:
				return new LimeFlashSpawner();
			case ["js", "lime"]:
				return new LimeJsBrowserSpawner('html5');
			case ["neko", "lime"]:
				return new LimeSpawner('neko');
			case ["cpp", "lime"]:
				return new LimeSpawner(Sys.systemName().toLowerCase());
			case ["flash", _]:
				return new FlashStandaloneSpawner();
			case ["neko", _]:
				return new NekoSpawner();
			case ["js", "browser"]:
				return new JsBrowserSpawner();
			case ["js", "node"]:
				return new JsNodeSpawner();
			case ["php", _]:
				return new PhpSpawner();
			case ["cpp", _]:
				return new CppSpawner();
			case ["java", _]:
				return new JavaSpawner();
			case ["cs", "mono"]:
				return new CsMonoSpawner();
			case ["cs", _]:
				return new CsSpawner();
			case ["python", _]:
				return new PythonSpawner();
			default:
				throw 'spawner ${spawnerVariant} not found for target ${testTarget.toString()}';
		}
	}

	private static var _lineNum:Int = 1;
	public static function println(line:String):Void {
		Context.warning(line, Context.makePosition({ file : "_", min : _lineNum, max : _lineNum }));
		_lineNum++;
	}
}
#end
