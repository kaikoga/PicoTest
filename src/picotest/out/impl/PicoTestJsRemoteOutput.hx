package picotest.out.impl;

#if js

import haxe.Timer;
import js.html.XMLHttpRequest;

class PicoTestJsRemoteOutput implements IPicoTestOutput {

	private var remoteRequestIndex:Int = 0;
	private var requestsActive:Int = 0;
	private var requests:Array<Array<String>> = [];
	private var timer:Timer;

	public function new() {
		this.requests = [];
		this.timer = new Timer(1);
		this.timer.run = this.onInterval;
	}

	public function stdout(value:String):Void {
		sendRemote(value, '/result/$remoteRequestIndex');
		remoteRequestIndex++;
	}

	public function close():Void {
		sendRemote("", '/eof/$remoteRequestIndex');
		remoteRequestIndex++;
	}

	public function sendRemote(value:String, name:String):Void {
		this.requests.push([value, name]);
	}

	private function onInterval():Void {
		// we use HTTP POST compatible format, as JS doesn't support raw sockets
		// FIXME we seriously must use WebSocket
		if (this.requests.length == 0) return;
		if (this.requestsActive > 1) return; // do some throttling
		this.requestsActive++;
		var a:Array<String> = this.requests.pop();
		var xhr:XMLHttpRequest = new XMLHttpRequest();
		xhr.onreadystatechange = function():Void {
			if (xhr.readyState == XMLHttpRequest.DONE) this.requestsActive--;
		}
		xhr.open("POST", a[1]);
		xhr.send(a[0]);
	}
}

#end
