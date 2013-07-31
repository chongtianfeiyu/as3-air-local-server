package feathers.examples.componentsExplorer {

    
    import feathers.controls.ScreenNavigator;
    import feathers.controls.ScreenNavigatorItem;
    import feathers.controls.ScrollContainer;
    import feathers.examples.componentsExplorer.data.EmbeddedAssets;
    import feathers.examples.componentsExplorer.data.TextInputSettings;
    import feathers.examples.componentsExplorer.screens.PrototypeManagerScreen;
    import feathers.examples.componentsExplorer.screens.MainMenuScreen;
    import feathers.examples.componentsExplorer.screens.ServerScreen;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
    import feathers.system.DeviceCapabilities;
    import feathers.themes.AIRServerTheme;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.ResizeEvent;
	


    public class Main extends Sprite {
        private static const MAIN_MENU:String = "mainMenu";
		private static const SHOW_SERVER:String = "showServer";
        private static const SHOW_PROTOTYPE_MANAGER:String = "showPrototypeManager";
       

        private static const MAIN_MENU_EVENTS:Object =
        {
			showPrototypeManager : SHOW_PROTOTYPE_MANAGER,
			showServer : SHOW_SERVER
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

        private function layoutForTablet():void {
            this._container.width = this.stage.stageWidth;
            this._container.height = this.stage.stageHeight;
        }

        private function addedToStageHandler(event:Event):void {
            EmbeddedAssets.initialize();
//            new MetalWorksMobileTheme();
//            new AOETrigTheme();
			new AIRServerTheme();
//			Assets.init();
	
            this._navigator = new ScreenNavigator();

			const textInputSettings:TextInputSettings = new TextInputSettings();
            this._navigator.addScreen(SHOW_SERVER, new ScreenNavigatorItem( ServerScreen,
                    {
                        complete    : MAIN_MENU
                    },
                    {
                        settings: textInputSettings
                    }));
			
			this._navigator.addScreen(SHOW_PROTOTYPE_MANAGER, new ScreenNavigatorItem( PrototypeManagerScreen,
				{
					complete    : MAIN_MENU
				},
				{
					settings: textInputSettings
				}));



           
            
            this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
            this._transitionManager.duration = 0.4;

            if (DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
                this.stage.addEventListener(ResizeEvent.RESIZE, stage_resizeHandler);

                this._container = new ScrollContainer();
                this._container.layout = new AnchorLayout();
                this._container.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
                this._container.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_OFF;
                this.addChild(this._container);

                this._menu = new MainMenuScreen();
                for (var eventType:String in MAIN_MENU_EVENTS) {
                    this._menu.addEventListener(eventType, mainMenuEventHandler);
                }
                const menuLayoutData:AnchorLayoutData = new AnchorLayoutData();
                menuLayoutData.top = 0;
                menuLayoutData.bottom = 0;
                menuLayoutData.left = 0;
                this._menu.layoutData = menuLayoutData;
                this._container.addChild(this._menu);

                this._navigator.clipContent = true;
                const navigatorLayoutData:AnchorLayoutData = new AnchorLayoutData();
                navigatorLayoutData.top = 0;
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
            this._navigator.showScreen(screenName);
        }

        private function stage_resizeHandler(event:ResizeEvent):void {
            //we don't need to layout for phones because ScreenNavigator knows
            //to automatically resize itself to fill the stage if we don't give
            //it a width and height.
            this.layoutForTablet();
        }
    }
}