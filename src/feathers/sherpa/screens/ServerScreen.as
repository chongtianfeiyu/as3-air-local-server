package feathers.sherpa.screens {
//    import flash.events.Event;
    import com.probertson.database.DatabaseManager;
    import com.probertson.database.Database;
    import com.probertson.database.structure.Table;
    
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.ServerSocketConnectEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.ServerSocket;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    
    import feathers.controls.Button;
    import feathers.controls.Callout;
    import feathers.controls.ImageLoader;
    import feathers.controls.Label;
    import feathers.controls.PanelScreen;
    import feathers.controls.TextArea;
    import feathers.controls.TextInput;
    import feathers.events.FeathersEventType;
    import feathers.sherpa.data.TextInputSettings;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.system.DeviceCapabilities;
    
    import network.ServerManager;
    import network.structure.Server;
    import network.structure.ServerItem;
    
    import specs.Params;
    
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.events.Event;
	
	

    [Event(name="complete", type="starling.events.Event")]
    [Event(name="showSettings", type="starling.events.Event")]

    public class ServerScreen extends PanelScreen {
		
        public static const SHOW_SETTINGS:String = "showSettings";
		protected var mimeTypes:Object = new Object();
		
        public function ServerScreen() {
            super();
            this.addEventListener(FeathersEventType.INITIALIZE, initializeHandler);
        }
		
				
		private var _portLabel:Label;
		private var _port:TextInput;
		
		private var _webRootLabel:Label;
		private var _webRootInput:TextInput;
		private var _webRootSetRootButton:Button;
		private var _webRootDirectory:File;

        private var _backButton:Button;

        private var _icon:ImageLoader;
		private var _startServerButton:Button;
		
		public var settings:TextInputSettings;
		
		private var log:TextArea;
		protected var serverSocket:ServerSocket;
		private var _serverItem:ServerItem;
		

        protected function initializeHandler(event:starling.events.Event):void {

			this.layout = new AnchorLayout();
			//Get Server Instance
			_serverItem = DatabaseManager.getDatabase( Params.SHERPA_DATABASE ).getTableByName( Params.SERVER_TABLE_NAME ).data[ Params.SERVER_DATA ];
			this.layoutScreen();

        }
		
		private function layoutScreen():void 
		{
			
			// ====================  PORT =========================
			this._portLabel = new Label();
			this._portLabel.text = "Port:";
			const _portLabelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_portLabelLayoutData.left = Params.PADDING_LEFT;
			_portLabelLayoutData.top = Params.PADDING_TOP;
			this._portLabel.layoutData = _portLabelLayoutData;
			this.addChild( this._portLabel );
			
			this._port = new TextInput();
			this._port.prompt = String(this._serverItem.port);
			this._port.text = String(this._serverItem.port);
			this._port.displayAsPassword = this.settings.displayAsPassword;
			this._port.width = 100;
			//			this._port.maxChars = this.settings.maxChars;
			this._port.isEditable = true;
			
			const _portLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_portLayoutData.left = Params.SERVER_LAYOUT_COL2;
			_portLayoutData.top = Params.PADDING_TOP;
			
			this._port.layoutData = _portLayoutData;
			this.addChild(this._port);
			
			// ====================  WEB ROOT  =========================
			this._webRootLabel = new Label();
			this._webRootLabel.text = "WebRoot:";
			const _webRootLabelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_webRootLabelLayoutData.left = Params.PADDING_LEFT;
			_webRootLabelLayoutData.top = Params.PADDING_TOP + Params.VERTICAL_GAP;
			
			this._webRootLabel.layoutData = _webRootLabelLayoutData;
			this.addChild( this._webRootLabel );
			
			const _webRootInputWidth:Number = 400;
			
			this._webRootInput = new TextInput();
			this._webRootInput.prompt = this._serverItem.webRoot;
			this._webRootInput.displayAsPassword = this.settings.displayAsPassword;
			this._webRootInput.width = _webRootInputWidth;
			this._webRootInput.isEditable = true;
			
			const _webRootInputData:AnchorLayoutData = new AnchorLayoutData();
			_webRootInputData.left = Params.SERVER_LAYOUT_COL2;
			_webRootInputData.top = Params.PADDING_TOP + Params.VERTICAL_GAP;
			
			this._webRootInput.layoutData = _webRootInputData;
			this.addChild(this._webRootInput);
			
			
			this._webRootSetRootButton = new Button();
			this._webRootSetRootButton.label = "Change WebRoot";
			this._webRootSetRootButton.isToggle = true;
			this._webRootSetRootButton.addEventListener(starling.events.Event.TRIGGERED, selectWebRootDirectory);
			
			const _webRootSetRootButtonnLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_webRootSetRootButtonnLayoutData.left = Params.PADDING_LEFT + _webRootInputWidth + 20 + Params.SERVER_LAYOUT_COL2;
			_webRootSetRootButtonnLayoutData.top = Params.PADDING_TOP + (Params.VERTICAL_GAP);
			
			this._webRootSetRootButton.layoutData = _webRootSetRootButtonnLayoutData;
			this.addChild( this._webRootSetRootButton );
			
			// ====================  WebRoot Select  =========================
			
			_webRootDirectory = new File();
			_webRootDirectory.addEventListener(flash.events.Event.SELECT, directorySelected); 
			
			// ====================  START SERVER BUTTON  =========================
			this._startServerButton = new Button();
			this._startServerButton.label = "Stop Server";
			this._startServerButton.isToggle = true;
			
			//			this._startServerButton.addEventListener(starling.events.Event.TRIGGERED, listen);
			
			const _startServerButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_startServerButtonLayoutData.left = Params.PADDING_LEFT;
			_startServerButtonLayoutData.top = Params.PADDING_TOP + (Params.VERTICAL_GAP * 2);
			
			this._startServerButton.layoutData = _startServerButtonLayoutData;
			this.addChild( this._startServerButton );
			
			
			// ====================  LOG DATA =========================
			this.log = new TextArea();
			this.log.text = ""; //it's multiline!
			this.log.selectRange( 0, log.text.length );
			//			log.addEventListener( Event.CHANGE, input_changeHandler );
			this.log.width = 500;
			this.log.height = 500;
			
			const logLayoutData:AnchorLayoutData = new AnchorLayoutData();
			logLayoutData.left = Params.PADDING_LEFT;
			logLayoutData.top = Params.PADDING_TOP + (Params.VERTICAL_GAP * 3);
			
			this.log.layoutData = logLayoutData;
			
			this.addChild( this.log );
			
			// ====================  HEADER PROPERTIES =========================
			//            this.headerProperties.title = " ";
			
			if (!DeviceCapabilities.isTablet(Starling.current.nativeStage)) {
				this._backButton = new Button();
				this._backButton.nameList.add(Button.ALTERNATE_NAME_BACK_BUTTON);
				this._backButton.label = "Back";
				this._backButton.addEventListener(starling.events.Event.TRIGGERED, backButton_triggeredHandler);
				
				this.headerProperties.leftItems = new <DisplayObject>
					[
						this._backButton
					];
				
				this.backButtonHandler = this.onBackButton;
			}
		}
		
		private function selectWebRootDirectory():void {
			_webRootDirectory.browseForDirectory("Select a directory"); 
		}
		
		private function directorySelected(event:flash.events.Event):void 
		{
			_webRootDirectory = event.target as File;
			_webRootInput.text = _webRootDirectory.nativePath;
			var files:Array = _webRootDirectory.getDirectoryListing();
			for(var i:uint = 0; i < files.length; i++)
			{
//				trace(files[i].name);
			}
		}
		
        private function onBackButton():void {
            this.dispatchEventWith(starling.events.Event.COMPLETE);
        }



        private function backButton_triggeredHandler(event:starling.events.Event):void {
            this.onBackButton();
        }


		
		
		
    }
}