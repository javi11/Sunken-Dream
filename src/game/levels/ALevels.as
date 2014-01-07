package game.levels {
	import citrus.core.starling.StarlingState;
	import citrus.physics.box2d.Box2D;
	import citrus.ui.starling.basic.BasicUI;
	import citrus.ui.starling.basic.BasicUILayout;
	import citrus.utils.objectmakers.ObjectMaker2D;

	import game.Assets;
	import game.IObserver;
	import game.Inventory.GameObject;
	import game.Inventory.Inventory;
	import game.ObserverManager;
	import game.ui.LifeBar;
	import game.ui.UsedItem;

	import starling.display.Button;
	import starling.events.Event;

	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	/**
	 * @author Javier
	 */
	public class ALevels extends StarlingState implements IObserver {
		public var lvlEnded : Signal;
		public var restartLevel : Signal;
		private var _levelObjectsMC : MovieClip;
		private var _inventory : Inventory;
		private var _ui : BasicUI;
		public var _lifeBar : game.ui.LifeBar;
		public var _usedItem : UsedItem;
		private var _inventoryShow : Boolean;
		protected var observer : ObserverManager;

		public function ALevels(levelObjectsMC : MovieClip) : void {
			super();
			_inventory = Inventory.getInstance();
			observer = ObserverManager.getInstance();
			_levelObjectsMC = levelObjectsMC;
			lvlEnded = new Signal();
			restartLevel = new Signal();
			observer.subscribe(this);
		}

		override public function initialize() : void {
			super.initialize();

			var box2d : Box2D = new Box2D("box2D", {visible:true});
			add(box2d);

			view.loadManager.onLoadComplete.addOnce(handleLoadComplete);
			ObjectMaker2D.FromMovieClip(_levelObjectsMC);
			setupUi();

			_ce.onStageResize.add(function() : void {
				_ui.setFrame(0, 0, stage.stageWidth, stage.stageHeight);
			});
		}

		protected function setupUi() : void {
			// Inicializar interfaz de usuario
			BasicUI.defaultContentScale = 0.6;
			_ui = new BasicUI(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			_ui.container.alpha = 0.7;
			_ui.padding = 15;
			// Añadimos Elementos
			_lifeBar = new LifeBar(Assets.getAtlas('ui'));
			_ui.add(_lifeBar, BasicUILayout.TOP_LEFT);
			var inventoryButton : Button;
			inventoryButton = new Button(Assets.getAtlas('ui').getTexture("mochila"));
			inventoryButton.useHandCursor = true;
			inventoryButton.addEventListener(Event.TRIGGERED, handleOpenInventory);
			_ui.add(inventoryButton, BasicUILayout.TOP_CENTER);
			_usedItem = UsedItem.getInstance();
			_usedItem.addTexture((Assets.getAtlas('ui')));
			_ui.add(_usedItem, BasicUILayout.TOP_CENTER);
		}

		private function handleOpenInventory() : void {
			if (!_inventoryShow) {
				_ce.playing = false;
				_inventory.showInventory(Assets.getAtlas('ui'));
				_ui.add(_inventory, BasicUILayout.MIDDLE_CENTER);
				_ui.container.alpha = 1;
				_inventoryShow = true;
			} else {
				_ce.playing = true;
				_inventory.hideInventory();
				_ui.container.alpha = 0.7;
				_inventoryShow = false;
			}
		}

		override public function destroy() : void {
			super.destroy();
			_ui.destroy();
		}

		override public function update(timeDelta : Number) : void {
			super.update(timeDelta);
		}

		public function updateObserver(_notification : Object) : void {
			if (_notification is GameObject) {
				_usedItem.set(Assets.getAtlas('objects'), _notification);
			}
		}

		private function handleLoadComplete() : void {
			
			// remove loader
		}
	}
}