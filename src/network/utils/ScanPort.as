package network.utils
{
	public class ScanPort
	{
		
		import flash.net.*;
		import flash.events.*;
		
		private var socket:Socket;
		private var _port:uint;
		private var _onComplete:Function;
		
		private var _consecutivePorts:int = 0;
		private var _maxPortsTest:int;
		private var _basePort:uint = 0;
		private var _startTestPort:uint;
		
		public function ScanPort( _testPort:uint = 8080, _testConsecutivePorts:int = 3 )
		{
			this._port = _testPort;
			this._startTestPort = _testPort;
			this._maxPortsTest = _testConsecutivePorts;
		}
		
		private function createSocket():void
		{
			socket = new Socket();
			socket.addEventListener("connect", socket_connect);
			socket.addEventListener("ioError", socket_ioError);
			
		}
		private function deleteSocket():void
		{
			socket.removeEventListener("connect",socket_connect);
			socket.removeEventListener("ioError", socket_ioError);
			socket.close ();
		}
		
		public function startScanning():void
		{
			createSocket();
			scanPort(this._port);	
		}
	
		
		
		private function scanPort(port:uint):void
		{

		 	socket.connect("127.0.0.1", port);

		}
		
		/**
		 * Successful connect.
		 */
		private function socket_connect(event:Event):void
		{
			this._consecutivePorts = 0;
			
			/* 
			Not sure, when there is ioError I am not able to reuse same socket object.
			So deleting current socket object and recreating another socket object...
			*/
			deleteSocket();
			createSocket();
			this._startTestPort += 10;
			this._port = this._startTestPort;
			scanPort(this._port);
			
			
		}
		
		private function socket_ioError(event:IOErrorEvent):void
		{
			if (this._consecutivePorts == 0)
			{
				this._basePort = this._port;
			}

			this._consecutivePorts++;
			
			
			if (this._consecutivePorts < this._maxPortsTest)
			{
				deleteSocket();
				createSocket();

				this._port++;
				scanPort( this._port );
				
			} else {

				if (this._onComplete != null)
				{
					deleteSocket();
					this._onComplete.apply( null, [ this._basePort ] );
				}
			}
		}
		
		

		public function get port():int
		{
			return _port;
		}

		public function set port(value:int):void
		{
			_port = value;
		}

		public function get onComplete():Function
		{
			return _onComplete;
		}

		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}


	}
}