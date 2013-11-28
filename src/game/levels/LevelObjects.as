package game.levels {
	import flash.utils.Dictionary;
	import Box2D.Dynamics.Contacts.b2Contact;
   
	import citrus.objects.platformer.box2d.Coin;
	import citrus.physics.box2d.IBox2DPhysicsObject;
	import citrus.physics.box2d.Box2DUtils;

	import org.osflash.signals.Signal;

	import game.Inventory.Inventory;
	import game.Inventory.GameObject;
	import game.Player;
	/**
	 * @author laris11
	 */
	public class LevelObjects extends Coin {
		public var onBeingCollected:Signal;
		private var inventory:Inventory;
		private var _objectProperties:Dictionary;
		private var _name:String;
		public function LevelObjects(name:String, params:Object = null):void {
			super(name, params);
			x = params.x;
			y = params.y;
			inventory = Inventory.getInstance();
			 _objectProperties = new Dictionary();
			 _collectorClass = Player;
			 _name = name;
			setObjectPropertys(params.properties);
			onBeingCollected = new Signal(LevelObjects);
			
		}
		
		private function setObjectPropertys(properties:XMLList):void {
			
			for each (var property:XML in properties) {
				_objectProperties[property.name()] = property;
			}
		}
		
		override public function handleBeginContact(contact : b2Contact):void {
			
			var collider:IBox2DPhysicsObject = Box2DUtils.CollisionGetOther(this, contact);
 		
			if (_collectorClass && collider is _collectorClass){
				onBeingCollected.dispatch(this);
				inventory.add(new GameObject(_objectProperties));
				kill = true;
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			
		}
		
	}
}

