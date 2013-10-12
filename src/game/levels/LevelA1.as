package game.levels {

	import flash.display.MovieClip;
	
	/**
	 * @author Aymeric
	 */
	public class LevelA1 extends ALevels {
		
		public function LevelA1(levelObjectsMC:MovieClip) {
			super(levelObjectsMC);
		}
		
		override public function initialize():void {
			
			super.initialize();
			
			//_addContactRestartLevel();
			//_addMusicalSensor();
		}
	}
}