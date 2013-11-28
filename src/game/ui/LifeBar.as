package game.ui {
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * @author Javier
	 */
	import starling.textures.TextureAtlas;
	
	public class LifeBar extends Sprite {
		private var _maxHP:int = 100;
		private var _currentHP:int = _maxHP;
		private var _percentHP:Number = _currentHP / _maxHP;
		private var _lifeBar:Image;
		private var _life:Image;
		
		public function LifeBar(Texture:TextureAtlas):void {
			trace(Texture);
			_lifeBar = new Image(Texture.getTexture("barraVida"));
			_life    = new Image(Texture.getTexture("vida"));
			addChild(_lifeBar);
			addChild(_life);
		}
		
		public function getDamage(damage:int):void {
			_currentHP -= damage;
			updateLifeBar();
		}
		
		private function updateLifeBar():void
		{
		     _percentHP = _currentHP / _maxHP;
		     _life.scaleX = _percentHP;
		}
		
	}
}
