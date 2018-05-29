package picotest.spawners.http;

#if sys

import haxe.io.Bytes;
import haxe.io.Input;
import sys.FileSystem;
import sys.io.File;
import sys.net.Host;
import sys.net.Socket;

class PicoHttpServer {

	public var available(default, null):Bool;

	public var postUri:String;
	public var postData:Bytes;

	private var server:Socket;
	private var setting:PicoHttpServerSetting;

	public function new(setting:PicoHttpServerSetting) {
		this.setting = setting;
	}

	public function open():PicoHttpServer {
		this.server = new Socket();
		this.server.bind(new Host("localhost"), this.setting.port);
		this.available = true;
		return this;
	}

	public function close():PicoHttpServer {
		this.server.close();
		this.available = false;
		return this;
	}

	public function listen():Void {
		this.server.listen(1);
		var socket:Socket = this.server.accept();
		var request:PicoHttpRequest = new PicoHttpRequest().read(socket.input);
		var responseBody:Bytes = null;
		switch (request.method) {
			case PicoHttpMethod.GET:
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
			case PicoHttpMethod.POST:
				this.postUri = request.uri;
				this.postData = request.body;
			case PicoHttpMethod.INVALID:
				socket.output.write(Bytes.ofString('HTTP/1.0 500 Internal Error\r\n\r\n'));
				socket.close();
		}
		socket.output.write(Bytes.ofString('HTTP/1.0 200 OK\r\n\r\n'));
		if (responseBody != null) {
			socket.output.write(responseBody);
		}
		socket.close();
	}
}

#end
