package game {
	import dragonBones.events.AnimationEvent;

	import Box2D.Common.Math.b2Vec2;

	import game.ui.MessageBox;
	import game.Inventory.GameObject;

	import Box2D.Dynamics.Contacts.b2Contact;

	import citrus.core.CitrusEngine;
	import citrus.input.controllers.Keyboard;
	import citrus.objects.platformer.box2d.Hero;

	import game.ui.UsedItem;

	public class Player extends Hero {
		private var weapon : Weapon;
		private var _useItem : UsedItem;
		private var _message : MessageBox;
		public var isHanging : Boolean = false;
		public var isSwimming : Boolean = false;
		public var isTalking : Boolean = false;
		public var onSwimmingPlatform : Boolean = false;
		public var markForDamage : Boolean = false;
		public var isDead : Boolean = false;
		public var currentRope : String;
		private var autoAnimation : Boolean = true;
		private var idleCount : int = 0;
		private var idleCountMax : int = 0;

		public function Player(name : String, params : Object = null) {
			super(name, params);
			weapon = Weapon.getInstance();
			var ce : CitrusEngine = CitrusEngine.getInstance();

			var kb : Keyboard = ce.input.keyboard;
			// CTRL
			kb.addKeyAction("Shoot", Keyboard.CTRL);
			// Z
			kb.addKeyAction("UseItem", Keyboard.Z);

			canDuck = true;
			_useItem = UsedItem.getInstance();
		}

		override public function update(timeDelta : Number) : void {
			var velocity : b2Vec2 = _body.GetLinearVelocity();
			if (controlsEnabled) {
				var moveKeyPressed : Boolean = false;

				_ducking = Boolean(_ce.input.isDoing("duck", inputChannel) && canDuck);

				if (!isSwimming && !isHanging) {
					canDuck = true;
					if (_ce.input.isDoing("right", inputChannel) && !_ducking) {
						velocity.Add(getSlopeBasedMoveAngle());
						moveKeyPressed = true;
					} else if (_ce.input.isDoing("left", inputChannel) && !_ducking) {
						velocity.Subtract(getSlopeBasedMoveAngle());
						moveKeyPressed = true;
					}
					if (_ce.input.isDoing("duck", inputChannel) && _ducking) {
						_fixture.SetFriction(0.5);
					
					} else if (_ce.input.hasDone("duck", inputChannel)) {
						_fixture.SetFriction(_friction);
						
					}
					if (_onGround && _ce.input.justDid("jump", inputChannel) && !_ducking) {
						_onGround = false;
						velocity.y = -jumpHeight;
						onJump.dispatch();
					}
					if (_ce.input.isDoing("jump", inputChannel) && !_onGround && velocity.y < 0) {
						velocity.y -= jumpAcceleration;
					}
					if (_ce.input.justDid("Shoot")) {
						weapon.shoot(_inverted, this.x, this.y, [this.width, this.height]);
					}
					if (_ce.input.justDid("UseItem") && !_ce.input.justDid("Shoot")) {
						var item : GameObject = null;
						if (_useItem.useItem()) {
							item = _useItem.getItem();
						}
					}
					if (_playerMovingHero && !_ce.input.justDid("UseItem")) {
						if (_message) {
							_ce.state.remove(_message);
							_message.destroy();
							super.updateAnimation();
							isTalking = false;
						}
					} else if (!_playerMovingHero && _ce.input.justDid("UseItem") && !_ce.input.justDid("Shoot") && _useItem.playerSensor && item != null) {
						this.talk(item.get('wrongPlace'));
					}
				} else if (isSwimming) {
					_onGround = true;
					canDuck = false;

					if (_ce.input.isDoing("right", inputChannel)) {
						this.body.ApplyImpulse(new b2Vec2(0.8, 0), this.body.GetLocalCenter());
						moveKeyPressed = true;
					} else if (_ce.input.isDoing("left", inputChannel)) {
						this.body.ApplyImpulse(new b2Vec2(-0.8, 0), this.body.GetLocalCenter());
						moveKeyPressed = true;
					}
					if (_ce.input.isDoing("down", inputChannel)) {
						this.body.ApplyImpulse(new b2Vec2(0, 0.5), this.body.GetLocalCenter());
						moveKeyPressed = true;
					}

					if (_ce.input.justDid("jump", inputChannel)) {
						if (this.y < -350) {
							_onGround = false;
							velocity.y = -jumpHeight;
						} else this.body.ApplyImpulse(new b2Vec2(0, -4), this.body.GetLocalCenter());
						moveKeyPressed = true;
					}
				} else if (isHanging) {
					/*
					canDuck = false;

					if (_ce.input.isDoing("right", inputChannel)) {
					velocity.Add(new b2Vec2(0.2, 0));
					moveKeyPressed = true;
					} else if (_ce.input.isDoing("left", inputChannel)) {
					velocity.Subtract(new b2Vec2(0.2, 0));
					moveKeyPressed = true;
					}
					if (_ce.input.justDid("jump", inputChannel)) {
					(_ce.state.getObjectByName(currentRope) as Rope).stopClimbing();
					(_ce.state.getObjectByName(currentRope) as Rope).removeJoint();
					sounds.playSound("jump", 0.4, 0);
					}
					if (_ce.input.hasDone("up", inputChannel)) {
					(_ce.state.getObjectByName(currentRope) as Rope).stopClimbing();
					} else if (_ce.input.hasDone("down", inputChannel)) {
					(_ce.state.getObjectByName(currentRope) as Rope).stopClimbing();
					}
					if (_ce.input.justDid("up", inputChannel)) {
					(_ce.state.getObjectByName(currentRope) as Rope).startClimbing(true);
					} else if (_ce.input.justDid("down", inputChannel)) {
					(_ce.state.getObjectByName(currentRope) as Rope).startClimbing(false);
					}
					 * 
					 */
				}

				if (_springOffEnemy != -1) {
					if (_ce.input.isDoing("jump", inputChannel))
						velocity.y = -enemySpringJumpHeight;
					else
						velocity.y = -enemySpringHeight;
					_springOffEnemy = -1;
				}

				if (moveKeyPressed && !_playerMovingHero) {
					_playerMovingHero = true;
					_fixture.SetFriction(0);
				} else if (!moveKeyPressed && _playerMovingHero) {
					_playerMovingHero = false;
					_fixture.SetFriction(_friction);
				}
				// Cap velocities
				if (velocity.x > (maxVelocity))
					velocity.x = maxVelocity;
				else if (velocity.x < (-maxVelocity))
					velocity.x = -maxVelocity;

				if (velocity.y > (10))
					velocity.y = 10;
				else if (velocity.y < (-10))
					velocity.y = -10;
			}
			if (autoAnimation) updateAnimation();
		}

		public function playAnimation() : void {
			this.autoAnimation = false;
		}

		override protected function updateAnimation() : void {
			var prevAnimation : String = _animation;

			var walkingSpeed : Number = getWalkingSpeed();

			if (_hurt)
				_animation = "hurt";
			else if (!_onGround && !_ducking && !isHanging) {
				_animation = "jump";

				if (walkingSpeed < -acceleration)
					_inverted = true;
				else if (walkingSpeed > acceleration)
					_inverted = false;
			} else if (_ducking && !isHanging) {
				_animation = "duck";
			} else if (isHanging) {
				_animation = "hang";
			} else if (isSwimming) {
				if (walkingSpeed < -1) {
					_inverted = true;
					_animation = "swim";
				} else if (walkingSpeed > 1) {
					_inverted = false;
					_animation = "swim";
				} else
					_animation = "swim";
			} else if (isTalking) {
				_animation = "talk";
			} else {
				if (walkingSpeed < -acceleration) {
					_inverted = true;
					_animation = "walk";
				} else if (walkingSpeed > acceleration) {
					_inverted = false;
					_animation = "walk";
				} else {
					if (idleCountMax > 0) {
						idleCount++;
					}
					if (idleCount <= idleCountMax) _animation = "idle";
					else _animation = "idle";
				}
			}

			if (prevAnimation != _animation) {
				if (_animation == "stand") {
					idleCountMax = int(90 + Math.random() * 150);
				} else if (prevAnimation == "standBalance") {
					idleCountMax = 0;
					idleCount = 0;
				}
			}
		}

		override public function handleBeginContact(contact : b2Contact) : void {
			if (_useItem.playerSensor) {
				_useItem.playerSensor = false;
				var item : GameObject = _useItem.getItem();

				if (contact is LevelEvents) {
					var levelKey : LevelEvents = contact as LevelEvents;

					if (levelKey.isTheKey(item.get('action'))) {
					} else {
						this.talk(item.get('wrongPlace'));
					}
				} else {
					this.talk(item.get('wrongPlace'));
				}
			}
			super.handleBeginContact(contact);
		}

		private function talk(text : String) : void {
			if (_message) {
				_ce.state.remove(_message);
				_message.destroy();
			}
			_message = new MessageBox("Talk");
			_message.set(this.x - this.width * 3, this.y - this.height - 5, text);
			_ce.state.add(_message);
			isTalking = true;
		}

		override protected function _createVerticesFromPoint() : void {
			super._createVerticesFromPoint();
		}
	}
}