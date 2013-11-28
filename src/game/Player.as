package game
{
	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Hero;

	
	public class Player extends Hero
	{
		private var weapon:Weapon;
		public function Player(name:String, params:Object = null)
		{
			super(name, params);
			weapon = new Weapon();
			var ce:CitrusEngine = CitrusEngine.getInstance();
			var kb:Keyboard = ce.input.keyboard;
			//CTRL
			kb.addKeyAction("Shoot", Keyboard.CTRL);
			
			canDuck = true;
		}

		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			
			//Nuevos Controles
			if (controlsEnabled)
			{
				if (_ce.input.justDid("Shoot"))
				{
					weapon.shoot(_inverted,this.x,this.y, [this.width,this.height]);	
				}
			}
			
			super.updateAnimation();
		}
		
	}
}