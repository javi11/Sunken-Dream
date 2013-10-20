package game.levels {
	
	import Box2D.Dynamics.b2ContactManager;
	
	import citrus.core.CitrusEngine;
	import citrus.core.CitrusObject;
	import citrus.core.State;
	import citrus.core.starling.StarlingState;
	import citrus.math.MathVector;
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingArt;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.Player;
	
	import org.osflash.signals.Signal;
	
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * @author Aymeric
	 */
	public class ALevels extends StarlingState {
		
		public var lvlEnded:Signal;
		public var restartLevel:Signal;
		
		protected var _hero:Player;
		
		[Embed(source="../embed/PlayerSprite.xml", mimeType="application/octet-stream")]
		private var _heroConfig:Class;
		
		[Embed(source="../embed/PlayerSprite.png")]
		private var _heroPng:Class;
		
		private var _levelObjectsMC:MovieClip;
		
		public function ALevels(levelObjectsMC:MovieClip):void {
			
			super();
			
			_ce = CitrusEngine.getInstance();
			
			_levelObjectsMC = levelObjectsMC;
			
			lvlEnded = new Signal();
			restartLevel = new Signal();
			
			var objects:Array = [Platform, CitrusSprite, Sensor];
		}
		
		override public function initialize():void {
			
			super.initialize();
			
			var box2d:Box2D = new Box2D("box2D", {visible:true});
			add(box2d);
			
			view.loadManager.onLoadComplete.addOnce(handleLoadComplete);
			
			ObjectMaker2D.FromMovieClip(_levelObjectsMC);
			
			var bitmap:Bitmap = new _heroPng();
			var texture:Texture = Texture.fromBitmap(bitmap);
			var xml:XML = XML(new _heroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var animation:AnimationSequence =  new AnimationSequence(sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			
			_hero = new Player("Player",{ x:40, y:10, width:56, height:136, view: animation });
			add(_hero);
			
			StarlingArt.setLoopAnimations(["idle"]); 
			//_declik.onJump.add(_jump);
			//_declik.onAnimationChange.add(_animationChange);
			
			//var endLevel:Sensor = Sensor(getObjectByName("EndLevel"));
			//endLevel.onBeginContact.add(_endLevel);
			
			
			
			view.camera.setUp(_hero, new Point(320, 240), new Rectangle(-1000, 0, 4000, 650), new Point(.25, .05));
		}
		/*
		protected function _addContactRestartLevel():void {
			
			var restartLevel:Sensor = Sensor(getObjectByName("RestartLevel"));
			restartLevel.onBeginContact.add(_restartLevel);
		}
		
		
		protected function _endLevel(cEvt:b2ContactResult):void {
			
			if (cEvt. .other.GetBody().GetUserData() is Hero) {
				lvlEnded.dispatch();
			}
		}
		
		protected function _restartLevel(cEvt:b2Contact):void {
			
			if (cEvt.other.GetBody().GetUserData() is Hero) {
				restartLevel.dispatch();
			}
		}*/
		
		/*protected function _hurt():void {
			_ce.sound.playSound("Hurt", 1, 0);
		}
		
		private function _jump():void {
			_ce.sound.playSound("Jump", 1, 0);
		}
		
		private function _animationChange():void {
			
			if (_hero.animation == "walk") {
				_ce.sound.stopSound("Skid");
				_ce.sound.playSound("Walk", 1);
				return;
			} else {
				_ce.sound.stopSound("Walk");
			}
			
			if (_hero.animation == "skid") {
				_ce.sound.playSound("Skid", 1, 0);
				return;
			} else {
				_ce.sound.stopSound("Skid");
			}
		}*/
		
		override public function destroy():void {
			super.destroy();
		}
		
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
			
			// _percent = Math.round(view.loadManager.bytesLoaded / view.loadManager.bytesTotal * 100).toString();
		}
		
		private function handleLoadComplete():void {
			
			// remove loader
		}
	}
}