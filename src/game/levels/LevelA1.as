package game.levels {
	
	import game.Player;
	
	import citrus.view.starlingview.AnimationSequence;
	import citrus.view.starlingview.StarlingArt;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * @author Javier
	 */
	public class LevelA1 extends ALevels {
		public static const LOCKED:int=0;
		public static const UNLOCKED:int=1;
		public var _status:int;
		
		public function LevelA1(levelObjectsMC:MovieClip):void {
			super(levelObjectsMC);
		}
		
		override public function initialize():void {
			super.initialize();
			loadCaractersTextures();
			addObjects();
			if(getStatus() != UNLOCKED) {
				setStatus(LOCKED);
			}
			//Configurar Cámara
			camera.target = _hero;
            camera.allowZoom = true;
            camera.allowRotation = true;
            camera.enabled = true;
            camera.reset();
		}
		
		private function addObjects():void {
			var xml:XML = XML(new _objects());
			/*Definir propiedades de los objetos necesarios*/
			
				//heal
			var vida50Properties:XMLList =  xml.items.vida50.children();
			
			/*Definir los objetos en el mapa*/
			
				//Definir Objetos
			var vida50:LevelObjects = new LevelObjects("heal1",{x:140,y: 80, width: 30, height:30, properties:vida50Properties});
			add(vida50);	

		}
		
		private function loadCaractersTextures():void {
			//Héroe
			var bitArray:ByteArray = new _heroAtf();
			var texture:Texture = Texture.fromAtfData(bitArray,1,false);
			var xml:XML = XML(new _heroConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var animation:AnimationSequence =  new AnimationSequence(sTextureAtlas, ["walk", "duck", "idle", "jump", "hurt"], "idle");
			_hero = new Player("Player",{ x:40, y:10, width:56, height:136, view: animation });
			add(_hero);
			StarlingArt.setLoopAnimations(["idle"]); 
			
		}
		
		public function setStatus(status:int):void {
			_status = status;
		}
		
		public function getStatus():int {
			return _status;
		}
		
		//TEXTURAS
		protected var _hero:Player;
		
		[Embed(source="/../embed/caracters/PlayerSprite.xml", mimeType="application/octet-stream")]
		private var _heroConfig:Class;
		
		[Embed(source="/../embed/caracters/PlayerSprite.atf",mimeType="application/octet-stream" )]
		private var _heroAtf:Class;
	
		
		//Objectos
		
		[Embed(source="/../embed/objects/objects.xml", mimeType="application/octet-stream")]
		private var _objects:Class;
	}
}