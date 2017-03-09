package picotest.out.impl;

import haxe.io.Bytes;
import sys.net.Host;
import sys.net.Socket;

#if sys

class PicoTestSysRemoteOutput implements IPicoTestOutput {

	private var remoteRequestIndex:Int = 0;

	public function new() {
	}

	public function stdout(value:String):Void {
		sendRemote(value, '/result/$remoteRequestIndex');
		remoteRequestIndex++;
	}

	public function close():Void {
		sendRemote("", '/eof/$remoteRequestIndex');
		remoteRequestIndex++;
	}

	public static function sendRemote(value:String, name:String):Void {
		// we use HTTP POST compatible format, as JS doesn't support raw sockets
		var socket:Socket = new Socket();
		socket.connect(new Host("127.0.0.1"), 8001);
		socket.write('POST /eof HTTP/picotest\r\n\r\n');
		socket.output.write(Bytes.ofString(value));
		socket.close();
	}
}

#end

