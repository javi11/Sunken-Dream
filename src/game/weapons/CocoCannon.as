package game.weapons
{
	import citrus.view.ICitrusArt;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Common.Math.b2Vec2;
	 
	import citrus.objects.Box2DPhysicsObject;
	import citrus.view.starlingview.AnimationSequence;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;		
	import flash.utils.ByteArray;
	
	public class CocoCannon extends Box2DPhysicsObject
	{
		public var animationSequence:AnimationSequence;
		public var dying:Boolean = false;
		public var _bulletWidth:int = 30;
		public var _bulletHeight:int = 30;
		public var _collisionY:int;
		
		public function CocoCannon(name:String, posX:int, posY:int)
		{
			var params:Object =  {x:posX, y:posY, width:_bulletWidth, height:_bulletHeight};
			super(name, params);
			//allow update calls
			updateCallEnabled = true;
			//allow calls to the handleBeginContact function when something hits the object
			beginContactCallEnabled = true;
			
			setView();
		}
		
		private function setView():void {
			var bitArray:ByteArray = new _weaponAtf();
			var texture:Texture = Texture.fromAtfData(bitArray,1,false);
			var xml:XML = XML(new _weaponConfig());
			var sTextureAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			var animation:AnimationSequence =  new AnimationSequence(sTextureAtlas, ["explosion","idle"], "idle");
			view = animation;
		}
		
		override public function handleArtReady(citrusArt:ICitrusArt):void
		{
			
			if (citrusArt["content"] != null && citrusArt["content"] is AnimationSequence)
			{
				animationSequence = citrusArt["content"] as AnimationSequence;
				animationSequence.onAnimationComplete.add(handleAnimationComplete);
			}
		}	
		
		public function handleAnimationComplete(animationName:String):void
		{	
			if (animationName == "explosion")
			{
				kill = true;
			}
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			if (_animation == "explosion")
			{
				y = _collisionY;
			} else {
				this.rotation += 20;
			}
		}
		
		override public function handleBeginContact(contact:b2Contact):void
		{
			super.handleBeginContact(contact);
			_animation = "explosion";
			
			_collisionY = y;
			velocity = [0,0];	
		}
		
		override public function destroy():void {
			//make sure to remove the handleAnimationComplete listener from the onAnimationComplete signal
			if(animationSequence)
				animationSequence.onAnimationComplete.remove(handleAnimationComplete);
			animationSequence = null;
			super.destroy();
		}
		
		//TEXTURA
		[Embed(source="/../embed/weapons/cocoCannonSprite.xml", mimeType="application/octet-stream")]
		private var _weaponConfig:Class;
		
		[Embed(source="/../embed/weapons/cocoCannonSprite.atf",mimeType="application/octet-stream" )]
		private var _weaponAtf:Class;
	}
}