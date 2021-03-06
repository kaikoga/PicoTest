package picotest.spawners.common;

#if (sys || macro || macro_doc_gen)

import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.Serializer;
import haxe.Unserializer;
import picotest.spawners.http.connections.IPicoHttpConnection;
import picotest.spawners.http.connections.PicoHttpResponseConnection;
import picotest.spawners.http.PicoHttpRequest;
import picotest.spawners.http.PicoHttpServer;
import picotest.spawners.http.PicoHttpServerSetting;
import picotest.spawners.http.routes.PicoHttpCallbackRoute;
import picotest.spawners.http.routes.PicoHttpLocalFileRoute;
import sys.FileSystem;
import sys.io.File;
import sys.net.Socket;

class PicoTestExternalCommandHelper {

	inline public static var PICOTEST_ANOTHER_NEKO_ARGS:String = "picotest_another_neko_args";

	private function new():Void {
	}

	public static function globOne(pattern:String, hint:String = null):String {
		var g:Array<String> = glob(pattern);
		if (g.length == 0) {
			throw 'Executable not found, pattern: ${pattern}';
		}
		if (hint != null) {
			for (s in g) if (s.indexOf(hint) >= 0) return s;
		}
		return g[0];
	}

	public static function glob(pattern:String):Array<String> {
		return globRec(".", pattern.split("/").map(function(s:String) return new EReg(StringTools.replace(s, "*", ".*"), "")));
	}

	private static function globRec(path:String, pattern:Array<EReg>, index:Int = 0):Array<String> {
		var result:Array<String> = [];
		var ereg:EReg = pattern[index];
		for (entry in FileSystem.readDirectory(path)) {
			switch (entry) {
				case ".", "..": continue;
				case _:
			}
			if (ereg.match(entry)) {
				var entryPath:String = path + "/" + entry;
				var j:Int = index + 1;
				if (j == pattern.length) {
					result.push(entryPath);
				} else {
					for (child in globRec(entryPath, pattern, j)) result.push(child);
				}
			}
		}
		return result;
	}

	public static function serializeBase64(value:Dynamic):String {
		return Base64.encode(Bytes.ofString(Serializer.run(value)), false);
	}

	public static function deserializeBase64(value:String):Dynamic {
		return Unserializer.run(Base64.decode(value, false).toString());
	}

	macro public static function anotherNekoArgs():Dynamic {
		var anotherNekoArgs:String = Context.definedValue(PicoTestExternalCommandHelper.PICOTEST_ANOTHER_NEKO_ARGS);
		return macro PicoTestExternalCommandHelper.deserializeBase64($v{anotherNekoArgs});
	}

	public static function writeFile(data:Bytes, fileName:String = null):Void {
		if (fileName != null) {
			FileSystem.createDirectory(new Path(fileName).dir);
			var out = File.write(fileName);
			out.write(data);
			out.close();
		}
	}

	public static function startServer(httpServerSetting:PicoHttpServerSetting = null):PicoHttpServer {
		var picoServer:PicoHttpServer = new PicoHttpServer(httpServerSetting);
		picoServer.open();
		return picoServer;
	}

	public static function joinServer(picoServer:PicoHttpServer):String {
		// var progress:Array<String> = [];
		var result:String = null;

		picoServer.route(new PicoHttpLocalFileRoute(picoServer.setting));
		picoServer.route(new PicoHttpCallbackRoute(function (socket:Socket, request:PicoHttpRequest):IPicoHttpConnection {
			switch (request.uri.split("/")) {
				case ["", "progress", num] if (Std.parseInt(num) != null):
					var index:Int = Std.parseInt(num);
					// progress[index] = request.body.toString();
				case ["", "result"]:
					result = if (request.body == null) "" else request.body.toString();
				case _:
					return null;
			}
			return new PicoHttpResponseConnection(socket, "HTTP/1.0 200 OK\r\n\r\n", null);
		}));

		while (result == null) picoServer.listen();
		picoServer.close();
		return result;
	}
}

#end
