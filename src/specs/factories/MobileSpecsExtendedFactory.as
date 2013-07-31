package specs.factories
{
    import specs.abstract.MobileSpecs;
    import specs.concretes.MobileSpecsExtended;
    import specs.factories.abstract.MobileSpecsFactory;

    /**
    * @author Ben Smith
    */
   public class MobileSpecsExtendedFactory extends MobileSpecsFactory
   {
      public function MobileSpecsExtendedFactory()
      {
      }

      override public function makeMobileSpecs() : MobileSpecs
      {
         return new MobileSpecsExtended();
      }
   }
}
