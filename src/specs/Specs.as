package specs
{
    import specs.abstract.MobileSpecs;
    import specs.interfaces.IMobileSpecsFactory;

    /**
    * @author Ben Smith
    */
   public class Specs extends Object
   {
	   
	   public static const PADDING_LEFT:Number = 20;;
	   public static const PADDING_TOP:Number = 20;
	   public static const VERTICAL_GAP:Number = 60;
	   public static const HORFIZONTAL_GAP:Number = 60;
	   
	   public static const SERVER_LAYOUT_COL2:Number = 150;
	   
      private var _specsFactory : IMobileSpecsFactory;
      private var _singletonMobileSpecs : MobileSpecs;

      public function Specs()
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
