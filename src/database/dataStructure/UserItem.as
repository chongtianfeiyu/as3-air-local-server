package database.dataStructure
{
	public class UserItem
	{
		public var id:int;
		public var category:String;
		public var firstName:String;
		public var lastName:String;
		
		public function getDataObject():Object
		{
			var obj:Object = {};
			obj.id = this.id;
			obj.category = this.category;
			obj.firstName = this.firstName;
			obj.lastName = this.lastName;
			return obj;
		}
	}
}