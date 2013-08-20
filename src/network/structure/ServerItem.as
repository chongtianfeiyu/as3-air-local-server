package network.structure
{
	import flash.filesystem.File;

	public class ServerItem
	{
		public var id:int;
		public var port:int;
		private var _webRoot:String;
		public var name:String;
		private var _directory:File;
		
		public function getDataObject():Object
		{
			var obj:Object = {};
			obj.id = this.id;
			obj.port = this.port;
			obj.name = this.name;
			obj.webRoot = this.webRoot;
			return obj;
		}
		
		public function get escapedWebRoot():String
		{
			return _webRoot;
		}

		public function get webRoot():String
		{
			return unescape(_webRoot);
		}

		public function set webRoot(value:String):void
		{
			_webRoot = escape(value);
		}

		public function get directory():File
		{
			return _directory;
		}

		public function set directory(value:File):void
		{
			this._webRoot = escape( value.nativePath );
			_directory = value;
		}


	}
	
	
}