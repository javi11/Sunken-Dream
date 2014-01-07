package game.Inventory {
	import feathers.controls.Button;

	import game.ObserverManager;
	import game.Weapon;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Color;

	import flash.utils.Dictionary;

	public class Inventory extends Sprite{
		
		public static const LOCKED : int = 0;
		public static const UNLOCKED : int = 1;
		
		public var slots:Dictionary = new Dictionary();
		private static var _instance:Inventory;
		private var _inventoryView:Image;
		private var _inventorySprite:Sprite;
		private var _paddingX:int = 100;
		private	var _paddingY:int = 140;
		private var _usedItem:GameObject;
		protected var observer:ObserverManager;
		private var weapon:Weapon;
		
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
				slots[gameObject.name]['set']('quantity',int(slots[gameObject.name]['get']('quantity'))+1);
			}
		}
		
		public function set(gameObject:GameObject,num:int):void{
			slots[gameObject.name]['set']('quantity',num);
		}

		public function remove(gameObject:GameObject):void {
			if (slots[gameObject.name]) {
				slots[gameObject.name]['set']('quantity',int(slots[gameObject.name]['get']('quantity'))-1);
				if(int(slots[gameObject.name]['get']('quantity')) == 0) {
					delete slots[gameObject.name];
				}
			}
		}

		public function get(name:String):GameObject {
			return  slots[name] as GameObject;
		}

		public function status(name:String, status:int):Boolean{
			if(slots[name]){
				return  slots[name]['setStatus'](status);
			}
			return false;
		}
		
		public function showInventory(Texture:TextureAtlas):void {
			_inventoryView = new Image(Texture.getTexture("inventario"));
			_inventoryView.width = 800;
			_inventoryView.height = 500;
			_inventorySprite = new Sprite();
			addChild(_inventoryView);

						
			var lvObjects:Button = new Button();
			lvObjects.label = "Objetos del Nivel";
			lvObjects.x = _paddingX-14;
			lvObjects.y = _paddingY-70;
			lvObjects.name = "key";
			lvObjects.touchable = true;
			lvObjects.useHandCursor = true;
			lvObjects.addEventListener(Event.TRIGGERED, categoryHandler );
			lvObjects.width = 170;
			lvObjects.height = 40;
			lvObjects.addChild(new  TextField(200, 50,"Objetos del Nivel" , "Arial", 18, Color.BLACK,true));
			_inventorySprite.addChild(lvObjects);
			
			var weapons:Button = new Button();
			weapons.label = "Armas";
			weapons.name = "weapons";
			weapons.x = _paddingX+285;
			weapons.y = _paddingY-70;
			weapons.touchable = true;
			weapons.useHandCursor = true;
			weapons.width = 170;
			weapons.height = 40;
			weapons.addEventListener(Event.TRIGGERED, categoryHandler );
			weapons.addChild(new  TextField(200, 50,"Armas" , "Arial", 18, Color.BLACK, true));
			_inventorySprite.addChild(weapons);	

			var otherObjects:Button = new Button();
			otherObjects.label = "Otros Objetos";
			otherObjects.name = "items";
			otherObjects.x = _paddingX+455;
			otherObjects.y = _paddingY-70;
			otherObjects.touchable = true;
			otherObjects.useHandCursor = true;
			otherObjects.width = 170;
			otherObjects.height = 40;
			otherObjects.addEventListener(Event.TRIGGERED, categoryHandler );	
			otherObjects.addChild(new  TextField(200, 50,"Otros Objetos" , "Arial", 18, Color.BLACK, true));
			_inventorySprite.addChild(otherObjects);
			
			makeInventoryItems("key");
			addChild(_inventorySprite);	
							
		}
		
		public function hideInventory():void {
			removeChild(_inventoryView);
			removeChild(_inventorySprite);
		}
		
		public function categoryHandler(e:Event):void {
			var target:Button = e.currentTarget as Button;
			switch(target.name) {
				case 'key':
					makeInventoryItems("key");
				break;
				case 'items':
					makeInventoryItems("item");
				break;
				case 'weapons':
					makeInventoryItems("weapon");
				break;
			}
		}
		
		public function makeInventoryItems(type:String):void {
			if(!isEmptyInventory()) {
				removeAllChildren(_inventorySprite);
				var row:int = 0;
				var col:int = 0;
				var marginX:int = 15;
				for (var key:Object in slots) {
					var item:GameObject = slots[key];
					if(item.get("type") == type && item.getStatus() == UNLOCKED) {
						item.updateObject();
						item.x = (item.width+marginX)*col+_paddingX;
						if(col == 17)
						{
							row += 1;
							col = 0;
						}
						item.y = (item.height+marginX)*row+_paddingY;
						item.addEventListener(TouchEvent.TOUCH, useItem);
						col++;
						_inventorySprite.addChild(item);
						
					}
				}
			}
		}
		private function removeAllChildren(ui:Sprite):void{
			for( var i:int = ui.numChildren - 1; i>=0; i-- ) {
   				 if( ui.getChildAt(i) is GameObject ) {
				 	ui.removeChildAt(i);
				 }
			}
		}
		private function useItem(e:TouchEvent):void {
			observer = ObserverManager.getInstance();
			var touches:Vector.<Touch> = e.getTouches(this,TouchPhase.BEGAN);
			if(touches.length != 0){
				
				_usedItem = e.currentTarget as GameObject;
				weapon = Weapon.getInstance();
				
				if(_usedItem.get("type") == "weapon") {
					weapon.selectWeapon(_usedItem.name); 
				} else { 
					observer.notify(_usedItem);
				}
			} 	
			
		}
				
		public function getUsedItem():GameObject {
			return _usedItem;
		}
		
		public function isEmptyInventory():Boolean {
		    for each(var obj:Object in slots)
		    {
		        if(obj != null)
		        {
		           return false;
		        }
		    }
		    return true;
		 }
		 
		 public function getSlots():Dictionary{
			return slots;
		 }
	}
}
