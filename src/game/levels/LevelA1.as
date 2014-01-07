package game.levels {
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingArt;

	import game.Assets;
	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import game.Player;

	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	/**
	 * @author Javier
	 */
	public class LevelA1 extends ALevels {
		public static const LOCKED : int = 0;
		public static const UNLOCKED : int = 1;
		public var _status : int;
		private var _inventory : Inventory;
		protected var _hero : Player;

		public function LevelA1(levelObjectsMC : MovieClip) : void {
			super(levelObjectsMC);
		}

		override public function initialize() : void {
			super.initialize();
			_inventory = Inventory.getInstance();
			loadLvXml();
			loadCaractersTextures();
			if (getStatus() != UNLOCKED) {
				setStatus(LOCKED);
			}
			// Configurar Cámara
			camera.target = _hero;
			camera.allowZoom = true;
			camera.allowRotation = true;
			camera.enabled = true;
			camera.reset();
		}

		private function loadLvXml() : void {
			var levelXmL : XML = Assets.getConfig("levelA1Xml");
			var i : int = 0;
			// Items
			for each (var item : XML in levelXmL['items']['*']) {
				var gameObject:GameObject = null;
				if (item.@position == "levelobject") {
					var object : LevelObjects = new LevelObjects(item['nameObject'] + "_" + i, {x:item['x'], y:item['y'], width:30, height:30, properties:item.children()});
					add(object);
				} else if (item.@position == "gameobject") {
					gameObject = new GameObject(xmlToDictionary(item));
					_inventory.add(gameObject);
				} else if (item.@position == "hidenobject") {
					gameObject = new GameObject(xmlToDictionary(item));
					_inventory.add(gameObject);
					_inventory.status(gameObject.get("nameObject"),LOCKED);
				}
				i++;
			}
		}
		
		private function xmlToDictionary(item:XML):Dictionary {
			var tempProperties : Dictionary = new Dictionary();
			for each (var property : XML in item.children()) {
				tempProperties[property.name()] = property;
			}
			return tempProperties;
		}
		private function loadCaractersTextures() : void {
			// Héroe
			var animation : AnimationSequence = new AnimationSequence(Assets.getAtlas('hero'), ["walk", "duck", "idle", "jump", "hurt", "talk"], "idle");
			_hero = new Player("Player", {x:40, y:10, width:56, height:136, view:animation});
			add(_hero);
			StarlingArt.setLoopAnimations(["idle","talk"]);
		}

		public function setStatus(status : int) : void {
			_status = status;
		}

		public function getStatus() : int {
			return _status;
		}

		override public function update(timeDelta : Number) : void {
			super.update(timeDelta);
			// trace("/ heroX="+_hero.x+"/ heroY="+ _hero.y);
		}
	}
}