package network
{
	
	import flash.utils.Dictionary;
	
	import network.structure.Server;
	import network.structure.Server;

	public class ServerManager
	{
		private var _dict:Dictionary;
		private static  var _instance:ServerManager;
		
		public function ServerManager( pvt:PrivateClass )
		{
			this._dict = new Dictionary();
		}
		
		
		
		public static  function getInstance ():ServerManager
		{
			if (ServerManager._instance == null)
			{
				ServerManager._instance = new ServerManager( new PrivateClass  );
			}
			return ServerManager._instance;
		}
		
		public static function addServer( server:Server ):void
		{
			ServerManager.getInstance()._dict[ server.name ] = server;
		}
		
		/**
		 * Gets a database by file name. If data base does not exist, it creates a database. 
		 * @param databaseFilename
		 * @return 
		 * 
		 */		
		public static function getServer( name:String ):Server
		{
			
			return ServerManager.getInstance()._dict[ name ];
		}
		
	}
}

class PrivateClass
{
	public function PrivateClass ()
	{
		trace ("PrivateClass called");
	}
}