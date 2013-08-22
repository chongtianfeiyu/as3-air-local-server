package feathers.sherpa.screens {
//    import flash.events.Event;
    import com.greensock.TimelineLite;
    import com.greensock.TweenAlign;
    import com.greensock.TweenLite;
    import com.greensock.plugins.AutoAlphaPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.probertson.database.DatabaseManager;
    import com.probertson.database.Database;
    import com.probertson.database.structure.Table;
    
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.ServerSocket;
    
    import feathers.controls.Button;
    import feathers.controls.Callout;
    import feathers.controls.ImageLoader;
    import feathers.controls.Label;
    import feathers.controls.PanelScreen;
    import feathers.controls.ScrollText;
    import feathers.controls.TextArea;
    import feathers.controls.TextInput;
    import feathers.events.FeathersEventType;
    import feathers.sherpa.data.TextInputSettings;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.themes.text.ItalicInstructionsLabel;
    import feathers.themes.text.LabelHeaderLabel;
    
    import network.ServerManager;
    import network.structure.Server;
    import network.structure.ServerItem;
    import network.utils.ScanPort;
    
    import specs.Params;
    import specs.T;
    
    import starling.display.DisplayObject;
    import starling.events.Event;

    [Event(name="complete", type="starling.events.Event")]
//    [Event(name="showSettings", type="starling.events.Event")]

    public class IntroScreen extends PanelScreen {
		
//        public static const SHOW_SETTINGS:String = "showSettings";
		protected var mimeTypes:Object = new Object();
		
        public function IntroScreen() {
            super();
            this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
        }
		
		
		
		//WEBROOT INFO
		private var _webRootLabel:Label;
		private var _webRootInput:TextInput;
		private var _webRootSetRootButton:Button;	

		//WEBROOT FILE
		private var _webRootDirectory:File;

		//WEBROOT ITALICIZED INSTRUCTIONS
		private var _instructionsLabel:ItalicInstructionsLabel;
        private var _icon:ImageLoader;
		private var _startServerButton:Button;
		public var settings:TextInputSettings;
		private var log:TextArea;
		protected var serverSocket:ServerSocket;
		private var _webRootInstructions:ScrollText;
		private var _nextButton:Button;

		private var _serverItem:ServerItem;

        protected function initializeHandler(event:starling.events.Event):void {
			trace("INTRO START");
			this.layout = new AnchorLayout();
			
//			ServerManager.getServer( Params.SERVER_NAME ).serverItem = DatabaseManager.getDatabase( Params.DATABASE_NAME ).data[ Params.SERVER_DATA ];

			this._serverItem = new ServerItem;
			this._serverItem.name = Params.SHERPA_SERVER;
			
			const scanPort:ScanPort = new ScanPort( 8080, 3 );
			scanPort.onComplete = this.scanPortComplete;
			scanPort.startScanning();
			
			
			// ====================  HEADER PROPERTIES =========================
            this.headerProperties.title = "Setup";
/*
            if (!DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
                this._next = new Button();
                this._next.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
                this._next.label = "Next";
                this._next.addEventListener(starling.events.Event.TRIGGERED, backButton_triggeredHandler);

                this.headerProperties.leftItems = new <DisplayObject>
                        [
                            this._next
                        ];

                this.backButtonHandler = this.onBackButton;
            }
			*/

			this.chooseWebRoot();
			
		}		
		
		
		
		
		// ============================= CHOOSE WEB ROOT =============================
		// ============================= CHOOSE WEB ROOT =============================
		// ============================= CHOOSE WEB ROOT =============================
		private function chooseWebRoot():void{
			trace("CHOOST WEBROOT");
			//LABEL
			const _webRootLabelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_webRootLabelLayoutData.left = Params.PADDING_LEFT;
			_webRootLabelLayoutData.top = 50;
			
			this._webRootLabel = new LabelHeaderLabel();

			this._webRootLabel.text = "WebRoot:";
			this._webRootLabel.layoutData = _webRootLabelLayoutData;
			this.addChild( this._webRootLabel );
			
			//TEXT INPUT
			const _webRootInputData:AnchorLayoutData = new AnchorLayoutData();
			_webRootInputData.left = Params.PADDING_LEFT;
			_webRootInputData.top = 100;

			this._webRootInput = new TextInput();
			this._webRootInput.prompt = Params.CHOOSE_WEB_ROOT;
			this._webRootInput.width = 940;
			this._webRootInput.isEditable = true;
			
			this._webRootInput.layoutData = _webRootInputData;
			this.addChild(this._webRootInput);
			

			
			//WEBROOT SELECT BUTTON
			this._webRootSetRootButton = new Button();
			this._webRootSetRootButton.label = "Choose WebRoot";
			this._webRootSetRootButton.isToggle = true;
			this._webRootSetRootButton.addEventListener(starling.events.Event.TRIGGERED, selectWebRootDirectory);
			
			const _webRootSetRootButtonnLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_webRootSetRootButtonnLayoutData.left = Params.PADDING_LEFT;
			_webRootSetRootButtonnLayoutData.top = 150;
			
			this._webRootSetRootButton.layoutData = _webRootSetRootButtonnLayoutData;
			this.addChild( this._webRootSetRootButton );
			
			//WEBROOT INSTRUCTIONS
			const webRootInstr:AnchorLayoutData = new AnchorLayoutData();
			webRootInstr.top = 200;
			webRootInstr.left =  Params.PADDING_LEFT - 5;
			webRootInstr.right = 50;
			
			this._webRootInstructions = new ScrollText();
			this._webRootInstructions.text = 'The \"WebRoot\" is parent folder of all your Sherpa projects, as well the root directory that is used by \"http://localhost\". This setting will be saved, and automatically set upon each launch of Sherpa Manager.';
			this._webRootInstructions.layoutData = webRootInstr;
			this.addChild(this._webRootInstructions);
			
			//Next Button
			const nextLayout:AnchorLayoutData = new AnchorLayoutData();
			nextLayout.top = 300;
			nextLayout.horizontalCenter = 0;
			
			this._nextButton = new Button();
			this._nextButton.nameList.add(Button.ALTERNATE_NAME_FORWARD_BUTTON);
			this._nextButton.label = " Next  ";
			this._nextButton.layoutData = nextLayout;
			this.addChild( this._nextButton );
			this._nextButton.addEventListener(starling.events.Event.TRIGGERED, nextButton_triggeredHandler);
			
			// =================== Set up timeline =========================
			fadeWebrootOutTL = new TimelineLite({paused:true, onComplete:portSetup});
			fadeWebrootOutTL.insertMultiple([
				TweenLite.to(this._webRootLabel, T.TIME_OFF, {alpha: 0}),
				TweenLite.to(this._webRootInput, T.TIME_OFF, {alpha: 0}),
				TweenLite.to(this._webRootSetRootButton, T.TIME_OFF, {alpha: 0}),
				TweenLite.to(this._webRootInstructions, T.TIME_OFF, {alpha: 0}),
				TweenLite.to(this._nextButton, T.TIME_OFF, {alpha : 0})
			], .01, TweenAlign.NORMAL, T.STAGGER);
			
			
			// ====================  WebRoot Select  =========================
			
			_webRootDirectory = new File();
			_webRootDirectory.addEventListener(flash.events.Event.SELECT, directorySelected); 
		}

			
		private function onBackButton():void {
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}
		
		
		private var fadeWebrootOutTL:TimelineLite;
		
		private function nextButton_triggeredHandler(event:starling.events.Event):void {
			if ( this._webRootInput.text.length == 0) 
			{
				//Callout
				var _message:Label = new Label();
				_message.text = Params.CHOOSE_CALLOUT; 
			
				const callout:Callout = Callout.show(DisplayObject(_message), this._webRootInput, Callout.DIRECTION_DOWN);

			} else {
				trace("PLAY NEXT ");
				this._nextButton.removeEventListener(starling.events.Event.TRIGGERED, nextButton_triggeredHandler);
				fadeWebrootOutTL.play();
			}

		}
		
		private function finishedButton_triggeredHandler(event:starling.events.Event):void {
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}

		
		private function selectWebRootDirectory():void {
			_webRootDirectory.browseForDirectory("Choose a directory"); 
		}
		
		private function directorySelected(event:flash.events.Event):void 
		{
			_webRootDirectory = event.target as File;
			_webRootInput.text = _webRootDirectory.nativePath;
			
//			ServerManager.getServer( Params.SERVER_NAME ).webRoot = _webRootInput.text;
			_serverItem.directory = _webRootDirectory;
						
			
			var files:Array = _webRootDirectory.getDirectoryListing();
			for(var i:uint = 0; i < files.length; i++)
			{
//				trace(files[i].name);
			}
		}
		
		
		// ============================= CHOOSE PORT =============================
		// ============================= CHOOSE PORT =============================
		// ============================= CHOOSE PORT =============================
		
		private var portIsSetup:Boolean = false;
		private var portTimeline:TimelineLite;
		
		//PORT INFO		
		private var _portLabel:Label;
		private var _port:TextInput;
		private var _finished:Button;
		private var _portInstructions:ScrollText;
		
		
		
		private function portSetup():void 
		{
			trace("PORT SETUP");
			//LABEL
			const _portLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_portLayoutData.left = Params.PADDING_LEFT;
			_portLayoutData.top = 50;
			
			this._portLabel = new LabelHeaderLabel();
			
			this._portLabel.text = "Port:";
			this._portLabel.layoutData = _portLayoutData;
			this.addChild( this._portLabel );
			
			//TEXT INPUT
			const _portData:AnchorLayoutData = new AnchorLayoutData();
			_portData.left = Params.PADDING_LEFT;
			_portData.top = 100;
			
			this._port = new TextInput();
			this._port.prompt = String( this._serverItem.port );
			this._port.text = String( this._serverItem.port );
			this._port.width = 100;
			this._port.isEditable = true;
			
			this._port.layoutData = _portData;
			this.addChild(this._port);

			
			//WEBROOT INSTRUCTIONS
			const _portInstructionsData:AnchorLayoutData = new AnchorLayoutData();
			_portInstructionsData.top = 200;
			_portInstructionsData.left =  Params.PADDING_LEFT - 5;
			_portInstructionsData.right = 50;
			
			this._portInstructions = new ScrollText();
			this._portInstructions.text = 'The \"Port\" should be unique for your local web server to run. If you do not have a preference, leave as default.';
			this._portInstructions.layoutData = _portInstructionsData;
			this.addChild(this._portInstructions);
			
			//Next Button
			const nextLayout:AnchorLayoutData = new AnchorLayoutData();
			nextLayout.top = 300;
			nextLayout.horizontalCenter = 0;
			
			this._finished = new Button();
			this._finished.nameList.add(Button.DEFAULT_CHILD_NAME_LABEL);
			this._finished.label = " Finished ";
			this._finished.layoutData = nextLayout;
			this.addChild( this._finished );
			this._finished.addEventListener(starling.events.Event.TRIGGERED, finishedButton_treggeredHandler);
			
			// =================== Set up timeline =========================
			portTimeline = new TimelineLite({paused:true});
			portTimeline.insertMultiple([
				TweenLite.to(this._portLabel, T.TIME_OFF, {alpha: 1}),
				TweenLite.to(this._port, T.TIME_OFF, {alpha: 1}),
				TweenLite.to(this._portInstructions, T.TIME_OFF, {alpha: 1}),
				TweenLite.to(this._finished, T.TIME_OFF, {alpha : 1})
			], 0, TweenAlign.NORMAL, T.STAGGER);
			
			this.portIsSetup = true;
			
			portTimeline.play();
			
		}
//		
//		private function playPort():void {
//			if (portIsSetup) {
//				portTimeline.play();
//			} else {
//				this.portSetup();
//			}
//		}
		
		private function scanPortComplete( _tempPort:uint ):void 
		{
//			ServerManager.getServer( Params.SERVER_NAME ).port = _tempPort;
			this._serverItem.port = _tempPort;
		}
		
		private function finishedButton_treggeredHandler():void 
		{

		
			const _server:Server = new Server( _serverItem );
			_server.port = Number( this._port.text );
			this._serverItem.port = _server.port;
			ServerManager.addServer( _server );
			_server.start();
			
			const _db:Database = DatabaseManager.getDatabase( Params.SHERPA_DATABASE );
			const st:Table = _db.getTableByName( Params.SERVER_TABLE_NAME );
			
			var query:Vector.<String> = new Vector.<String>();
			query.push("id");
			
			
			_db.update( st, query, {id:1, port:_server.port, webRoot:this._serverItem.escapedWebRoot});
			_db.executeModify();
			
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}

		
    }
}