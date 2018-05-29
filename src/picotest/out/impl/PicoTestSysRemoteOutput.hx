package picotest.out.impl;

import picotest.out.buffer.PicoTestOutputStringBuffer;
import haxe.io.Bytes;
import sys.net.Host;
import sys.net.Socket;

#if sys

class PicoTestSysRemoteOutput implements IPicoTestOutput {

	private var buffer:PicoTestOutputStringBuffer;

	private var remoteRequestIndex:Int = 0;

	private var closed:Bool = false;

	public function new() {
		this.buffer = new PicoTestOutputStringBuffer(print);
	}

	public function output(value:String):Void {
		this.buffer.output(value);
	}

	public function print(message:String):Void {
		if (message == "") return;
		sendRemote(message, '/result/$remoteRequestIndex');
		remoteRequestIndex++;
	}

	public function close():Void {
		if (this.closed) return;
		this.buffer.close();
		sendRemote("", '/eof/$remoteRequestIndex');
		remoteRequestIndex++;
		this.closed = true;
	}

	public static function sendRemote(value:String, name:String):Void {
		// we use HTTP POST compatible format, as JS doesn't support raw sockets
		var socket:Socket = new Socket();
		socket.connect(new Host("127.0.0.1"), 8001);
		socket.write('POST ${name} HTTP/picotest\r\n\r\n');
		socket.output.write(Bytes.ofString(value));
		socket.close();
	}
}

#end

