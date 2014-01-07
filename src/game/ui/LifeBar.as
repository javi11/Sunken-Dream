package game.ui {
	import game.GameConstants;
	import game.IObserver;
	import game.Inventory.GameObject;
	import game.ObserverManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;

	/**
	 * @author Javier
	 */
	public class LifeBar extends Sprite  implements IObserver {
		private var _maxHP : Number = 100;
		private var _currentHP : Number = _maxHP;
		private var _percentHP : Number = _currentHP / _maxHP;
		private var _lifeBar : Image;
		private var _life : Image;
		protected var observer : ObserverManager;

		public function LifeBar(Texture : TextureAtlas) : void {
			_lifeBar = new Image(Texture.getTexture("barraVida"));
			_life = new Image(Texture.getTexture("vida"));
			_life.x = 43;
			_life.y = 19;
			_maxHP = GameConstants.HERO_HP;

			addChild(_lifeBar);
			addChild(_life);
			updateLifeBar();
			observer = observer = ObserverManager.getInstance();
			observer.subscribe(this);
		}

		public function handleDamage(damage : int) : void {
			_currentHP -= damage;
			updateLifeBar();
		}

		private function updateLifeBar() : void {
			if (_currentHP > 0) {
				_percentHP = _currentHP / _maxHP;
				_life.scaleX = _percentHP;
			}
		}

		public function updateObserver(_notification : Object) : void {
			if (!(_notification is GameObject)) {
				var HP : Number = _notification['hp'];
				if (_currentHP < _maxHP) {
					_currentHP += HP;
				}
				if (_currentHP > _maxHP) {
					_currentHP = _maxHP;
				}
				updateLifeBar();
			}
		}
	}
}
