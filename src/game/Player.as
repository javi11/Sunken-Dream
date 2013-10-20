package game
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactFilter;
	import Box2D.Dynamics.b2Fixture;
	
	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import citrus.math.MathVector;
	import citrus.objects.APhysicsObject;
	import citrus.objects.Box2DPhysicsObject;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Missile;
	import citrus.physics.PhysicsCollisionCategories;
	import citrus.view.starlingview.AnimationSequence;
	
	import flash.display.MovieClip;
	import flash.media.Video;
	import flash.utils.clearTimeout;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import org.osflash.signals.Signal;
	
	public class Player extends Hero
	{
		private var bulletcounter:int=0;
		
		public function Player(name:String, params:Object = null)
		{
			super(name, params);
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
					
					var bullet:Box2DPhysicsObject;
					var vel:Array = [15,-10];
					if (_inverted) {
						bullet = new Box2DPhysicsObject("bullet"+bulletcounter, { x:this.x -this.width, y:this.y, width:25, height:25} );
					} else {
						bullet = new Box2DPhysicsObject("bullet"+bulletcounter, { x:this.x +this.width, y:this.y, width:25, height:25} );
						
					}
					bulletcounter++
						_ce.state.add(bullet);
						bullet.velocity = vel;
					
				}
			}
			
			updateAnimation();
		}
		
	}
}