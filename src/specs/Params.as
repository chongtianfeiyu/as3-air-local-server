package specs
{
    import specs.abstract.MobileSpecs;
    import specs.interfaces.IMobileSpecsFactory;

    /**
    * @author Ben Smith
    */
   public class Params extends Object
   {
	   public static const SHERPA_DATABASE:String = "SherpaManager.db";
	   public static const SERVER_DATA:String = "serverData";
	   public static const SERVER_TABLE_NAME:String = "servers";
	   
	   public static const SHERPA_SERVER:String = "sherpaServer";
	   
	   public static const CHOOSE_WEB_ROOT:String =  "Choose Web Root";
	   public static const CHOOSE_CALLOUT:String =  " You must choose a web root directory. ";
	   
	   
	   public static const PADDING_LEFT:Number = 50;
	   public static const PADDING_TOP:Number = 50;
	   public static const VERTICAL_GAP:Number = 60;
	   public static const HORFIZONTAL_GAP:Number = 60;
	   
	   public static const SERVER_LAYOUT_COL2:Number = 150;
	   
	   
      private var _specsFactory : IMobileSpecsFactory;
      private var _singletonMobileSpecs : MobileSpecs;

      public function Params()
      {
      }

      public function getInstance() : MobileSpecs
      {
         if (!_singletonMobileSpecs)
         {
            _singletonMobileSpecs = _specsFactory.makeMobileSpecs();
         }
         
         return _singletonMobileSpecs;
      }


   }
}
