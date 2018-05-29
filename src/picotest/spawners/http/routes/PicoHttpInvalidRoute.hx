package picotest.spawners.http.routes;

#if sys

import sys.net.Socket;
import picotest.spawners.http.connections.PicoHttpResponseConnection;
import picotest.spawners.http.connections.IPicoHttpConnection;

class PicoHttpInvalidRoute implements IPicoHttpRoute {
	public function new() return;

	public function upgrade(socket:Socket, request:PicoHttpRequest):IPicoHttpConnection {
		return new PicoHttpResponseConnection(socket, "HTTP/1.0 500 Internal Error\r\n\r\n", null);
	}
}

#end
