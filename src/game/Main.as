package game {
	import citrus.core.starling.StarlingCitrusEngine;
	import citrus.utils.LevelManager;

	import game.levels.ALevels;

	import flash.events.Event;

	[SWF(frameRate="50" ,width = "900", height = "417" , backgroundColor = "#000066")]
	/**
	 * @author Javier
	 */
	public class Main extends StarlingCitrusEngine {
		public function Main() {
			gameData = new ALevelManager();
		}

		override protected function handleAddedToStage(e : Event) : void {
			super.handleAddedToStage(e);
			setUpStarling(true, 1, null, "baseline");
			starling.simulateMultitouch = true;
		}

		override public function handleStarlingReady() : void {
			levelManager = new LevelManager(ALevels);
			levelManager.onLevelChanged.add(_onLevelChanged);
			levelManager.levels = gameData['levels'];
			levelManager.gotoLevel();
		}

		private function _onLevelChanged(lvl : ALevels) : void {
			state = lvl;

			// lvl.lvlEnded.add(_nextLevel);
			// lvl.restartLevel.add(_restartLevel);
		}
		/*	
		private function _restartLevel():void {
		state = levelManager.currentLevel as IState;
		}
		
		private function _nextLevel():void {
			
		levelManager.nextLevel();
		}
		 */
	}
}