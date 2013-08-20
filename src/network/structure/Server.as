package network.structure
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import feathers.controls.Label;
	

	
	
	public class Server
	{
		private var _name:String;
		private var _port:int;
		private var _webRoot:String;
		protected var serverSocket:ServerSocket;
		private var _webRootDirectory:File;
		protected var mimeTypes:Dictionary = new Dictionary();
		private var _serverItem:ServerItem;
		
		private var log:String;
		
		public function Server( params:ServerItem )
		{
			this.log = "";
			
			this._serverItem = params;
			this._name = params.name;
			
			if (params.port) {
				this._port = params.port;
			}
			
			if (params.directory != null) {
				this._webRootDirectory = params.directory;
			}
			
			mimeTypes = new Dictionary();
			init();
		}
		
		private function init():void
		{
			
			mimeTypes[".css"] 	= "text/css";
			mimeTypes[".gif"] 	= "image/gif";
			mimeTypes[".htm"] 	= "text/html";
			mimeTypes[".html"] 	= "text/html";
			mimeTypes[".ico"] 	= "image/x-icon";
			mimeTypes[".jpg"] 	= "image/jpeg";
			mimeTypes[".js"] 	= "application/x-javascript";
			mimeTypes[".png"] 	= "image/png";
			mimeTypes[".swf"] 	= "application/x-shockwave-flash";
			
			_webRootDirectory = this._webRootDirectory;
			trace(this._webRootDirectory.nativePath);
			
		}
		
		// ========================== Web Socket Stuff ===========================
		protected function listen():void
		{
			try
			{
				serverSocket = new ServerSocket();
				serverSocket.addEventListener(flash.events.Event.CONNECT, socketConnectHandler);
				serverSocket.bind(Number(this._port));
				serverSocket.listen();
				this.log += "Listening on port " + this._port + "...\n";
				trace( this.log );
			}
			catch (error:Error)
			{
				var msg:Label = new Label();
				msg.text = "Port " + this._port + " may be in use. Enter another port number and try again.";
//				const callout:Callout = Callout.show(DisplayObject(msg), String(this._port), Callout.DIRECTION_DOWN);
				//const callout:Callout = Callout.show(DisplayObject(this._message), origin, direction);
				//TODO Add Alert
				//				Alert.show("Port " + port.text + 
				//					" may be in use. Enter another port number and try again.\n(" +
				//					error.message +")", "Error");
			}
		}
		

		
		protected function socketConnectHandler(event:ServerSocketConnectEvent):void
		{
			var socket:Socket = event.socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		protected function socketDataHandler(event:ProgressEvent):void
		{
			try
			{
				var socket:Socket = event.target as Socket;
				var bytes:ByteArray = new ByteArray();
				socket.readBytes(bytes);
				var request:String = "" + bytes;
				this.log += request;
				var filePath:String = request.substring(4, request.indexOf("HTTP/") - 1);
				//				var file:File = File.applicationStorageDirectory.resolvePath("webroot" + filePath);
				//				var file:File =  this._webRootDirectory.resolvePath( filePath );
				var file:File =  new File( this._webRootDirectory.nativePath + filePath );
				if (file.exists && !file.isDirectory)
				{
					var stream:FileStream = new FileStream();
					stream.open( file, FileMode.READ );
					var content:ByteArray = new ByteArray();
					stream.readBytes(content);
					stream.close();
					socket.writeUTFBytes("HTTP/1.1 200 OK\n");
					socket.writeUTFBytes("Content-Type: " + getMimeType(filePath) + "\n\n");
					socket.writeBytes(content);
				}
				else
				{
					socket.writeUTFBytes("HTTP/1.1 404 Not Found\n");
					socket.writeUTFBytes("Content-Type: text/html\n\n");
					socket.writeUTFBytes("<html><body><h2>Page Not Found</h2></body></html>");
				}
				socket.flush();
				socket.close();
			}
			catch (error:Error)
			{
				//TODO show feathers alert
				//				Alert.show(error.message, "Error");
			}
		}
		
		protected function getMimeType(path:String):String
		{
			var mimeType:String;
			var index:int = path.lastIndexOf(".");
			if (index > -1)
			{
				mimeType = mimeTypes[path.substring(index)];
			}
			return mimeType == null ? "text/html" : mimeType; // default to text/html for unknown mime types
		}

		public function get name():String
		{
			return _name;
		}
		
		public function start():void
		{
			listen();
			
		}
		
		public function stop():void
		{
			serverSocket.close();
		}

		public function get port():int
		{
			return this.serverItem.port;
		}

		public function set port(value:int):void
		{
			this._port = value;
			this.serverItem.port = value;
		}

		public function get webRoot():String
		{
			return unescape( this.serverItem.webRoot );
		}

		public function set webRoot(value:String):void
		{
			this._webRoot = value;
			this.serverItem.webRoot = escape( value );
		}

		public function get serverItem():ServerItem
		{
			
			return _serverItem;
		}

		public function set serverItem(value:ServerItem):void
		{
			_serverItem = value;
		}
		
		
		
		

	}
}