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
		var err:Int = this.process.exitCode();
		var stdout:Bytes = try { process.stdout.readAll(); } catch (d:Dynamic) { err = -1; null; }
		if (err != 0) {
			throw 'Command $cmd ${args.join(" ")} returned $err: $stdout';
		}
		if (writeStdout) { 
			PicoTestExternalCommandHelper.writeFile(stdout, this.outFile);
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

		while (picoServer.postData == null) {
			try { picoServer.listen(); } catch(e:Dynamic) {} 
		}

		PicoTestExternalCommandHelper.writeFile(picoServer.postData, this.outFile);
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