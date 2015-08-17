package picotest.use;

import haxe.io.Input;
import haxe.macro.Context;
import haxe.macro.Expr.ExprOf;
import haxe.macro.Compiler;
import haxe.Unserializer;
import haxe.crypto.Base64;
import haxe.Serializer;
import sys.net.Host;
import sys.net.Socket;
import sys.io.File;
import sys.io.Process;
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

	public static function command(cmd:String, args:Array<String> = null, outFile:String = null):Void {
		if (args == null) args = [];
		var process:Process = startProcess(cmd, args);
		joinProcess(process, cmd, args, outFile);
	}

	public static function remoteCommand(cmd:String, args:Array<String> = null, outFile:String = null, httpServer:HttpServer = null):Void {
		if (args == null) args = [];
		var process:Process = startProcess(cmd, args);

		var server:Socket = new Socket();
		var data:Bytes = null;
		server.bind(new Host("127.0.0.1"), httpServer.port);
		while (data == null) {
			server.listen(1);
			var socket:Socket = server.accept();
			var request:Array<String> = socket.input.readLine().split(" "); 
			switch (request[0]) {
				case "GET":
					var localFile:String = null;
					if ((httpServer.files != null) && httpServer.files.exists(request[1])) {
						localFile = httpServer.files.get(request[1]);
					} else if (httpServer.index != null) {
						localFile = httpServer.index;
					}
					var body:String = "";
					if (localFile != null) {
						var input:Input = File.read(localFile);
						body = input.readAll().toString();
						input.close();
					}
					socket.write('HTTP/1.0 200 OK

${body}');
					socket.shutdown(false, true);
				case "POST":
					var header:String = null;
					var contentLength:Int = 0;
					while (header != "") {
						header = socket.input.readLine();
						if (header.indexOf("Content-Length: ") == 0) {
							contentLength = Std.parseInt(header.split("Content-Length: ")[1]);
						}
					}
					data = socket.input.read(contentLength);
					socket.shutdown(false, true);
			} 
		}
		//server.shutdown(true, true);
		writeFile(data, outFile);

		joinProcess(process, cmd, args);
	}

}

#end

typedef HttpServer = {
	port:Int,
	files:Map<String, String>,
	index:String
} 
