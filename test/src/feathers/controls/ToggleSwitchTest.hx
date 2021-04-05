/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls;

import openfl.events.MouseEvent;
import openfl.events.Event;
import feathers.controls.ToggleSwitch;
import utest.Assert;
import utest.Test;

@:keep
class ToggleSwitchTest extends Test {
	private var _toggle:ToggleSwitch;

	public function new() {
		super();
	}

	public function setup():Void {
		this._toggle = new ToggleSwitch();
		TestMain.openfl_root.addChild(this._toggle);
	}

	public function teardown():Void {
		if (this._toggle.parent != null) {
			this._toggle.parent.removeChild(this._toggle);
		}
		this._toggle = null;
		Assert.equals(0, TestMain.openfl_root.numChildren, "Test cleanup failed to remove all children from the root");
	}

	public function testProgrammaticSelectionChange():Void {
		this._toggle.selected = false;
		var changed = false;
		this._toggle.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		this._toggle.selected = true;
		Assert.isTrue(changed, "Event.CHANGE must be dispatched when changing selected property");
	}

	public function testInteractiveSelectionChangeOnClick():Void {
		this._toggle.selected = false;
		var changed = false;
		this._toggle.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		this._toggle.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		Assert.isTrue(this._toggle.selected, "selected property must change on click");
		Assert.isTrue(changed, "Event.CHANGE must be dispatched on click");
	}

	public function testNoInteractiveSelectionChangeOnClickWhenDisabled():Void {
		this._toggle.selected = false;
		this._toggle.enabled = false;
		var changed = false;
		this._toggle.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		this._toggle.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		Assert.isFalse(this._toggle.selected, "selected property must not change on click when disabled");
		Assert.isFalse(changed, "Event.CHANGE must not be dispatched on click when disabled");
	}

	public function testInteractiveSelectionChangeOnDrag():Void {
		this._toggle.selected = false;
		var changed = false;
		this._toggle.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		this._toggle.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		this._toggle.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, true, true, 1000));
		Assert.isTrue(this._toggle.selected, "selected property must change on click");
		Assert.isTrue(changed, "Event.CHANGE must be dispatched on click");
	}
}
