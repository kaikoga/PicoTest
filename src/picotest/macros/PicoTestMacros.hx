package picotest.macros;

#if (macro || macro_doc_gen)

import picotest.out.PicoTestFileOutput;
import picotest.reporters.JUnitReporter;
import picotest.out.PicoTestOutput;
import haxe.macro.Context;
import picotest.readers.PicoTestResultReader;
import picotest.reporters.WarnReporter;
import picotest.spawners.CppSpawner;
import picotest.spawners.CsMonoSpawner;
import picotest.spawners.CsSpawner;
import picotest.spawners.FlashStandaloneSpawner;
import picotest.spawners.HlSpawner;
import picotest.spawners.JavaSpawner;
import picotest.spawners.JsBrowserSpawner;
import picotest.spawners.JsNodeSpawner;
import picotest.spawners.LimeFlashSpawner;
import picotest.spawners.LimeJsBrowserSpawner;
import picotest.spawners.LimeSpawner;
import picotest.spawners.LuaSpawner;
import picotest.spawners.NekoSpawner;
import picotest.spawners.PhpSpawner;
import picotest.spawners.PythonSpawner;
import picotest.spawners.common.TestSpawner;

/**
	Macro definitions of PicoTest. Calling through `picotest.PicoTest` is recommended.
**/
class PicoTestMacros {

	private function new() {
	}

	public static var spawner(default, set):TestSpawner;
	private static function set_spawner(value:TestSpawner):TestSpawner {
		spawner = value;
		if (spawner.forceRemote) PicoTestConfig.remote = true;
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
		if (PicoTestConfig.filter != null) {
			for (filter in PicoTestConfig.filter.split(",")) {
				PicoTestFilter.addPattern(filter);
			}
		}

		PicoTestConfig.reportJson = true;
		if (spawner == null) spawner = guessSpawner(spawnerVariant);
		if (spawner.forceRemote) PicoTestConfig.remote = true;
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
		runner.reporters = [];
		runner.reporters.push(new WarnReporter(new PicoTestOutput()));
		if (PicoTestConfig.junit != null) {
			runner.reporters.push(new JUnitReporter(new PicoTestFileOutput(PicoTestConfig.junit)));
		}
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
						if (Context.defined("php7")) {
							spawnerVariant = "php7";
						}
					case TestTarget.Cpp:
					case TestTarget.Java:
					case TestTarget.Cs:
						if (Sys.systemName() != "Windows") spawnerVariant = "mono";
					case TestTarget.Python:
					case TestTarget.Lua:
					case TestTarget.Hl:
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
			case ["php", "php7"]:
				return new PhpSpawner(true);
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
			case ["lua", _]:
				return new LuaSpawner();
			case ["hl", _]:
				return new HlSpawner();
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
