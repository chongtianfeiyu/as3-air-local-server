package feathers.examples.componentsExplorer.screens {
//    import flash.events.Event;
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
    import feathers.controls.ImageLoader;
    import feathers.controls.Label;
    import feathers.controls.PanelScreen;
    import feathers.controls.TextArea;
    import feathers.controls.TextInput;
    import feathers.events.FeathersEventType;
    import feathers.examples.componentsExplorer.data.TextInputSettings;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.system.DeviceCapabilities;
    
    import specs.Specs;
    
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
		

        protected function initializeHandler(event:starling.events.Event):void {
            	
			this.layout = new AnchorLayout();
			
			// The mime types supported by this mini web server
			mimeTypes[".css"] 	= "text/css";
			mimeTypes[".gif"] 	= "image/gif";
			mimeTypes[".htm"] 	= "text/html";
			mimeTypes[".html"] 	= "text/html";
			mimeTypes[".ico"] 	= "image/x-icon";
			mimeTypes[".jpg"] 	= "image/jpeg";
			mimeTypes[".js"] 	= "application/x-javascript";
			mimeTypes[".png"] 	= "image/png";
			
			this.layout = new AnchorLayout();
			
			// ====================  PORT =========================
			this._portLabel = new Label();
			this._portLabel.text = "Port:";
			const _portLabelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_portLabelLayoutData.left = Specs.PADDING_LEFT;
			_portLabelLayoutData.top = Specs.PADDING_TOP;
			this._portLabel.layoutData = _portLabelLayoutData;
			this.addChild( this._portLabel );
			
			this._port = new TextInput();
			this._port.prompt = "8888";
			this._port.text = "8888";
			this._port.displayAsPassword = this.settings.displayAsPassword;
			this._port.width = 100;
//			this._port.maxChars = this.settings.maxChars;
			this._port.isEditable = true;
			
			const _portLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_portLayoutData.left = Specs.SERVER_LAYOUT_COL2;
			_portLayoutData.top = Specs.PADDING_TOP;
			
			this._port.layoutData = _portLayoutData;
			this.addChild(this._port);
			
			// ====================  WEB ROOT  =========================
			this._webRootLabel = new Label();
			this._webRootLabel.text = "WebRoot:";
			const _webRootLabelLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_webRootLabelLayoutData.left = Specs.PADDING_LEFT;
			_webRootLabelLayoutData.top = Specs.PADDING_TOP + Specs.VERTICAL_GAP;
			
			this._webRootLabel.layoutData = _webRootLabelLayoutData;
			this.addChild( this._webRootLabel );
			
			const _webRootInputWidth:Number = 400;
			
			this._webRootInput = new TextInput();
			this._webRootInput.prompt = "Set Web Root";
			this._webRootInput.displayAsPassword = this.settings.displayAsPassword;
			this._webRootInput.width = _webRootInputWidth;
			this._webRootInput.isEditable = true;
			
			const _webRootInputData:AnchorLayoutData = new AnchorLayoutData();
			_webRootInputData.left = Specs.SERVER_LAYOUT_COL2;
			_webRootInputData.top = Specs.PADDING_TOP + Specs.VERTICAL_GAP;
			
			this._webRootInput.layoutData = _webRootInputData;
			this.addChild(this._webRootInput);
			
			
			this._webRootSetRootButton = new Button();
			this._webRootSetRootButton.label = "Set WebRoot";
			this._webRootSetRootButton.isToggle = true;
			this._webRootSetRootButton.addEventListener(starling.events.Event.TRIGGERED, selectWebRootDirectory);
			
			const _webRootSetRootButtonnLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_webRootSetRootButtonnLayoutData.left = Specs.PADDING_LEFT + _webRootInputWidth + 20 + Specs.SERVER_LAYOUT_COL2;
			_webRootSetRootButtonnLayoutData.top = Specs.PADDING_TOP + (Specs.VERTICAL_GAP);
			
			this._webRootSetRootButton.layoutData = _webRootSetRootButtonnLayoutData;
			this.addChild( this._webRootSetRootButton );
			
			// ====================  WebRoot Select  =========================
			
			_webRootDirectory = new File();
			_webRootDirectory.addEventListener(flash.events.Event.SELECT, directorySelected); 
			
			// ====================  START SERVER BUTTON  =========================
			this._startServerButton = new Button();
			this._startServerButton.label = "Start Server";
			this._startServerButton.isToggle = true;
			this._startServerButton.addEventListener(starling.events.Event.TRIGGERED, listen);
			
			const _startServerButtonLayoutData:AnchorLayoutData = new AnchorLayoutData();
			_startServerButtonLayoutData.left = Specs.PADDING_LEFT;
			_startServerButtonLayoutData.top = Specs.PADDING_TOP + (Specs.VERTICAL_GAP * 2);
			
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
			logLayoutData.left = Specs.PADDING_LEFT;
			logLayoutData.top = Specs.PADDING_TOP + (Specs.VERTICAL_GAP * 3);
			
			this.log.layoutData = logLayoutData;
			
			this.addChild( this.log );
			
			// ====================  HEADER PROPERTIES =========================
            this.headerProperties.title = "Server";

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
			
			

			
			// ====================  SETTINGS PROPERTIES =========================
			
			
//            this._settingsButton = new Button();
//            this._settingsButton.label = "Settings";
//            this._settingsButton.addEventListener(Event.TRIGGERED, settingsButton_triggeredHandler);

//            this.headerProperties.rightItems = new <DisplayObject>
//                    [
//                        this._settingsButton
//                    ];
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
				trace(files[i].name);
			}
		}
		
        private function onBackButton():void {
            this.dispatchEventWith(starling.events.Event.COMPLETE);
        }



        private function backButton_triggeredHandler(event:starling.events.Event):void {
            this.onBackButton();
        }


		
		// ========================== Web Socket Stuff ===========================
		protected function listen():void
		{
			try
			{
				serverSocket = new ServerSocket();
				serverSocket.addEventListener(flash.events.Event.CONNECT, socketConnectHandler);
				serverSocket.bind(Number(this._port.text));
				serverSocket.listen();
				this.log.text += "Listening on port " + this._port.text + "...\n";
			}
			catch (error:Error)
			{
				//TODO Add Alert
//				Alert.show("Port " + port.text + 
//					" may be in use. Enter another port number and try again.\n(" +
//					error.message +")", "Error");
			}
		}
		
		
		
		
		protected function socketConnectHandler(event:ServerSocketConnectEvent):void
		{
			var socket:Socket = event.socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		protected function socketDataHandler(event:ProgressEvent):void
		{
			try
			{
				var socket:Socket = event.target as Socket;
				var bytes:ByteArray = new ByteArray();
				socket.readBytes(bytes);
				var request:String = "" + bytes;
				this.log.text += request;
				var filePath:String = request.substring(4, request.indexOf("HTTP/") - 1);
//				var file:File = File.applicationStorageDirectory.resolvePath("webroot" + filePath);
//				var file:File =  this._webRootDirectory.resolvePath( filePath );
				var file:File =  new File( this._webRootDirectory.nativePath + filePath );
				if (file.exists && !file.isDirectory)
				{
					var stream:FileStream = new FileStream();
					stream.open( file, FileMode.READ );
					var content:ByteArray = new ByteArray();
					stream.readBytes(content);
					stream.close();
					socket.writeUTFBytes("HTTP/1.1 200 OK\n");
					socket.writeUTFBytes("Content-Type: " + getMimeType(filePath) + "\n\n");
					socket.writeBytes(content);
				}
				else
				{
					socket.writeUTFBytes("HTTP/1.1 404 Not Found\n");
					socket.writeUTFBytes("Content-Type: text/html\n\n");
					socket.writeUTFBytes("<html><body><h2>Page Not Found</h2></body></html>");
				}
				socket.flush();
				socket.close();
			}
			catch (error:Error)
			{
				//TODO show feathers alert
//				Alert.show(error.message, "Error");
			}
		}
		
		protected function getMimeType(path:String):String
		{
			var mimeType:String;
			var index:int = path.lastIndexOf(".");
			if (index > -1)
			{
				mimeType = mimeTypes[path.substring(index)];
			}
			return mimeType == null ? "text/html" : mimeType; // default to text/html for unknown mime types
		}
		
    }
}