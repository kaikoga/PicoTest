package picotest.spawners.common;

#if (sys || macro || macro_doc_gen)

import picotest.spawners.http.connections.PicoHttpResponseConnection;
import picotest.spawners.http.PicoHttpRequest;
import picotest.spawners.http.connections.IPicoHttpConnection;
import sys.net.Socket;
import picotest.spawners.http.routes.PicoHttpCallbackRoute;
import picotest.spawners.http.routes.PicoHttpLocalFileRoute;
import haxe.io.Bytes;
import picotest.spawners.common.PicoTestExternalCommandHelper;
import picotest.spawners.http.PicoHttpServer;
import picotest.spawners.http.PicoHttpServerSetting;
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
			// use sh to have shell expansion and escapes
			this.process = new Process("sh", []);
			this.process.stdin.writeString('$cmd ${args.join(" ")}');
			this.process.stdin.close();
		}
	}

	private function joinProcess(writeStdout:Bool):Void {
		var stdout:Bytes;
		var stderr:Bytes;
		var err:Int;
		try {
			err = this.process.exitCode();
			stdout = process.stdout.readAll();
			stderr = process.stderr.readAll();
		} catch (d:Dynamic) {
			throw 'Command $cmd ${args.join(" ")} failed ($d)';
		}
		if (err != 0) {
			// dump output
			Sys.stdout().writeString("Process output:");
			Sys.stdout().write(stdout);
			Sys.stderr().write(stderr);
			throw 'Command $cmd ${args.join(" ")} returned $err:';
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
	public function executeRemote(picoServer:PicoHttpServer):Void {
		this.startProcess();

		var result:String = PicoTestExternalCommandHelper.joinServer(picoServer);
		PicoTestExternalCommandHelper.writeFile(Bytes.ofString(result), this.outFile);
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
