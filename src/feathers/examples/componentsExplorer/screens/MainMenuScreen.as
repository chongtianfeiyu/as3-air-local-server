package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.skins.StandardIcons;
	import feathers.system.DeviceCapabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	
//	import core.Assets;

	[Event(name="complete",type="starling.events.Event")]
	[Event(name="showServer",type="starling.events.Event")]
	[Event(name="showPrototypeManager",type="starling.events.Event")]


	public class MainMenuScreen extends PanelScreen
	{
		public static const SHOW_SERVER:String = "showServer";
		public static const SHOW_PROTOTYPE_MANAGER:String = "showPrototypeManager";

		
		public function MainMenuScreen()
		{
			super();
			this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
		}

		private var _list:List;
		
		protected function initializeHandler(event:Event):void
		{
			
			var isTablet:Boolean = DeviceCapabilities.isTablet(Starling.current.nativeStage);

			this.layout = new AnchorLayout();

			this.headerProperties.title = "Prototype Manager";

			this._list = new List();
			this._list.dataProvider = new ListCollection(
			[
//				{ label: "Server", event: SHOW_SERVER},
				{ label: "Server", event: SHOW_SERVER}
//				{ label: "Prototype Manager", event: SHOW_PROTOTYPE_MANAGER}
				
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.addEventListener(Event.CHANGE, list_changeHandler);

			var itemRendererAccessorySourceFunction:Function = null;
			if(!isTablet)
			{
				itemRendererAccessorySourceFunction = this.accessorySourceFunction;
			}
			this._list.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "label";
				renderer.isQuickHitAreaEnabled = true;
				renderer.accessorySourceFunction = itemRendererAccessorySourceFunction;

//              renderer.iconSourceField = "thumbnail";
//				renderer.gap = 20;
//				renderer.iconOffsetX = -10;
			

				return renderer;
			};


			if(isTablet)
			{
				this._list.selectedIndex = 0;
			}

			this.addChild(this._list);
		}

		private function accessorySourceFunction(item:Object):Texture
		{
			return StandardIcons.listDrillDownAccessoryTexture;
		}
		
		private function list_changeHandler(event:Event):void
		{
			const eventType:String = this._list.selectedItem.event as String;
			this.dispatchEventWith(eventType);
		}
	}
}