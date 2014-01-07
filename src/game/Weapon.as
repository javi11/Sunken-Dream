package game {
	import citrus.core.CitrusEngine;
	import citrus.objects.Box2DPhysicsObject;

	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import game.weapons.*;

	import flash.utils.getDefinitionByName;

	public class Weapon {
		private var _ce : CitrusEngine;
		private var _defaultWeapon : String = "CocoCannon";
		private var _weapon : GameObject;
		private var _vel : Array;
		private var inventory : Inventory;
		private static var _instance : Weapon;

		public function Weapon() {
			inventory = Inventory.getInstance();
			selectWeapon(_defaultWeapon);
			_ce = CitrusEngine.getInstance();
			var weapons:Array = [CocoCannon];
		}

		public static function getInstance() : Weapon {
			if (!_instance) {
				_instance = new Weapon();
			}
			return _instance;
		}

		public function setBullets(num : int) : void {
			_weapon.set("quantity", num);
			updateInventory();
		}

		public function addBullet() : void {
			_weapon.set("quantity", _weapon.get("quantity") + 1);
			updateInventory();
		}

		public function updateInventory() : void {
			inventory.set(_weapon, _weapon.get("quantity"));
		}

		public function selectWeapon(name : String) : void {
			if (inventory.get(name) == null) {
				_weapon.set("velX", 10);
				_weapon.set("velY", 10);
				_weapon.name = "CocoCannon";
			} else {
				_weapon = inventory.get(name);
			}
		}

		public function shoot(position : Boolean, posX : int, posY : int, player : Array) : void {
			var playerHeight : int = player[1];
			var playerWidth : int = player[0];

			if (_weapon.get("quantity") != 0) {
				if (position) {
					playerWidth = -playerWidth;
					_vel = [-_weapon.get("velX"), -_weapon.get("velY")];
				} else {
					_vel = [+_weapon.get("velX"), -_weapon.get("velY")];
				}
				var weaponBullet : Class = getDefinitionByName("game.weapons." + _weapon.name) as Class;
				var bullet : Box2DPhysicsObject;
				bullet = new weaponBullet("bullet" + _weapon.get("quantity"), posX + playerWidth, posY - playerHeight / 2);
				_weapon.set("quantity", _weapon.get("quantity") - 1);
				updateInventory();
				_ce.state.add(bullet);
				bullet.velocity = _vel;
			}
		}
	}
}