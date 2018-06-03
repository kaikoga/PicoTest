package picotest.spawners.common;

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

#if (sys || macro || macro_doc_gen)

class PicoTestExternalCommandHelper {

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
		var result:Array<String> = [];
		var dataCount:Int = 0;
		var eof:Int = -1;

		picoServer.route(new PicoHttpLocalFileRoute(picoServer.setting));
		picoServer.route(new PicoHttpCallbackRoute(function (socket:Socket, request:PicoHttpRequest):IPicoHttpConnection {
			switch (request.uri.split("/")) {
				case ["", "eof", num] if (Std.parseInt(num) != null):
					var index:Int = Std.parseInt(num);
					eof = index;
				case ["", "result", num] if (Std.parseInt(num) != null):
					var index:Int = Std.parseInt(num);
					if (result[index] == null) {
						result[index] = (request.body != null) ? request.body.toString() : "";
						dataCount++;
					}
				case _:
					return null;
			}
			return new PicoHttpResponseConnection(socket, "HTTP/1.0 200 OK\r\n\r\n", null);
		}));

		while (dataCount != eof) picoServer.listen();
		picoServer.close();
		return result.join("");
	}
}

#end
