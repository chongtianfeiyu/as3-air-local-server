/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.themes
{

    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    import feathers.aoe.trig.text.LabelInputNumber;
    import feathers.controls.List;
    import feathers.controls.TextInput;
    
    import starling.core.Starling;
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;


	public class AIRServerTheme extends MetalWorksMobileThemeSuper
	{

		//TODO Font for Custom Label
		[Embed(source="/../assets/fonts/SourceSansPro-Light.ttf",fontName="SourceSansProLight",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
		protected static const SOURCE_SANS_PRO_LIGHT:Class;


		/**
		 * The background of the entire list. Not the the item renderer background color. 
		 */		
		protected static const LIST_BACKGROUND_COLOR:uint = 0x383430;


        protected var smallLightNumberInputField:TextFormat;



		public function AIRServerTheme( container:DisplayObjectContainer = null, scaleToDPI:Boolean = true )
		{
			super();

		}
		
		override protected function initializeRoot():void
		{
			super.initializeRoot();
			
			

			
		}
		
		private const fontScale:Number = 3;
		private const HEADER_SIZE:Number = 36 * fontScale; //original was 36
		private const SMALL_FONT_SIZE:Number = 24 * fontScale; //original was 24
		private const LARGE_FONT_SIZE:Number = 28 * fontScale; //original was 28

        override protected function initialize():void {
            super.initialize();

            const lightFontNames:String = "SourceSansProLight";
			
			
			
			
			

            //regularFontNames looks better than light Font Names
            this.smallLightNumberInputField = new TextFormat(regularFontNames, LARGE_FONT_SIZE * this.scale, LIGHT_TEXT_COLOR, true);

            this.setInitializerForClass(LabelInputNumber, LabelInputNumberInitializer);
			
			
			this.headerTextFormat = new TextFormat(semiboldFontNames, Math.round(HEADER_SIZE * this.scale), LIGHT_TEXT_COLOR, true);

			
			this.smallUIDarkTextFormat = new TextFormat(semiboldFontNames, SMALL_FONT_SIZE * this.scale, DARK_TEXT_COLOR, true);
			this.smallUILightTextFormat = new TextFormat(semiboldFontNames, SMALL_FONT_SIZE * this.scale, LIGHT_TEXT_COLOR, true);
			this.smallUISelectedTextFormat = new TextFormat(semiboldFontNames, SMALL_FONT_SIZE * this.scale, SELECTED_TEXT_COLOR, true);
			this.smallUILightDisabledTextFormat = new TextFormat(semiboldFontNames, SMALL_FONT_SIZE * this.scale, DISABLED_TEXT_COLOR, true);
			this.smallUIDarkDisabledTextFormat = new TextFormat(semiboldFontNames, SMALL_FONT_SIZE * this.scale, DARK_DISABLED_TEXT_COLOR, true);
			
			this.largeUIDarkTextFormat = new TextFormat(semiboldFontNames, LARGE_FONT_SIZE * this.scale, DARK_TEXT_COLOR, true);
			this.largeUILightTextFormat = new TextFormat(semiboldFontNames, LARGE_FONT_SIZE * this.scale, LIGHT_TEXT_COLOR, true);
			this.largeUISelectedTextFormat = new TextFormat(semiboldFontNames, LARGE_FONT_SIZE * this.scale, SELECTED_TEXT_COLOR, true);
			this.largeUIDisabledTextFormat = new TextFormat(semiboldFontNames, LARGE_FONT_SIZE * this.scale, DISABLED_TEXT_COLOR, true);
			
			this.smallDarkTextFormat = new TextFormat(regularFontNames, SMALL_FONT_SIZE * this.scale, DARK_TEXT_COLOR);
			this.smallLightTextFormat = new TextFormat(regularFontNames, SMALL_FONT_SIZE * this.scale, LIGHT_TEXT_COLOR);
			this.smallDisabledTextFormat = new TextFormat(regularFontNames, SMALL_FONT_SIZE * this.scale, DISABLED_TEXT_COLOR);
			this.smallLightTextFormatCentered = new TextFormat(regularFontNames, SMALL_FONT_SIZE * this.scale, LIGHT_TEXT_COLOR, null, null, null, null, null, TextFormatAlign.CENTER);
			
			this.largeDarkTextFormat = new TextFormat(regularFontNames, LARGE_FONT_SIZE * this.scale, DARK_TEXT_COLOR);
			this.largeLightTextFormat = new TextFormat(regularFontNames, LARGE_FONT_SIZE * this.scale, LIGHT_TEXT_COLOR);
			this.largeDisabledTextFormat = new TextFormat(regularFontNames, LARGE_FONT_SIZE * this.scale, DISABLED_TEXT_COLOR);

        }

        private function LabelInputNumberInitializer(labelInputNumber:LabelInputNumber):void {
            labelInputNumber.textRendererProperties.textFormat = this.smallLightNumberInputField;
            labelInputNumber.textRendererProperties.embedFonts = true;
        }


		//TODO override list here
		override protected function listInitializer(list:List):void
		{
			const backgroundSkin:Quad = new Quad(100, 100, LIST_BACKGROUND_COLOR);
			list.backgroundSkin = backgroundSkin;
			list.itemRendererProperties

        	list.verticalScrollBarFactory = this.verticalScrollBarFactory;
			list.horizontalScrollBarFactory = this.horizontalScrollBarFactory;
		}
		
		override protected function textInputInitializer(input:TextInput):void
		{
			super.textInputInitializer(input);
			input.textEditorProperties.fontSize = SMALL_FONT_SIZE * this.scale;
			
			input.promptProperties.textFormat = this.smallLightTextFormat;
			input.promptProperties.embedFonts = true;
		}


	}
}
