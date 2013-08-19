package database.dataStructure
{

	public class ServerItem
	{
		public var id:int;
		public var port:int;
		public var webRoot:String;
		
		public function getDataObject():Object
		{
			var obj:Object = {};
			obj.id = this.id;
			obj.port = this.port;
			obj.webRoot = this.webRoot;
			return obj;
		}
	}
	
	
}