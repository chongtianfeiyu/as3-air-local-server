package feathers.examples.componentsExplorer.screens {
    import feathers.controls.Button;
    import feathers.controls.ImageLoader;
    import feathers.controls.PanelScreen;
    import feathers.controls.TextInput;
    import feathers.events.FeathersEventType;
    import feathers.examples.componentsExplorer.data.TextInputSettings;
    import feathers.layout.AnchorLayoutData;
    import feathers.system.DeviceCapabilities;
    
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.events.Event;

	[Event(name="complete", type="starling.events.Event")]
    [Event(name="showSettings", type="starling.events.Event")]

    public class PrototypeManagerScreen extends PanelScreen {
        public static const SHOW_SETTINGS:String = "showSettings";

        public function PrototypeManagerScreen() {
            super();
            this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
        }

        

//        private var _normalButton:Button;
//        private var _disabledButton:Button;
//        private var _iconButton:Button;
//        private var _toggleButton:Button;
//        private var _callToActionButton:Button;
//        private var _quietButton:Button;
//        private var _dangerButton:Button;
//        private var _sampleBackButton:Button;
//        private var _forwardButton:Button;
//        private var _settingsButton:Button;

        private var _backButton:Button;

        private var _icon:ImageLoader;
		
		public var settings:TextInputSettings;
		private var _input:TextInput;

        protected function initializeHandler(event:Event):void {
                     

			this._input = new TextInput();
			this._input.prompt = "Type Something";
			this._input.displayAsPassword = this.settings.displayAsPassword;
			this._input.maxChars = this.settings.maxChars;
			this._input.isEditable = this.settings.isEditable;
			const inputLayoutData:AnchorLayoutData = new AnchorLayoutData();
			inputLayoutData.horizontalCenter = 0;
			inputLayoutData.verticalCenter = 0;
			this._input.layoutData = inputLayoutData;
			this.addChild(this._input);
			
            this.headerProperties.title = "Cosine Function";

            if (!DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
                this._backButton = new Button();
                this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
                this._backButton.label = "Back";
                this._backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);

                this.headerProperties.leftItems = new <DisplayObject>
                        [
                            this._backButton
                        ];

                this.backButtonHandler = this.onBackButton;
            }

//            this._settingsButton = new Button();
//            this._settingsButton.label = "Settings";
//            this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

//            this.headerProperties.rightItems = new <DisplayObject>
//                    [
//                        this._settingsButton
//                    ];
        }

        private function onBackButton():void {
            this.dispatchEventWith(Event.COMPLETE);
        }

 /*       private function normalButton_triggeredHandler(event:Event):void {
            trace("normal button triggered.")
        }*/

/*        private function toggleButton_changeHandler(event:Event):void {
            trace("toggle button changed:", this._toggleButton.isSelected);
        }*/

        private function backButton_triggeredHandler(event:Event):void {
            this.onBackButton();
        }

       /* private function settingsButton_triggeredHandler(event:Event):void {
            this.dispatchEventWith(SHOW_SETTINGS);
        }*/
    }
}