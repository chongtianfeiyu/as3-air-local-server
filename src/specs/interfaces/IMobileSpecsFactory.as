package specs.interfaces
{
    import specs.abstract.MobileSpecs;

    /**
    * @author Ben Smith
    */
   public interface IMobileSpecsFactory
   {
    function makeMobileSpecs() : MobileSpecs;
   }
}
