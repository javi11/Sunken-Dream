package game
{
	
	import game.levels.ALevels;
	import game.ALevelManager;
	
	import citrus.utils.LevelManager;
	import citrus.core.IState;
	import citrus.core.starling.StarlingCitrusEngine;

	import flash.events.Event;
	[SWF(frameRate="50" ,width = "900", height = "417")]
	/**
	 * @author Javier
	 */
	public class Main extends StarlingCitrusEngine {
		
        public function Main() {
                        
             gameData = new ALevelManager();
		}
                
        override protected function handleAddedToStage(e:Event):void
        {
              super.handleAddedToStage(e);
			  setUpStarling(true, 1, null,"baseline");
        }
                
        override public function handleStarlingReady():void
        {
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