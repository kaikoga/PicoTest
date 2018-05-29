package picotest.spawners.http;

import haxe.io.Bytes;
import haxe.io.Input;

class PicoHttpRequest {

	public var valid(default, null):Bool;

	public var method(default, null):PicoHttpMethod = PicoHttpMethod.INVALID;
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
