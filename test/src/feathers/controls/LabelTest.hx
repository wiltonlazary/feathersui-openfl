/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls;

import utest.Assert;
import utest.Test;
import openfl.display.Shape;

@:keep
class LabelTest extends Test {
	private var _label:Label;

	public function new() {
		super();
	}

	public function setup():Void {
		this._label = new Label();
		TestMain.openfl_root.addChild(this._label);
	}

	public function teardown():Void {
		if (this._label.parent != null) {
			this._label.parent.removeChild(this._label);
		}
		this._label = null;
		Assert.equals(0, TestMain.openfl_root.numChildren, "Test cleanup failed to remove all children from the root");
	}

	public function testRemoveSkinAfterSetToNewValue():Void {
		var skin1 = new Shape();
		var skin2 = new Shape();
		Assert.isNull(skin1.parent);
		Assert.isNull(skin2.parent);
		this._label.backgroundSkin = skin1;
		this._label.validateNow();
		Assert.equals(this._label, skin1.parent);
		Assert.isNull(skin2.parent);
		this._label.backgroundSkin = skin2;
		this._label.validateNow();
		Assert.isNull(skin1.parent);
		Assert.equals(this._label, skin2.parent);
	}

	public function testRemoveSkinAfterSetToNull():Void {
		var skin = new Shape();
		Assert.isNull(skin.parent);
		this._label.backgroundSkin = skin;
		this._label.validateNow();
		Assert.equals(this._label, skin.parent);
		this._label.backgroundSkin = null;
		this._label.validateNow();
		Assert.isNull(skin.parent);
	}

	public function testRemoveSkinAfterDisable():Void {
		var skin1 = new Shape();
		var skin2 = new Shape();
		Assert.isNull(skin1.parent);
		Assert.isNull(skin2.parent);
		this._label.backgroundSkin = skin1;
		this._label.disabledBackgroundSkin = skin2;
		this._label.validateNow();
		Assert.equals(this._label, skin1.parent);
		Assert.isNull(skin2.parent);
		this._label.enabled = false;
		this._label.validateNow();
		Assert.isNull(skin1.parent);
		Assert.equals(this._label, skin2.parent);
	}
}
