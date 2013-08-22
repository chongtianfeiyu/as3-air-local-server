package feathers.sherpa {

    import com.probertson.database.DatabaseManager;
    import com.probertson.database.Database;
    
    import flash.display.BitmapData;
    
    import database.DatabaseParams;
    
    import feathers.controls.ScreenNavigator;
    import feathers.controls.ScreenNavigatorItem;
    import feathers.controls.ScrollContainer;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
    import feathers.sherpa.data.EmbeddedAssets;
    import feathers.sherpa.data.TextInputSettings;
    import feathers.sherpa.screens.IntroScreen;
    import feathers.sherpa.screens.MainMenuScreen;
    import feathers.sherpa.screens.ServerScreen;
    import feathers.system.DeviceCapabilities;
    import feathers.themes.AIRServerTheme;
    
    import network.ServerManager;
    import network.structure.Server;
    import network.structure.ServerItem;
    
    import specs.Params;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.ResizeEvent;
    import starling.textures.Texture;

    public class Main extends Sprite {
		private static const SHOW_INTRO:String = "intro";
        private static const MAIN_MENU:String = "mainMenu";
		private static const SHOW_SERVER:String = "showServer";
        private static const SHOW_PROTOTYPE_MANAGER:String = "showPrototypeManager";

        private static const MAIN_MENU_EVENTS:Object =
        {
			showPrototypeManager : SHOW_PROTOTYPE_MANAGER,
			showServer : SHOW_SERVER,
			showIntro : SHOW_INTRO
        };

        public function Main() {
            super();
            this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
            this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        }

        private var _container:ScrollContainer;
        private var _navigator:ScreenNavigator;
        private var _menu:MainMenuScreen;
        private var _transitionManager:ScreenSlidingStackTransitionManager;
		
		//DATABASE

		private var _appDatabaseParams:DatabaseParams;

        private function layoutForTablet():void {
            this._container.width = this.stage.stageWidth;
            this._container.height = this.stage.stageHeight;
			
			this.layoutMastHead();
        }

        private function addedToStageHandler(event:Event):void {
            EmbeddedAssets.initialize();
			new AIRServerTheme();

			//DATABASE CONFIG
			const _database:Database  = new Database( Params.SHERPA_DATABASE );
			DatabaseManager.addDatabase( _database );
			DatabaseManager.getDatabase( Params.SHERPA_DATABASE ).onComplete = this.serverDataResult;
//			DatabaseManager.getDatabase( Params.SHERPA_DATABASE ).init();

			
        }
		
		private function serverDataResult():void 
		{
			trace( "serverDataResult");
			const _serverItem:ServerItem = DatabaseManager.getDatabase( Params.SHERPA_DATABASE ).getTableByName( Params.SERVER_TABLE_NAME ).data[ Params.SERVER_DATA ];
						
			this._navigator = new ScreenNavigator();
			
			const textInputSettings:TextInputSettings = new TextInputSettings();
			this._navigator.addScreen(SHOW_SERVER, new ScreenNavigatorItem( ServerScreen,
				{
					complete    : MAIN_MENU
				},
				{
					settings: textInputSettings
				}));
			
		
			buildMastHead();
			
			
			if (DatabaseManager.getDatabase( Params.SHERPA_DATABASE ).exists && _serverItem.webRoot != null )
			{			
				trace(" MENU LAYOUT ");
				//Start Server
				const _server:Server = new Server( _serverItem );
				ServerManager.addServer( _server );
				ServerManager.getServer( Params.SHERPA_SERVER ).start();
				
				menuLayout();
			} else {
				trace(" INTRO LAYOUT ");
				introLayout();
			}	
		}
		
		private var _introInit:Boolean = false;
		private var intro:IntroScreen;


		private function introLayout():void
		{
			this.intro = new IntroScreen();
			this.intro.addEventListener(Event.COMPLETE, introComplete);
			const introLayoutData:AnchorLayoutData = new AnchorLayoutData();
			introLayoutData.top = 100;
			introLayoutData.right = 0;
			introLayoutData.bottom = 0;
			introLayoutData.left = 0;
			this.intro.layoutData = introLayoutData;
			this._container.addChild( this.intro );
		}
		
		private function introComplete( event:Event ):void 
		{
			trace("REMOVE INTRO");
			this.intro.removeEventListener(Event.COMPLETE, introComplete);
			this._container.removeChild( this.intro );
			this.intro = null;
			
			this.menuLayout();
		}
				

		
		private function menuLayout():void 
		{
			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.4;
			
			if (DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
				this._menu = new MainMenuScreen();
				for (var eventType:String in MAIN_MENU_EVENTS) {
					this._menu.addEventListener(eventType, mainMenuEventHandler);
				}
				const menuLayoutData:AnchorLayoutData = new AnchorLayoutData();
				menuLayoutData.top = 100;
				menuLayoutData.bottom = 0;
				menuLayoutData.left = 0;
				this._menu.layoutData = menuLayoutData;
				this._container.addChild(this._menu);
				
				this._navigator.clipContent = true;
				const navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
				navigatorLayoutData.top = 100;
				navigatorLayoutData.right = 0;
				navigatorLayoutData.bottom = 0;
				navigatorLayoutData.leftAnchorDisplayObject = this._menu;
				navigatorLayoutData.left = 0;
				this._navigator.layoutData = navigatorLayoutData;
				
				this._container.addChild(this._navigator);
				
				this.layoutForTablet();
			}
			else {
				this._navigator.addScreen(MAIN_MENU, new ScreenNavigatorItem(MainMenuScreen, MAIN_MENU_EVENTS));
				this.addChild(this._navigator);
				this._navigator.showScreen(MAIN_MENU);
			}
		}

        private function removedFromStageHandler(event:Event):void {
            this.stage.removeEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
        }

        private function mainMenuEventHandler(event:Event):void {
            const screenName:String = MAIN_MENU_EVENTS[event.type];
			
            //because we're controlling the navigation externally, it doesn't
            //make sense to transition or keep a history
            this._transitionManager.clearStack();
            this._transitionManager.skipNextTransition = true;
			
			this._navigator.showScreen( screenName );

           
        }

        private function stage_resizeHandler(event:ResizeEvent):void {
            //we don't need to layout for phones because ScreenNavigator knows
            //to automatically resize itself to fill the stage if we don't give
            //it a width and height.
			
            this.layoutForTablet();
        }
		
		private var mastheadBackground:Image;
		private var mastheadLeft:Image;
		private var mastheadRight:Image;
		private function layoutMastHead():void {
			
			mastheadBackground.width = this._container.width;
			mastheadBackground.height = 100;
			mastheadBackground.x = 0.01;
			mastheadBackground.y = 0;
			
			mastheadLeft.x = 0.01;
			mastheadLeft.y = 0;
			
			mastheadRight.y = 0;
			mastheadRight.x = this._container.width - mastheadRight.width;

		}
		
		private function drawBackground():Image
		{
			const shape:flash.display.Sprite = new flash.display.Sprite();
			shape.graphics.beginFill( 0xffffff );
			shape.graphics.drawRect( 0, 0, 1024, 100);
			shape.graphics.endFill();
			
			var bmd:BitmapData = new BitmapData( 1024, 100 );
			bmd.draw( shape );
			const texture:Texture = Texture.fromBitmapData( bmd );
			
			const image:Image = new Image( texture );
			return image;
		}
		
		private function buildMastHead():void 
		{
			if (DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
				this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);
				
				this._container = new ScrollContainer();
				this._container.layout = new AnchorLayout();
				this._container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				this._container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
				this.addChild(this._container);
				
				//Mast Head
				mastheadBackground = this.drawBackground();
				this.addChild( mastheadBackground );
				
				mastheadLeft = new Image( EmbeddedAssets.MASTHEAD_LEFT_TEXTURE );
				this.addChild( mastheadLeft );
				
				mastheadRight = new Image( EmbeddedAssets.MASTHEAD_RIGHT_TEXTURE );
				this.addChild( mastheadRight );
			}
			
			this.layoutForTablet();
			
		}
		

    }
}