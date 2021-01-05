/*
	Feathers UI
	Copyright 2020 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.core;

import openfl.geom.Point;
import openfl.errors.ArgumentError;
import openfl.events.Event;
import openfl.display.Sprite;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;

/**
	The default implementation of the `IPopUpManager` interface.

	@see `feathers.core.PopUpManager`

	@since 1.0.0
**/
@:access(feathers.core.FocusManager)
class DefaultPopUpManager implements IPopUpManager {
	private static function defaultOverlayFactory():DisplayObject {
		var overlay = new Sprite();
		overlay.graphics.beginFill(0x808080, 0.75);
		overlay.graphics.drawRect(0, 0, 1, 1);
		overlay.graphics.endFill();
		return overlay;
	}

	/**
		Creates a new `DefaultPopUpManager` object with the given arguments.

		@since 1.0.0
	**/
	public function new(root:DisplayObjectContainer) {
		this.root = root;
	}

	private var _ignoreRemoval = false;

	private var _root:DisplayObjectContainer;

	/**
		@see `feathers.core.IPopUpManager.root`
	**/
	@:flash.property
	public var root(get, set):DisplayObjectContainer;

	private function get_root():DisplayObjectContainer {
		return this._root;
	}

	private function set_root(value:DisplayObjectContainer):DisplayObjectContainer {
		if (this._root == value) {
			return this._root;
		}
		if (value.stage == null) {
			throw new ArgumentError("DefaultPopUpManager root's stage property must not be null.");
		}
		var oldIgnoreRemoval = this._ignoreRemoval;
		this._ignoreRemoval = true;
		for (popUp in this.popUps) {
			this._root.removeChild(popUp);
			var overlay = this._popUpToOverlay.get(popUp);
			if (overlay != null) {
				this._root.removeChild(overlay);
			}
		}
		this._ignoreRemoval = oldIgnoreRemoval;
		this._root = value;
		for (popUp in this.popUps) {
			var overlay = this._popUpToOverlay.get(popUp);
			if (overlay != null) {
				this._root.addChild(overlay);
			}
			this._root.addChild(popUp);
		}
		return this._root;
	}

	private var popUps:Array<DisplayObject> = [];

	private var _centeredPopUps:Array<DisplayObject> = [];

	private var _popUpToOverlay:Map<DisplayObject, DisplayObject> = [];

	private var _popUpToFocusManager:Map<DisplayObject, IFocusManager> = [];

	private var _overlayFactory:() -> DisplayObject;

	/**
		@see `feathers.core.IPopUpManager.overlayFactory`
	**/
	@:flash.property
	public var overlayFactory(get, set):() -> DisplayObject;

	private function get_overlayFactory():() -> DisplayObject {
		return this._overlayFactory;
	}

	private function set_overlayFactory(value:() -> DisplayObject):() -> DisplayObject {
		if (Reflect.compareMethods(this._overlayFactory, value)) {
			return this._overlayFactory;
		}
		this._overlayFactory = value;
		return this._overlayFactory;
	}

	private var _focusManager:IFocusManager;

	/**
		@see `feathers.core.IPopUpManager.focusManager`
	**/
	@:flash.property
	public var focusManager(get, set):IFocusManager;

	private function get_focusManager():IFocusManager {
		return this._focusManager;
	}

	private function set_focusManager(value:IFocusManager):IFocusManager {
		if (this._focusManager == value) {
			return this._focusManager;
		}
		this._focusManager = value;
		return this._focusManager;
	}

	/**
		@see `feathers.core.IPopUpManager.popUpCount`
	**/
	@:flash.property
	public var popUpCount(get, never):Int;

	private function get_popUpCount():Int {
		return this.popUps.length;
	}

	/**
		@see `feathers.core.IPopUpManager.isPopUp`
	**/
	public function isPopUp(target:DisplayObject):Bool {
		return this.popUps.indexOf(target) != -1;
	}

	/**
		@see `feathers.core.IPopUpManager.isTopLevelPopUp`
	**/
	public function isTopLevelPopUp(target:DisplayObject):Bool {
		var i = this.popUps.length - 1;
		while (i >= 0) {
			var otherPopUp = this.popUps[i];
			if (otherPopUp == target) {
				// we haven't encountered an overlay yet, so it is top-level
				return true;
			}
			var overlay = this._popUpToOverlay.get(otherPopUp);
			if (overlay != null) {
				// this is the first overlay, and we haven't found the pop-up
				// yet, so it is not top-level
				return false;
			}
			i--;
		}
		return false;
	}

	/**
		@see `feathers.core.IPopUpManager.isModal`
	**/
	public function isModal(target:DisplayObject):Bool {
		if (target == null) {
			return false;
		}
		return this._popUpToOverlay.get(target) != null;
	}

