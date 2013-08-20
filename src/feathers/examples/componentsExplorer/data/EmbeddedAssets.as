package feathers.examples.componentsExplorer.data
{
	import starling.textures.Texture;

	public class EmbeddedAssets
	{
		[Embed(source="/../assets/images/skull.png")]
		private static const SKULL_ICON_DARK_EMBEDDED:Class;

		[Embed(source="/../assets/images/skull-white.png")]
		private static const SKULL_ICON_LIGHT_EMBEDDED:Class;
		
		[Embed(source="/../assets/images/sherpa-manager-app/mastheadLeft.png")]
		private static const MASTHEAD_LEFT_EMBEDDED:Class;
		
		[Embed(source="/../assets/images/sherpa-manager-app/mastheadRight.png")]
		private static const MASTHEAD_RIGHT_EMBEDDED:Class;

		public static var SKULL_ICON_DARK:Texture;
		public static var SKULL_ICON_LIGHT:Texture;
		public static var MASTHEAD_LEFT_TEXTURE:Texture;
		public static var MASTHEAD_RIGHT_TEXTURE:Texture;	
		
		
		public static function initialize():void
		{
			//we can't create these textures until Starling is ready
			SKULL_ICON_DARK = Texture.fromBitmap(new SKULL_ICON_DARK_EMBEDDED());
			SKULL_ICON_LIGHT = Texture.fromBitmap(new SKULL_ICON_LIGHT_EMBEDDED());
			MASTHEAD_LEFT_TEXTURE = Texture.fromBitmap( new MASTHEAD_LEFT_EMBEDDED() );
			MASTHEAD_RIGHT_TEXTURE = Texture.fromBitmap( new MASTHEAD_RIGHT_EMBEDDED() );
		}
	}
}
