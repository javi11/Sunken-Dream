package game.Inventory {
	import starling.text.TextField;
	import game.ui.UsedItem;
	import game.Assets;

	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;

	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * @author Javier
	 */
	public class GameObject extends Sprite {
		public static const LOCKED : int = 0;
		public static const UNLOCKED : int = 1;
		
		private static const WIDTH : int = 54;
		private static const HEIGHT : int = 44;
		private  var _objectProperties : Dictionary;
		private var _textureSprite : Image;
		private var _oldX : int;
		private var _oldY : int;
		private var _numObjects : Sprite;
		private var _inventory:Inventory;
		private var _status:int;
		private var _textField : TextField;
		
		public function GameObject(properties : Dictionary) {
			width = WIDTH;
			height = HEIGHT;
			_inventory = Inventory.getInstance();
			addEventListener(TouchEvent.TOUCH, touchHandler);
			useHandCursor = true;
			name = properties['nameObject'];
			buildSlot();
			_objectProperties = properties;
			_textureSprite = new Image(Assets.getAtlas('objects').getTexture(_objectProperties['texture']));
			_textureSprite.x = 5;
			_textureSprite.y = 5;
			_textureSprite.width = WIDTH;
			_textureSprite.height = HEIGHT;
			_textureSprite.name = name;
			
			_oldX = _textureSprite.x;
			_oldY = _textureSprite.y;
			addChild(_textureSprite);
			
			_numObjects = new Sprite();
			makebox(_objectProperties['quantity'], 30, 30);
			_numObjects.touchable = false;
			_numObjects.x = _textureSprite.x + _textureSprite.width - 18;
			_numObjects.y = _textureSprite.y + _textureSprite.height - 18;
			addChild(_numObjects);
			_status = UNLOCKED;
		}
		
		public function setStatus(status:int):void {
			_status = status;
		}
		
		public function getStatus():int {
			return _status;
		}
		
		private function buildSlot() : void {
			var plainColor : int = Color.GRAY;
			var borderColor : int = Color.BLACK;
			var borderThickness : int = 3;
			var slotHeight : int = 70;
			var slotWidth : int = 80;

			// Crear batch
			var slot : QuadBatch = new QuadBatch();

			// Crear un color
			var center : Quad = new Quad(slotWidth, slotHeight, plainColor);

			// Crear bordes
			var left : Quad = new Quad(borderThickness, slotHeight, borderColor);
			var right : Quad = new Quad(borderThickness, slotHeight, borderColor);

			var top : Quad = new Quad(slotWidth, borderThickness, borderColor);
			var down : Quad = new Quad(slotWidth, borderThickness, borderColor);

			// placing elements (top and left already placed)
			right.x = slotWidth - borderThickness;
			down.y = slotHeight - borderThickness;

			// build box
			slot.addQuad(center);
			slot.addQuad(left);
			slot.addQuad(top);
			slot.addQuad(right);
			slot.addQuad(down);
			slot.touchable = false;
			addChild(slot);
		}

		public function set(key : String, value : *) : void {
			_objectProperties[key] = value;
		}

		public function get(key : String) : * {
			return _objectProperties[key];
		}

		private function touchHandler(e : TouchEvent) : void {
			var touch : Touch = e.getTouch(this, TouchPhase.MOVED);
			var touchEnd: Touch = e.getTouch(this, TouchPhase.ENDED);
			var target : Quad = e.target as Quad;
			if (touch) {
				parent.setChildIndex(this,numChildren+1);
				var position : Point = touch.getLocation(this);
				target.x = position.x - 30;
				target.y = position.y - 30;
				_numObjects.visible = false;
			} else if(touchEnd) {
				var m_TouchEndedPoint: Point = new Point(touchEnd.globalX, touchEnd.globalY);
				parent.setChildIndex(this,numChildren-1);
				var item:Image = stage.hitTest(m_TouchEndedPoint, true) as Image;
				if(item.name) {
					if(item.name == _objectProperties['union']) {
						var usedItem:UsedItem = UsedItem.getInstance();
						usedItem.remove();
						_inventory.status(_objectProperties['resultObject'], UNLOCKED);
						_inventory.remove(_inventory.get(item.name));
						_inventory.remove(_inventory.get(this.name));
						_inventory.makeInventoryItems("key");
					}
				}
				target.x = _oldX;
				target.y = _oldY;
				_numObjects.visible = true;
			}else {
				target.x = _oldX;
				target.y = _oldY;
				_numObjects.visible = true;
			}
		}
		
		public function updateObject() : void {
			_numObjects.removeChild(_textField);
			_textField.text = _objectProperties['quantity'];
			_numObjects.addChild(_textField);
		}
		
		private function makebox(text : String, width : int, height : int, plainColor : int = 0xFFFFFF, borderColor : int = 0x000000, borderThickness : int = 1, fontSize : int = 18, fontColor : uint = Color.BLACK):void {
			
			// Crear batch
			var msgbox : QuadBatch = new QuadBatch();

			// Crear un color
			var center : Quad = new Quad(width, height, plainColor);

			// Crear bordes
			var left : Quad = new Quad(borderThickness, height, borderColor);
			var right : Quad = new Quad(borderThickness, height, borderColor);

			var top : Quad = new Quad(width, borderThickness, borderColor);
			var down : Quad = new Quad(width, borderThickness, borderColor);

			// placing elements (top and left already placed)
			right.x = width - borderThickness;
			down.y = height - borderThickness;

			// build box
			msgbox.addQuad(center);
			msgbox.addQuad(left);
			msgbox.addQuad(top);
			msgbox.addQuad(right);
			msgbox.addQuad(down);
			_textField = new TextField(width, height, text, "Arial", fontSize, fontColor);

			_numObjects.addChild(msgbox);
			_numObjects.addChild(_textField);
		}

		override public function addChild(child : DisplayObject) : DisplayObject {
			return super.addChild(child);
		}
	}
}
