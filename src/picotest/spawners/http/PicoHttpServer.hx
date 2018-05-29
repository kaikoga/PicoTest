package picotest.spawners.http;

#if sys

import picotest.spawners.http.connections.PicoHttpRequestConnection;
import haxe.io.Bytes;
import haxe.io.Input;
import picotest.spawners.http.connections.IPicoHttpConnection;
import picotest.spawners.http.connections.PicoHttpResponseConnection;
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

	private var connections:Map<Socket, IPicoHttpConnection>;
	private var readSockets:Array<Socket>;

	public function new(setting:PicoHttpServerSetting) {
		this.setting = setting;
		this.connections = new Map();
		this.readSockets = [];
	}

	public function open():PicoHttpServer {
		this.server = new Socket();
		this.server.bind(new Host("localhost"), this.setting.port);
		this.readSockets.push(this.server);
		this.available = true;
		return this;
	}

	public function close():PicoHttpServer {
		this.readSockets.remove(this.server);
		this.server.close();
		this.available = false;
		return this;
	}

	public function listen():Void {
		var select:{ read: Array<Socket>,write: Array<Socket>,others: Array<Socket> } = Socket.select(this.readSockets, this.readSockets, []);
		for (read in select.read) {
			if (read == this.server) this.accept() else this.tickSocket(read);
		}
		for (write in select.write) this.tickSocket(write);
		for (others in select.others) this.tickSocket(others);
	}

	private function accept():Void {
		var socket:Socket = this.server.accept();
		this.connections.set(socket, new PicoHttpRequestConnection(socket, this));
	}

	private function tickSocket(socket:Socket):Void {
		var connection:IPicoHttpConnection = this.connections.get(socket).tick();
		if (connection != null) {
			this.connections.set(socket, connection);
		} else {
			socket.close();
			this.connections.remove(socket);
			this.readSockets.remove(socket);
		}
	}

	public function request(socket:Socket, request:PicoHttpRequest):IPicoHttpConnection {
		var responseHeader:String = "HTTP/1.0 200 OK\r\n\r\n";
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
				responseHeader = "HTTP/1.0 500 Internal Error\r\n\r\n";
		}
		return new PicoHttpResponseConnection(socket, responseHeader, responseBody);
	}
}

#end
