package picotest.use.common;

import haxe.macro.Context;
import sys.io.File;
import sys.io.Process;
import picotest.use.http.PicoHttpServer;
import haxe.Unserializer;
import haxe.crypto.Base64;
import haxe.Serializer;
import haxe.io.Bytes;

#if (sys || macro || macro_doc_gen)

class CommandHelper {

	inline public static var PICOTEST_ANOTHER_NEKO_ARGS:String = "picotest_another_neko_args";

	private function new():Void {
	}

	public static function serializeBase64(value:Dynamic):String {
		return Base64.encode(Bytes.ofString(Serializer.run(value)), false);
	}

	public static function deserializeBase64(value:String):Dynamic {
		return Unserializer.run(Base64.decode(value, false).toString());
	}

	macro public static function anotherNekoArgs():Dynamic {
		return macro CommandHelper.deserializeBase64($v{Context.definedValue(CommandHelper.PICOTEST_ANOTHER_NEKO_ARGS)});
	}

	public static function systemName():String {
		return Sys.systemName();
	}

	public static function startProcess(cmd:String, args:Array<String>):Process {
		var process:Process;
		if (systemName() == "Windows") {
			// assume Windows is great
			process = new Process(cmd, args);
		} else {
			process = new Process("sh", []);
			process.stdin.writeString('$cmd ${args.join(" ")}');
			process.stdin.close();
		}
		return process;
	}

	public static function joinProcess(process:Process, cmd:String, args:Array<String>, outFile:String = null):Void {
		var err:Int = process.exitCode();
		var stdout:Bytes = try { process.stdout.readAll(); } catch (d:Dynamic) { err = -1; null; }
		if (err != 0) {
			throw 'Command $cmd ${args.join(" ")} returned $err: ${stdout}';
		}
		writeFile(stdout, outFile);
	}

	public static function writeFile(data:Bytes, fileName:String = null):Void {
		if (fileName != null) {
			var out = File.write(fileName);
			out.write(data);
			out.close();
		}
	}

	/**
		Execute a command.
	**/
	public static function command(cmd:String, args:Array<String> = null, outFile:String = null):Void {
		if (args == null) args = [];
		var process:Process = startProcess(cmd, args);
		joinProcess(process, cmd, args, outFile);
	}

	/**
		Execute a command, hosting a short living local HTTP server while execution.
	**/
	public static function remoteCommand(cmd:String, args:Array<String> = null, outFile:String = null, httpServerSetting:PicoHttpServerSetting = null):Void {
		if (args == null) args = [];
		var process:Process = startProcess(cmd, args);

		var picoServer:PicoHttpServer = new PicoHttpServer(httpServerSetting).open();

		while (picoServer.postData == null) picoServer.listen();

		writeFile(picoServer.postData, outFile);
		picoServer.close();
		joinProcess(process, cmd, args);
	}

}

#end
