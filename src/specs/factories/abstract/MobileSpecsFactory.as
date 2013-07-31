package specs.factories.abstract
{
    import specs.abstract.MobileSpecs;
    import specs.interfaces.IMobileSpecsFactory;

    /**
    * @author Ben Smith
    */
   public class MobileSpecsFactory extends Object implements IMobileSpecsFactory
   {

      public function makeMobileSpecs() : MobileSpecs
      {
         return new MobileSpecs();
      }
   }
}
