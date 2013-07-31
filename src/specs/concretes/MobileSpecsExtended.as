package specs.concretes
{
    import specs.abstract.MobileSpecs;

    import flash.events.IEventDispatcher;

    /**
    * @author Ben Smith
    */
   public class MobileSpecsExtended extends MobileSpecs
   {
      public function MobileSpecsExtended( target : IEventDispatcher = null )
      {
         super( target );
      }
   }
}