	/**
		@see `feathers.core.IPopUpManager.addPopUp`
	**/
	public function addPopUp(popUp:DisplayObject, isModal:Bool = true, isCentered:Bool = true, ?customOverlayFactory:() -> DisplayObject):DisplayObject {
		if (isModal) {
			if (customOverlayFactory == null) {
				customOverlayFactory = this._overlayFactory;
			}
			if (customOverlayFactory == null) {
				customOverlayFactory = DefaultPopUpManager.defaultOverlayFactory;
			}
			var overlay = customOverlayFactory();
			overlay.width = this._root.stage.stageWidth;
			overlay.height = this._root.stage.stageHeight;
			this._root.addChild(overlay);
			this._popUpToOverlay.set(popUp, overlay);
		}

		this.popUps.push(popUp);
		var result = this._root.addChild(popUp);

		// this listener needs to be added after the pop-up is added to the
		// root because the pop-up may not have been removed from its old
		// parent yet, which will trigger the listener if it is added first.
		popUp.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
		if (this.popUps.length == 1) {
			this._root.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, 0, true);
		}
		if (isModal && this._focusManager != null) {
			var focusManager = FocusManager.push(this._focusManager, popUp);
			this._popUpToFocusManager.set(popUp, focusManager);
		}
		if (isCentered) {
			if (Std.is(popUp, IMeasureObject)) {
				var measurePopUp = cast(popUp, IMeasureObject);
				measurePopUp.addEventListener(Event.RESIZE, popUp_resizeHandler);
			}
			this._centeredPopUps.push(popUp);
			this.centerPopUp(popUp);
		}
		return result;
	}

	/**
		@see `feathers.core.IPopUpManager.removePopUp`
	**/
	public function removePopUp(popUp:DisplayObject):DisplayObject {
		var index = this.popUps.indexOf(popUp);
		if (index == -1) {
			return popUp;
		}
		return this._root.removeChild(popUp);
	}

	/**
		@see `feathers.core.IPopUpManager.removePopUp`
	**/
	public function removeAllPopUps():Void {
		// removing pop-ups may call event listeners that add new pop-ups,
		// and we don't want to remove the new ones or miss old ones, so
		// create a copy of the popUps array to be safe.
		var popUps = this.popUps.copy();
		for (popUp in popUps) {
			// we check if this is still a pop-up because it might have been
			// removed in an Event.REMOVED or Event.REMOVED_FROM_STAGE
			// listener for another pop-up earlier in the loop
			if (this.isPopUp(popUp)) {
				this.removePopUp(popUp);
			}
		}
	}

	/**
		@see `feathers.core.IPopUpManager.centerPopUp`
	**/
	public function centerPopUp(popUp:DisplayObject):Void {
		var stage = this._root.stage;
		if (Std.is(popUp, IValidating)) {
			cast(popUp, IValidating).validateNow();
		}
		var topLeft = new Point(0, 0);
		topLeft = this._root.globalToLocal(topLeft);
		var bottomRight = new Point(stage.stageWidth, stage.stageHeight);
		bottomRight = this._root.globalToLocal(bottomRight);
		popUp.x = topLeft.x + (bottomRight.x - topLeft.x - popUp.width) / 2.0;
		popUp.y = topLeft.y + (bottomRight.y - topLeft.y - popUp.height) / 2.0;
	}

	private function popUp_removedFromStageHandler(event:Event):Void {
		if (this._ignoreRemoval) {
			return;
		}
		var popUp = cast(event.currentTarget, DisplayObject);
		popUp.removeEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
		this.popUps.remove(popUp);
		var overlay = this._popUpToOverlay.get(popUp);
		if (overlay != null) {
			this._root.removeChild(overlay);
			this._popUpToOverlay.remove(popUp);
		}
		var focusManager = this._popUpToFocusManager.get(popUp);
		if (focusManager != null) {
			this._popUpToFocusManager.remove(popUp);
			FocusManager.remove(this._focusManager, focusManager);
		}

		if (this.popUps.length == 0) {
			this._root.stage.removeEventListener(Event.RESIZE, stage_resizeHandler);
		}
	}

	private function popUp_resizeHandler(event:Event):Void {
		var popUp = cast(event.currentTarget, DisplayObject);
		this.centerPopUp(popUp);
	}

	private function stage_resizeHandler(event:Event):Void {
		var stage = this._root.stage;
		var stageWidth = stage.stageWidth;
		var stageHeight = stage.stageHeight;
		for (popUp in popUps) {
			var overlay = this._popUpToOverlay.get(popUp);
			if (overlay != null) {
				overlay.width = stageWidth;
				overlay.height = stageHeight;
			}
		}
		for (popUp in this._centeredPopUps) {
			this.centerPopUp(popUp);
		}
	}
}
