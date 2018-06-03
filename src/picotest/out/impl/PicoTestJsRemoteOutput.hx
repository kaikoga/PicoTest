package picotest.out.impl;

#if js

import picotest.out.buffer.PicoTestOutputStringBuffer;
import haxe.Timer;
import js.html.XMLHttpRequest;

class PicoTestJsRemoteOutput extends PicoTestTextOutputBase implements IPicoTestOutput {

	private var buffer:PicoTestOutputStringBuffer;

	private var remoteRequestIndex:Int = 0;
	private var requestsActive:Int = 0;
	private var requests:Array<Array<String>> = [];
	private var timer:Timer;

	private var closed:Bool = false;

	public function new() {
		super();
		this.requests = [];
		this.buffer = new PicoTestOutputStringBuffer(print);
		this.timer = new Timer(1);
		this.timer.run = this.onInterval;
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

	public function sendRemote(value:String, name:String):Void {
		this.requests.push([value, name]);
	}

	private function onInterval():Void {
		if (!this.closed) this.buffer.emit();
		// we use HTTP POST compatible format, as JS doesn't support raw sockets
		// FIXME we seriously must use WebSocket
		if (this.requests.length == 0) return;
		if (this.requestsActive > 1) return; // do some throttling

		var a:Array<String> = this.requests.shift();
		this.doSendRemote(a[0], a[1]);
	}

	private function doSendRemote(value:String, name:String):Void {
		this.requestsActive++;
		var xhr:XMLHttpRequest = new XMLHttpRequest();
		xhr.onreadystatechange = function():Void {
			if (xhr.readyState == XMLHttpRequest.DONE) this.requestsActive--;
		}
		xhr.open("POST", name);
		xhr.send(value);
	}
}

#end
