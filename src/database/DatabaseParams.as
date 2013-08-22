package database
{
	import com.probertson.database.interfaces.IDatabase;
	import com.probertson.database.structure.Column;
	import com.probertson.database.Database;
	import com.probertson.database.structure.Table;
	
	import flash.data.SQLResult;
	
	import network.structure.ServerItem;
	
	import specs.Params;

	
	public class DatabaseParams extends Database implements IDatabase
	{
		
		
//		private const USER_TABLE_NAME:String = "user";
		private var serverTable:Table;

		
		public function DatabaseParams(databaseFilename:String)
		{
			super(databaseFilename);
		}
		
		//--- Database exists alogorithms

		override protected function databaseExistsAlgorithm():void
		{

		}
		
		override protected function databaseNotExistsAlgorithm():void
		{
			trace("database not exists");
			this.createTablesInDatabaseFile(); //hard coded
			this.insertDefaultData(); //user interface to collect data
			this.executeModify(); //User event to fire
		}
		
		
		//--- Get Server Data from Database
		public function getServerItem():void
		{
			this._execute_complete = this.resultServerItem;
			this.getDataFromDatabase( Params.SERVER_TABLE_NAME );
		}
		
		
		// Data Base setup methods
		override protected function createTableAndColumnStructure():void
		{

			serverTable = new Table( Params.SERVER_TABLE_NAME );
			this.add(  serverTable );

			var serverTableObject:Object = {
				"id" : Column.INT_PK_AI,
				"port" : Column.INTEGER,
				"webRoot" : Column.TEXT
			};
			
			serverTable.addColumnsByObject( serverTableObject );
			
			serverTable.itemClass = ServerItem;

		}
		
		override public function createTablesInDatabaseFile(  ):void
		{
			this.createTable( serverTable );
		}
		

		override public function insertDefaultData():void
		{
			
			var serverData:ServerItem = new ServerItem();
			serverData.port = 8080;
			serverData.webRoot = "";
			
			var obj:Object = {};
			obj.port = 8080;
			obj.webRoot = "";
			
			this.getTableByName( Params.SERVER_TABLE_NAME ).data[ Params.SERVER_DATA ] = serverData;
			this.insert( serverTable, obj );
		}
		

		private function resultServerItem(result:SQLResult):void
		{
			var obj:ServerItem = result.data[0];
			obj.name = Params.SHERPA_SERVER;
			this.getTableByName( Params.SERVER_TABLE_NAME ).data[ Params.SERVER_DATA ] = obj;
			this.callBack();
		}
		
		override public function executeBatch_complete(results:Object):void
		{
			super.executeBatch_complete(results);
			//Has to be another way to get last row inserted
//			this.execute_complete = this.resultServerItem;
//			this.getDataFromDatabase( Params.SERVER_TABLE_NAME );
			this.callBack();
		}
		

	}
}