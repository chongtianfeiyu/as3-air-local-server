package database
{
	import com.probertson.database.Template;
	import com.probertson.database.structure.Column;
	import com.probertson.database.structure.Database;
	import com.probertson.database.structure.Table;
	
	import flash.data.SQLResult;
	
	import network.structure.ServerItem;
	
	import specs.Params;

	
	public class DatabaseParams extends Template
	{
		
		
//		private const USER_TABLE_NAME:String = "user";
		private var serverTable:Table;

		
		public function DatabaseParams(db:Database)
		{

			super(db);
		}
		
		//--- Database exists alogorithms

		override protected function databaseExistsAlgorithm():void
		{
						
			trace("database exists");
			this.getServerItem();
			
		}
		
		override protected function databaseNotExistsAlgorithm():void
		{
//			this.db._executeBatch_complete = this.resultServerItem
				
			trace("database not exists");
			this.createTablesInDatabaseFile(); //hard coded
			this.insertDefaultData(); //user interface to collect data
			this.db.executeModify(); //User event to fire
		}
		
		
		//--- Get Server Data from Database
		public function getServerItem():void
		{
			this.execute_complete = this.resultServerItem;
			this.getDataFromDatabase( Params.SERVER_TABLE_NAME );
		}
		/*
		public function getUserItem():void
		{
			this.execute_complete = this.resultUserItem;
			this.getDataFromDatabase( this.USER_TABLE_NAME );
		}
*/
		
		// Data Base setup methods
		override protected function createTableAndColumnStructure():void
		{

			serverTable = new Table( Params.SERVER_TABLE_NAME );
			db.add(  serverTable );

			var serverTableObject:Object = {
				"id" : Column.INT_PK_AI,
				"port" : Column.INTEGER,
				"webRoot" : Column.TEXT
			};
			
			serverTable.addColumnsByObject( serverTableObject );
			
			serverTable.itemClass = ServerItem;

		}
		
		override protected function createTablesInDatabaseFile(  ):void
		{
			db.createTable( serverTable );
		}
		

		override protected function insertDefaultData():void
		{
			
			var serverData:ServerItem = new ServerItem();
			serverData.port = 8080;
			serverData.webRoot = "";
			
			var obj:Object = {};
			obj.port = 8080;
			obj.webRoot = "";
			
			db.getTableByName( Params.SERVER_TABLE_NAME ).data[ Params.SERVER_DATA ] = serverData;
			db.insert( serverTable, obj );
		}
		

		private function resultServerItem(result:SQLResult):void
		{
			var obj:ServerItem = result.data[0];
			db.getTableByName( Params.SERVER_TABLE_NAME ).data[ Params.SERVER_DATA ] = obj;
		}
		
		override protected function executeBatch_complete(results:Object):void
		{
			super.executeBatch_complete(results);
			
//			if (results is Vector.<SQLResult>) {
//
//				db.getTableByName( Params.SERVER_TABLE_NAME ).data[ Params.SERVER_DATA ].id = (results as Vector.<SQLResult>)[0].lastInsertRowID;
//				trace ((results as Vector.<SQLResult>)[0].lastInsertRowID);
//			}
			
			//Has to be another way to get last row inserted
			this.execute_complete = this.resultServerItem;
			this.getDataFromDatabase( Params.SERVER_TABLE_NAME );

		}
		

	}
}