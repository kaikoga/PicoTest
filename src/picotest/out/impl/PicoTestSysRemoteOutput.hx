package picotest.out.impl;

import picotest.out.buffer.PicoTestOutputStringBuffer;
import haxe.io.Bytes;
import sys.net.Host;
import sys.net.Socket;

#if sys

class PicoTestSysRemoteOutput extends PicoTestTextOutputBase implements IPicoTestOutput {

	private var buffer:PicoTestOutputStringBuffer;

	private var remoteRequestIndex:Int = 0;

	private var closed:Bool = false;

	public function new() {
		super();
		this.buffer = new PicoTestOutputStringBuffer(onProgress);
	}

	public function output(value:String):Void {
		this.buffer.output(value);
	}

	public function onProgress(message:String):Void {
		if (message == "") return;
		sendRemote(message, '/progress/$remoteRequestIndex');
		remoteRequestIndex++;
	}

	public function close():Void {
		if (this.closed) return;
		this.closed = true;
		this.buffer.close();
		sendRemote(this.buffer.value, '/result');
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

