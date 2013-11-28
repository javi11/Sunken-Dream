package game.Inventory {
	import flash.utils.Dictionary;
	/**
	 * @author Javier
	 */
	public class GameObject {
		public static const LOCKED:int=0;
		public static const UNLOCKED:int=1;
		public var name:String;
		public var _objectProperties:Dictionary;
		
		public function GameObject(property:Dictionary) {
			name = property['name'];
			_objectProperties = property;
		}
		
		public function set(key:String,value:*):void {
			_objectProperties[key] = value;
		}

		public function get(key:String):* {
			return _objectProperties[key];
		}		
		
	}
}
