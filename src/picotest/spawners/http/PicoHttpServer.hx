package picotest.spawners.http;

#if sys

import haxe.io.Bytes;
import picotest.spawners.http.connections.IPicoHttpConnection;
import picotest.spawners.http.connections.PicoHttpRequestConnection;
import picotest.spawners.http.routes.IPicoHttpRoute;
import picotest.spawners.http.routes.PicoHttpInvalidRoute;
import sys.net.Host;
import sys.net.Socket;

class PicoHttpServer {

	public var available(default, null):Bool;

	public var postUri:String;
	public var postData:Bytes;

	private var server:Socket;
	private var setting:PicoHttpServerSetting;

	private var routes:Array<IPicoHttpRoute>;
	private var connections:Map<Socket, IPicoHttpConnection>;
	private var clientSockets:Array<Socket>;

	public function new(setting:PicoHttpServerSetting) {
		this.setting = setting;
		this.connections = new Map();
		this.clientSockets = [];
		this.routes = [];
	}

	inline public function route(route:IPicoHttpRoute):PicoHttpServer {
		this.routes.push(route);
		return this;
	}

	public function open():PicoHttpServer {
		this.server = new Socket();
		this.server.bind(new Host("localhost"), this.setting.port);
		this.clientSockets.push(this.server);
		this.available = true;
		return this;
	}

	public function close():PicoHttpServer {
		this.clientSockets.remove(this.server);
		this.server.close();
		this.available = false;
		return this;
	}

	public function listen():Void {
		if (false) {
			var select:{ read: Array<Socket>,write: Array<Socket>,others: Array<Socket> } = Socket.select(this.clientSockets, this.clientSockets, [], 1.0);
			for (read in select.read) {
				if (read == this.server) this.accept() else this.tickSocket(read);
			}
			for (write in select.write) this.tickSocket(write);
			for (others in select.others) this.tickSocket(others);
			Sys.exit(1);
		} else {
			this.server.listen(1);
			var socket:Socket = this.server.accept();
			var connection:IPicoHttpConnection = new PicoHttpRequestConnection(socket, this);
			while (connection != null) connection = connection.tick();
			socket.close();
		}
	}

	private function accept():Void {
		var socket:Socket = this.server.accept();
		this.clientSockets.push(socket);
		this.connections.set(socket, new PicoHttpRequestConnection(socket, this));
	}

	private function tickSocket(socket:Socket):Void {
		var connection:IPicoHttpConnection = this.connections.get(socket).tick();
		if (connection != null) {
			this.connections.set(socket, connection);
		} else {
			socket.close();
			this.connections.remove(socket);
			this.clientSockets.remove(socket);
		}
	}

	public function request(socket:Socket, request:PicoHttpRequest):IPicoHttpConnection {
		for (route in this.routes) {
			var result:IPicoHttpConnection = route.upgrade(socket, request);
			if (result != null) return result;
		}

		return new PicoHttpInvalidRoute().upgrade(socket, request);
	}
}

#end
