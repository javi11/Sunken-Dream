package game.levels {
	
	import game.ui.LifeBar;
	import flash.utils.Dictionary;
	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.ui.starling.basic.BasicUI;
	import citrus.ui.starling.basic.BasicUILayout;
	
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.geom.Rectangle;
	
	import starling.textures.Texture;
	
	import starling.textures.TextureAtlas;
	import org.osflash.signals.Signal;

	/**
	 * @author Javier
	 */
	public class ALevels extends StarlingState {
		
		public var lvlEnded:Signal;
		public var restartLevel:Signal;
		
		private var _levelObjectsMC:MovieClip;
		private var inventory:Inventory;
		private var _ui:BasicUI;
	 	public var _lifeBar:game.ui.LifeBar;

		public function ALevels(levelObjectsMC:MovieClip):void {
			super();
			inventory = Inventory.getInstance();
			addDefaultWeapon();
			
			_levelObjectsMC = levelObjectsMC;
			lvlEnded = new Signal();
			restartLevel = new Signal();
		}
		
		override public function initialize():void {
			
			super.initialize();
			
			var box2d:Box2D = new Box2D("box2D", {visible:true});
			add(box2d);
			
			view.loadManager.onLoadComplete.addOnce(handleLoadComplete);
			ObjectMaker2D.FromMovieClip(_levelObjectsMC);
			setupUi();
                        
            _ce.onStageResize.add(function(width:Number, height:Number):void
            {
              _ui.setFrame(0, 0, stage.stageWidth, stage.stageHeight);
            });
		}
		
		private function addDefaultWeapon():void {
			var defaulWeaponProperty:Dictionary = new Dictionary();
			defaulWeaponProperty['name'] = "CocoCannon";
			defaulWeaponProperty['quantity'] = 5;
			defaulWeaponProperty['type'] = "Weapon";
			defaulWeaponProperty['damage'] = 10;
			defaulWeaponProperty['velX'] = 10;
			defaulWeaponProperty['velY'] = 10;
			
			var gameObject:GameObject = new GameObject(defaulWeaponProperty);
			inventory.add(gameObject);
		}
		
		protected function setupUi():void
        {
            var bitArray:ByteArray = new _uiAtf();
			var texture:Texture = Texture.fromAtfData(bitArray,1,false);
			var xml:XML = XML(new _uiConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			BasicUI.defaultContentScale = 0.6;
            _ui = new BasicUI(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
	        _lifeBar = new LifeBar(sTextureAtlas);
			_ui.add(_lifeBar, BasicUILayout.TOP_LEFT);
            _ui.container.alpha = 0.7;
            _ui.padding = 15;
        }
		
		override public function destroy():void {
			super.destroy();
			_ui.destroy();
		}
		
		override public function update(timeDelta:Number):void {
			
			super.update(timeDelta);
		}
		
		private function handleLoadComplete():void {
			
			// remove loader
		}
		
		//TEXTURAS
		
		[Embed(source="/../embed/ui/ui.xml", mimeType="application/octet-stream")]
		private var _uiConfig:Class;
		
		[Embed(source="/../embed/ui/ui.atf",mimeType="application/octet-stream" )]
		private var _uiAtf:Class;

	}
}