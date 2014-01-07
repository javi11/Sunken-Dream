package game {
	import starling.display.Sprite;
	/**
	 * @author Javier
	 */
	public class LevelEvents extends Sprite {
		private var _key : String;

		public function LevelEvents() : void {
		}

		public function isTheKey(key : String) : Boolean {
			if (key == _key) {
				return true;
			} else {
				return false;
			}
		}
	}
}
