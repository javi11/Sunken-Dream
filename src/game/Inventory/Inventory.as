package game.Inventory {

	import flash.utils.Dictionary;

	public class Inventory {

		public var slots:Dictionary = new Dictionary();
		private static var _instance:Inventory;

		public function Inventory() {
		}

		public static function getInstance():Inventory {
			if (!_instance) {
				_instance = new Inventory();
			}
			return _instance;
		}

		public function clear():void{
			slots = new Dictionary();
		}

		public function add(gameObject:GameObject):void {
			if (!slots[gameObject.name]) {
				slots[gameObject.name] = gameObject;
			} else {
				slots[gameObject.name].set('quantity',slots[gameObject.name].get('quantity') + 1);
			}
		}
		
		public function set(gameObject:GameObject,num:int):void{
			slots[gameObject.name].set('quantity',num);
		}

		public function remove(gameObject:GameObject):void {
			if (slots[gameObject.name]) {
				slots[gameObject.name] = null;
			}
		}

		public function get(name:String):GameObject {
			return  slots[name] as GameObject;
		}

		public function status(name:String, ...flags):Boolean{
			if(slots[name]){
				return  slots[name].hasFlags(flags);
			}
			return false;
		}


	}
}
