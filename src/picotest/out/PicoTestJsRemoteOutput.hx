package picotest.out;

import js.html.XMLHttpRequest;

class PicoTestJsRemoteOutput implements IPicoTestOutput {

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
		var xhr:XMLHttpRequest = new XMLHttpRequest();
		xhr.open("POST", name);
		xhr.send(value);
	}
}
