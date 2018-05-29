package picotest.spawners.http.routes;

#if sys

import sys.net.Socket;
import picotest.spawners.http.connections.IPicoHttpConnection;

interface IPicoHttpRoute {
	public function upgrade(socket:Socket, request:PicoHttpRequest):IPicoHttpConnection;
}

#end
