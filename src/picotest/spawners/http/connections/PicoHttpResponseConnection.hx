package picotest.spawners.http.connections;

#if sys

import haxe.io.Bytes;
import sys.net.Socket;

class PicoHttpResponseConnection implements IPicoHttpConnection {

	private var socket:Socket;

	private var responseHeader:String;
	private var responseBody:Bytes;

	public function new(socket:Socket, responseHeader:String, responseBody:Bytes) {
		this.socket = socket;
		this.responseHeader = responseHeader;
		this.responseBody = responseBody;
	}

	public function tick():Null<IPicoHttpConnection> {
		this.socket.output.write(Bytes.ofString(this.responseHeader));
		if (this.responseBody != null) {
			socket.output.write(this.responseBody);
		}
		return null;
	}
}

#end
