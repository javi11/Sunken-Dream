package game
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import citrus.core.starling.StarlingState;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.MovingPlatform;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import starling.display.Quad;
	import org.osflash.signals.Signal;
	import flash.display.MovieClip;
	import citrus.utils.objectmakers.ObjectMaker2D;
	
	public class MyGameData extends StarlingState {
		public var lvlEnded:Signal;
		public var restartLevel:Signal;
		protected var _level:MovieClip;
		
		public function MyGameData(level:MovieClip = null) {
			super();
			_level = level;
			lvlEnded = new Signal();
			restartLevel = new Signal();
			// Useful for not forgetting to import object from the Level Editor
			var objectsUsed:Array = [Hero, Platform, Enemy, Sensor, CitrusSprite];
		}
		
		override public function initialize():void {
			super.initialize();
			var box2d:Box2D = new Box2D("Box2D");
			add(box2d);
			// create objects from our level made with Flash Pro
			ObjectMaker2D.FromMovieClip(_level);
		}
	}
}