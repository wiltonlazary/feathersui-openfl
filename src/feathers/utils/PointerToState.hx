/*
	Feathers
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.utils;

import feathers.controls.ButtonState;
import feathers.core.IStateContext;
import openfl.display.InteractiveObject;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
	Changes a target's state based on pointer events (`MouseEvent` and
	`TouchEvent`), like a button.

	@see `feathers.controls.Button`
	@see `feathers.utils.KeyToState`

	@since 1.0.0
**/
class PointerToState {
	public function new(target:InteractiveObject = null, callback:String->Void = null) {
		this.target = target;
		this.callback = callback;
	}

	/**
		The target component that should change state based on pointer (mouse or
		touch) events.

		@since 1.0.0
	**/
	public var target(default, set):InteractiveObject = null;

	private function set_target(value:InteractiveObject):InteractiveObject {
		if (this.target == value) {
			return this.target;
		}
		if (this.target != null) {
			this.target.removeEventListener(Event.REMOVED_FROM_STAGE, target_removedFromStageHandler);
			this.target.removeEventListener(MouseEvent.ROLL_OVER, target_rollOverHandler);
			this.target.removeEventListener(MouseEvent.MOUSE_DOWN, target_mouseDownHandler);
		}
		this.target = value;
		if (this.target != null) {
			this.currentState = this.upState;
			this.target.addEventListener(Event.REMOVED_FROM_STAGE, target_removedFromStageHandler);
			this.target.addEventListener(MouseEvent.ROLL_OVER, target_rollOverHandler);
			this.target.addEventListener(MouseEvent.MOUSE_DOWN, target_mouseDownHandler);
		}
		return this.target;
	}

	/**
		The function to call when the state is changed.

		The callback is expected to have the following signature:

		```hx
		String -> Void
		```

		@since 1.0.0
	**/
	public var callback(default, set):String->Void = null;

	private function set_callback(value:String->Void):String->Void {
		if (this.callback == value) {
			return this.callback;
		}
		this.callback = value;
		if (this.callback != null) {
			this.callback(this.currentState);
		}
		return callback;
	}

	/**
		The current state of the utility. May be different than the state of the
		target.

		@default feathers.controls.ButtonState.UP

		@since 1.0.0
	**/
	public var currentState(default, null):String = ButtonState.UP;

	/**
		The value for the "up" state.

		@default feathers.controls.ButtonState.UP
	**/
	public var upState(default, default):String = ButtonState.UP;

	/**
		The value for the "down" state.

		@since 1.0.0
	**/
	public var downState(default, default):String = ButtonState.DOWN;

	/**
		The value for the "hover" state.

		@default feathers.controls.ButtonState.HOVER

		@since 1.0.0
	**/
	public var hoverState(default, default):String = ButtonState.HOVER;

	/**
		May be set to `false` to disable the state changes temporarily until set
		back to `true`.

		@default true

		@since 1.0.0
	**/
	public var enabled(default, default):Bool = true;

	/**
		If `true`, the current state will remain as `downState` until
		`MouseEvent.MOUSE_UP` is dispatched. If `false`, and the pointer leaves
		the bounds of the target after `MouseEvent.MOUSE_DOWN`, the current
		state will change to `upState`.

		@default false

		@since 1.0.0
	**/
	public var keepDownStateOnRollOut(default, default):Bool = false;

	private var _hoverBeforeDown:Bool = false;
	private var _down:Bool = false;

	private function changeState(value:String):Void {
		var oldState = this.currentState;
		if (Std.is(this.target, IStateContext)) {
			oldState = cast(this.target, IStateContext).currentState;
		}
		this.currentState = value;
		if (oldState == value) {
			return;
		}
		if (this.callback != null) {
			this.callback(value);
		}
	}

	private function resetTouchState():Void {
		this._hoverBeforeDown = false;
		this.changeState(this.upState);
	}

	private function target_removedFromStageHandler(event:Event):Void {
		this.target.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		this.resetTouchState();
	}

	private function target_rollOverHandler(event:MouseEvent):Void {
		if (!this.enabled) {
			return;
		}
		this._hoverBeforeDown = true;
		this.target.addEventListener(MouseEvent.ROLL_OUT, target_rollOutHandler);
		if (this._down) {
			this.changeState(this.downState);
		} else {
			this.changeState(this.hoverState);
		}
	}

	private function target_rollOutHandler(event:MouseEvent):Void {
		if (!this.enabled) {
			return;
		}
		this._hoverBeforeDown = false;
		this.target.removeEventListener(MouseEvent.ROLL_OUT, target_rollOutHandler);
		if (this.keepDownStateOnRollOut && this.currentState == this.downState) {
			return;
		}
		this.changeState(this.upState);
	}

	private function target_mouseDownHandler(event:MouseEvent):Void {
		if (!this.enabled) {
			return;
		}
		this._down = true;
		this.target.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
		this.changeState(this.downState);
	}

	private function stage_mouseUpHandler(event:MouseEvent):Void {
		this._down = false;
		this.target.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		if (this._hoverBeforeDown && this.target.hitTestPoint(event.stageX, event.stageY)) {
			this.changeState(this.hoverState);
		} else {
			this.resetTouchState();
		}
	}
}