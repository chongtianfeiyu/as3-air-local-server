package database
{
	import com.probertson.database.Template;
	import com.probertson.database.structure.Column;
	import com.probertson.database.structure.Database;
	import com.probertson.database.structure.Syntax;
	import com.probertson.database.structure.Table;
	
	import flash.data.SQLResult;
	
	import database.dataStructure.ServerItem;
	import database.dataStructure.UserItem;

	
	public class SampleDatabaseInteraction extends Template
	{
		
		private const SERVER_TABLE_NAME:String = "servers";
		private const USER_TABLE_NAME:String = "user";
		private var st:Table;
		private var ut:Table;
		
		public var serverData:Vector.<ServerItem>;
		public var userData:Vector.<UserItem>;
		
		public function SampleDatabaseInteraction(db:Database)
		{
			this.serverData = new Vector.<ServerItem>();
			this.userData = new Vector.<UserItem>();
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
			trace("database not exists");
			this.createTablesInDatabaseFile(); //hard coded
			this.insertDefaultData(); //user interface to collect data
			this.db.executeModify(); //User event to fire
		}
		
		
		//--- Get Server Data from Database
		public function getServerItem():void
		{
			this.execute_complete = this.resultServerItem;
			this.getDataFromDatabase( this.SERVER_TABLE_NAME );
		}
		
		public function getUserItem():void
		{
			this.execute_complete = this.resultUserItem;
			this.getDataFromDatabase( this.USER_TABLE_NAME );
		}

		
		// Data Base setup methods
		override protected function createTableAndColumnStructure():void
		{
			var serverTable:String = this.SERVER_TABLE_NAME;
			st = new Table( serverTable );
			db.add(  st );

			var serverTableObject:Object = {
				"id" : Column.INT_PK_AI,
				"port" : Column.TEXT,
				"webRoot" : Column.TEXT
			};
			
			st.addColumnsByObject( serverTableObject );
			
			st.itemClass = ServerItem;
			
			var userTable:String = this.USER_TABLE_NAME;
			ut = new Table( userTable );
			db.add(  ut );
			var userTableSchema:Object = {
					"id" : Column.INT_PK_AI,
					"category" : Column.TEXT,
					"firstName" : Column.TEXT,
					"lastName" : Column.TEXT
			};
			
			ut.addColumnsByObject( userTableSchema );
			ut.itemClass = UserItem;

		}
		
		override protected function createTablesInDatabaseFile(  ):void
		{
			db.createTable( st );
			db.createTable( ut );
		}
		
		//TODO use a ui to get generate data
		override protected function insertDefaultData():void
		{
			
			var serverData:Object = {};
			serverData.port = "8888";
			serverData.webRoot = "C:\Users\jerry_orta\Documents\GitHub";

			db.insert( st, serverData );
			db.insert( ut, {category:"self", firstName:"Jerry", lastName:"Orta"} );
			db.insert( ut, {category:"collaborator", firstName:"Bo", lastName:"Lora"} );
			db.insert( ut, {category:"collaborator", firstName:"Alicia", lastName:"Hickman"} );
			db.insert( ut, {category:"collaborator", firstName:"David", lastName:"Baker"} );
			
			var query:Vector.<String> = new Vector.<String>();
			query.push("category");
			
			db.update( ut, query, {category:"self", firstName:"John", lastName:"Diehard"});
			
			db.insert( ut, {category:"client", firstName:"Eisenburg" + "", lastName:"Katlin"} );
			
			db.deleteRecords( ut,  {firstName:"David", lastName:"Baker"}, Syntax.AND  );

		}
		
		//--- Get User Data from Database
		private function resultServerItem(result:SQLResult):void
		{
			var len:int = result.data.length;
			for (var i:int = 0; i < len; i++) 
			{
				//Assign to ServerItem Class
				var obj:ServerItem = result.data[i];
				trace( "id: " + obj.id + ", port: " + obj.port + ", webRoot: " + obj.webRoot );
				this.serverData.push( obj );
			}
			
			getUserItem();
		}
		
		
		
		private function resultUserItem(result:SQLResult):void
		{
			var len:int = result.data.length;
			for (var i:int = 0; i < len; i++) 
			{
				//Assign to UserItem Class
				var obj:UserItem = result.data[i];
				trace( "id: " + obj.id + ", firstName: " + obj.firstName + ", lastName: " + obj.lastName + ", category: " + obj.category );
				this.userData.push( obj );
			}
		}
	}
}