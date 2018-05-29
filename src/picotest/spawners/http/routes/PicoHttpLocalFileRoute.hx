package picotest.spawners.http.routes;

#if sys

import haxe.io.Bytes;
import haxe.io.Input;
import picotest.spawners.http.connections.IPicoHttpConnection;
import picotest.spawners.http.connections.PicoHttpResponseConnection;
import sys.FileSystem;
import sys.io.File;
import sys.net.Socket;

class PicoHttpLocalFileRoute implements IPicoHttpRoute {

	private var setting:PicoHttpServerSetting;

	public function new(setting:PicoHttpServerSetting):Void {
		this.setting = setting;
	}

	public function upgrade(socket:Socket, request:PicoHttpRequest):IPicoHttpConnection {
		switch (request.method) {
			case PicoHttpMethod.GET:
				var responseBody:Bytes = null;
				var localFile:String = null;
				if (localFile == null) {
					if ((setting.files != null) && setting.files.exists(request.uri)) {
						localFile = setting.files.get(request.uri);
					}
				}
				if (localFile == null) {
					if (setting.docRoot != null) {
						var path:String = setting.docRoot + request.uri;
						if (path.indexOf("..") < 0 && FileSystem.exists(path)) {
							localFile = path;
						}
					}
				}
				if (localFile != null) {
					var input:Input = File.read(localFile);
					responseBody = input.readAll();
					input.close();
				}
				return new PicoHttpResponseConnection(socket, "HTTP/1.0 200 OK\r\n\r\n", responseBody);
			case _:
				return null;
		}
	}
}

#end
