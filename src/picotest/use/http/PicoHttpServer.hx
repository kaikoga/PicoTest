package picotest.use.http;

import sys.io.File;
import sys.net.Host;
import sys.net.Socket;
import haxe.io.Bytes;
import picotest.use.http.PicoHttpServer.PicoHttpRequest;
import haxe.io.Input;

#if sys

class PicoHttpServer {

	public var available(default, null):Bool;

	public var postData:Bytes;// FIXME

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
				if ((setting.files != null) && setting.files.exists(request.uri)) {
					localFile = setting.files.get(request.uri);
				} else if (setting.index != null) {
					localFile = setting.index;
				}
				if (localFile != null) {
					var input:Input = File.read(localFile);
					responseBody = input.readAll();
					input.close();
				}
			case PicoHttpMethod.POST:
				postData = request.body;
			case _:
		}
		socket.output.write(Bytes.ofString('HTTP/1.0 200 OK\r\n\r\n'));
		if (responseBody != null) {
			socket.output.write(responseBody);
		}
		socket.close();
	}
}

typedef PicoHttpServerSetting = {
	port:Int,
	files:Map<String, String>,
	index:String
}

enum PicoHttpMethod {
	INVALID;
	GET;
	POST;
}

class PicoHttpRequest {

	public var valid(default, null):Bool;

	public var method(default, null):PicoHttpMethod;
	public var uri(default, null):String;
	public var httpVersion(default, null):String;

	public var contentLength(default, null):Int;
	public var body(default, null):Bytes;
	
	public function new():Void {
	}
	
	private static function readMethod(str:String):PicoHttpMethod {
		switch (str) {
			case "GET": return PicoHttpMethod.GET;
			case "POST": return PicoHttpMethod.POST;
			case _: return PicoHttpMethod.INVALID;
		}
	}
	
	public function read(input:Input):PicoHttpRequest {
		var header:String = input.readLine();
		switch (header.split(" ")) {
			case [method, uri, httpVersion]:
				this.method = readMethod(method);
				this.uri = uri;
				this.httpVersion = httpVersion;
			case _: return this;
		}
		while (header != "") {
			header = input.readLine();
			switch (header.split(":")) {
				case ["Content-Length", value]:
					contentLength = Std.parseInt(StringTools.trim(value));
				case _:
			}
		}
		if (contentLength > 0) body = input.read(contentLength);
		this.valid = true;
		return this;
	}
}

#end
