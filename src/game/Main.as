package game {
	
	import game.levels.ALevels;
	import game.levels.ALevelManager;
	
	import citrus.core.CitrusEngine;
	import citrus.utils.LevelManager;
	import citrus.core.IState;
	import citrus.core.starling.StarlingCitrusEngine;
	import flash.system.Security;
	
	[SWF(frameRate="50")]
	/**
	 * @author Aymeric
	 */
	public class Main extends StarlingCitrusEngine {
		
		
		public function Main() {
			super();
			setUpStarling(true);
			
			gameData = new ALevelManager();
			
			levelManager = new LevelManager(ALevels);
			levelManager.onLevelChanged.add(_onLevelChanged);
			levelManager.levels = gameData.levels;
			levelManager.gotoLevel();
		}
		
		private function _onLevelChanged(lvl:ALevels):void {
			
			state = lvl;
			
			//lvl.lvlEnded.add(_nextLevel);
			//lvl.restartLevel.add(_restartLevel);
		}
		
		private function _restartLevel():void {
			state = levelManager.currentLevel as IState;
		}
		
		private function _nextLevel():void {
			
			levelManager.nextLevel();
		}
	}
}