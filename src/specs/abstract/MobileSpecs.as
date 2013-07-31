package specs.abstract
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;

   /**
    * @author Ben Smith
    */
   public class MobileSpecs extends EventDispatcher
   {
      public function MobileSpecs( target : IEventDispatcher = null )
      {
         super( target );
      }
      
      
   }
}
