package picotest.spawners.http.connections;

#if sys

import sys.net.Socket;

class PicoHttpRequestConnection implements IPicoHttpConnection {

	private var socket:Socket;
	private var server:PicoHttpServer;

	public function new(socket:Socket, server:PicoHttpServer) {
		this.socket = socket;
		this.server = server;
	}

	public function tick():Null<IPicoHttpConnection> {
		var request:PicoHttpRequest = new PicoHttpRequest().read(socket.input);
		return server.request(socket, request);
	}
}

#end
