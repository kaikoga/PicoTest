package picotest.use.common;

#if (sys || macro || macro_doc_gen)

import picotest.use.common.PicoTestExternalCommandHelper;
import haxe.io.Bytes;
import picotest.use.http.PicoHttpServer;
import sys.io.Process;

//TODO
//@noCompletion
class PicoTestExternalCommand {

	private var cmd:String;
	private var args:Array<String>;
	private var outFile:String;

	private var process:Process;

	public function new(cmd:String, args:Array<String> = null, outFile:String = null):Void {
		this.cmd = cmd;
		this.args = (args != null) ? args : [];
		this.outFile = outFile;
	}

	private function startProcess():Void {
		if (systemName() == "Windows") {
			// assume Windows is great
			this.process = new Process(cmd, args);
		} else {
			this.process = new Process("sh", []);
			this.process.stdin.writeString('$cmd ${args.join(" ")}');
			this.process.stdin.close();
		}
	}

	private function joinProcess(writeStdout:Bool):Void {
		try {
			var stdout:Bytes = process.stdout.readAll();
			var err:Int = this.process.exitCode();
			if (err != 0) {
				throw 'Command $cmd ${args.join(" ")} returned $err: $stdout';
			}
			if (writeStdout) {
				PicoTestExternalCommandHelper.writeFile(stdout, this.outFile);
			}
		} catch (d:Dynamic) {
			throw 'Command $cmd ${args.join(" ")} failed';
		}
	}

	/**
		Execute a command.
	**/
	public function execute():Void {
		this.startProcess();
		this.joinProcess(true);
	}

	/**
		Execute a command, hosting a short living local HTTP server while execution.
	**/
	public function executeRemote(httpServerSetting:PicoHttpServerSetting = null):Void {
		this.startProcess();

		var picoServer:PicoHttpServer = new PicoHttpServer(httpServerSetting).open();

		var result:Array<String> = [];
		var dataCount:Int = 0;
		var eof:Int = -1;
		while (dataCount != eof) {
			try {
				picoServer.listen();
				switch (picoServer.postUri.split("/")) {
					case ["", "eof", num] if (Std.parseInt(num) != null):
						var index:Int = Std.parseInt(num);
						eof = index;
						dataCount++;
					case ["", "result", num] if (Std.parseInt(num) != null):
						var index:Int = Std.parseInt(num);
						result[index] = picoServer.postData.toString();
						dataCount++;
					case _:
						break;
				}
			} catch(e:Dynamic) {}
		}

		PicoTestExternalCommandHelper.writeFile(Bytes.ofString(result.join("")), this.outFile);
		picoServer.close();

		this.joinProcess(false);
	}

	/**
		Execute a command, as opening a URI through GUI (needs special treatment in Mac)
	**/
	public static function open(cmd:String, uri:String, blocking:Bool = false, outFile:String = null):PicoTestExternalCommand {
		if (systemName() == "Mac") {
			return new PicoTestExternalCommand('open', [blocking ? '-nWa' : '-a', cmd, uri], outFile);
		} else {
			return new PicoTestExternalCommand(cmd, [uri], outFile);
		}
	}

	public static function systemName():String {
		return Sys.systemName();
	}

}

#end
