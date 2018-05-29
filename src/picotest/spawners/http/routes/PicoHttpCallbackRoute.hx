package picotest.spawners.http.routes;

#if sys

import picotest.spawners.http.connections.IPicoHttpConnection;
import sys.net.Socket;

class PicoHttpCallbackRoute implements IPicoHttpRoute {

	private var callback:Socket->PicoHttpRequest->IPicoHttpConnection;

	public function new(callback:Socket->PicoHttpRequest->IPicoHttpConnection):Void this.callback = callback;

	public function upgrade(socket:Socket, request:PicoHttpRequest):IPicoHttpConnection return this.callback(socket, request);
}

#end
