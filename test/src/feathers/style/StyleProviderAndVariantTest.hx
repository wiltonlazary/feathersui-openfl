/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.style;

import openfl.events.EventDispatcher;
import openfl.events.Event;
import feathers.controls.LayoutGroup;
import feathers.events.StyleProviderEvent;
import utest.Assert;
import utest.Test;

@:keep
class StyleProviderAndVariantTest extends Test {
	private var _control:LayoutGroup;
	private var _styleProvider:TestStyleProvider;

	public function new() {
		super();
	}

	public function setup():Void {
		this._styleProvider = new TestStyleProvider();
		this._control = new LayoutGroup();
	}

	public function teardown():Void {
		if (this._control.parent != null) {
			this._control.parent.removeChild(this._control);
		}
		this._control = null;
		this._styleProvider = null;
		Assert.equals(0, TestMain.openfl_root.numChildren, "Test cleanup failed to remove all children from the root");
	}

	public function testSetStyleProviderBeforeInitialize():Void {
		this._control.styleProvider = this._styleProvider;
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider before initialization");
	}

	public function testSetStyleProviderAndVariantBeforeInitialize():Void {
		this._control.styleProvider = this._styleProvider;
		this._control.variant = "custom-style-name";
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider with new variant before initialization");
	}

	public function testStyleProviderChangeEventBeforeInitialize():Void {
		this._control.styleProvider = this._styleProvider;

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, StyleProviderEvent.STYLES_CHANGE);
		Assert.isFalse(this._styleProvider.appliedStyles,
			"Must not apply style provider before initialization when style provider dispatches StyleProviderEvent.STYLES_CHANGE");
	}

	public function testStyleProviderClearEventBeforeInitialize():Void {
		this._control.styleProvider = this._styleProvider;

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, Event.CLEAR);
		Assert.isNull(this._control.styleProvider, "Must set custom style provider to null when cleared");
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider before initialization when style provider dispatches Event.CLEAR");
	}

	public function testSetStyleProviderBeforeInitializeAndThenValidate():Void {
		this._control.styleProvider = this._styleProvider;

		this._styleProvider.reset();
		this._control.validateNow();
		Assert.isTrue(this._styleProvider.appliedStyles, "Must apply style provider immediately when validated and not on stage");
	}

	public function testSetStyleProviderAfterInitializeOffStage():Void {
		this._control.initializeNow();

		this._styleProvider.reset();
		this._control.styleProvider = this._styleProvider;
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider after initialization when not added to stage");
	}

	public function testSetVariantAfterInitializeOffStage():Void {
		this._control.styleProvider = this._styleProvider;
		this._control.initializeNow();

		this._styleProvider.reset();
		this._control.variant = "custom-style-name";
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider after initialization when not added to stage");
	}

	public function testStyleProviderChangeEventAfterInitializeOffStage():Void {
		this._control.styleProvider = this._styleProvider;
		this._control.initializeNow();

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, StyleProviderEvent.STYLES_CHANGE);
		Assert.isFalse(this._styleProvider.appliedStyles,
			"Must not apply style provider when is off stage and style provider dispatches StyleProviderEvent.STYLES_CHANGE");
	}

	public function testStyleProviderClearEventAfterInitializeOffStage():Void {
		this._control.styleProvider = this._styleProvider;
		this._control.initializeNow();

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, Event.CLEAR);
		Assert.isNull(this._control.styleProvider, "Must set custom style provider to null when cleared");
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider when is off stage and style provider dispatches Event.CLEAR");
	}

	public function testSetStyleProviderAfterInitializeAndAddedToStage():Void {
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();

		this._styleProvider.reset();
		this._control.styleProvider = this._styleProvider;
		Assert.isTrue(this._styleProvider.appliedStyles, "Must apply style provider immediately when already initialized and added to stage");
	}

	public function testSetVariantAfterInitializeAndAddedToStage():Void {
		this._control.styleProvider = this._styleProvider;
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();

		this._styleProvider.reset();
		this._control.variant = "custom-style-name";
		Assert.isTrue(this._styleProvider.appliedStyles, "Must apply style provider with new variant immediately when already initialized and added to stage");
	}

	public function testStyleProviderChangeEventAfterInitializeAndAddedToStage():Void {
		this._control.styleProvider = this._styleProvider;
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, StyleProviderEvent.STYLES_CHANGE);
		Assert.isTrue(this._styleProvider.appliedStyles,
			"Must apply style provider immediately when already initialized and style provider dispatches StyleProviderEvent.STYLES_CHANGE");
	}

	public function testStyleProviderClearEventAfterInitializeAndAddedToStage():Void {
		this._control.styleProvider = this._styleProvider;
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, Event.CLEAR);
		Assert.isNull(this._control.styleProvider, "Must set custom style provider to null when cleared");
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply cleared style provider after it dispatches Event.CLEAR");
	}

	public function testStyleProviderRemovedFromStageAndAddedAgain():Void {
		this._control.styleProvider = this._styleProvider;
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();

		this._styleProvider.reset();
		TestMain.openfl_root.removeChild(this._control);
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider when removed from stage");
		TestMain.openfl_root.addChild(this._control);
		Assert.isTrue(this._styleProvider.appliedStyles, "Must apply style provider when removed from stage and added again");
	}

	public function testSetStyleProviderBetweenRemovedFromStageAndAddedAgain():Void {
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();
		TestMain.openfl_root.removeChild(this._control);

		this._styleProvider.reset();
		this._control.styleProvider = this._styleProvider;
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider when set after initialization and off stage");
		TestMain.openfl_root.addChild(this._control);
		Assert.isTrue(this._styleProvider.appliedStyles, "Must apply style provider when waiting after removal");
	}

	public function testSetStyleVariantBetweenRemovedFromStageAndAddedAgain():Void {
		this._control.styleProvider = this._styleProvider;
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();
		TestMain.openfl_root.removeChild(this._control);

		this._styleProvider.reset();
		this._control.variant = "custom-style-name";
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider when set variant after initialization and off stage");
		TestMain.openfl_root.addChild(this._control);
		Assert.isTrue(this._styleProvider.appliedStyles, "Must apply style provider when waiting after removal");
	}

	public function testStyleProviderChangeEventBetweenRemovedFromStageAndAddedAgain():Void {
		this._control.styleProvider = this._styleProvider;
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();
		TestMain.openfl_root.removeChild(this._control);
		Assert.isTrue(this._styleProvider.appliedStyles);

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, StyleProviderEvent.STYLES_CHANGE);
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider when removed from stage");
		TestMain.openfl_root.addChild(this._control);
		Assert.isTrue(this._styleProvider.appliedStyles, "Must apply style provider when waiting after removal");
	}

	public function testStyleProviderClearEventBetweenRemovedFromStageAndAddedAgain():Void {
		this._control.styleProvider = this._styleProvider;
		TestMain.openfl_root.addChild(this._control);
		this._control.initializeNow();
		TestMain.openfl_root.removeChild(this._control);
		Assert.isTrue(this._styleProvider.appliedStyles);

		this._styleProvider.reset();
		StyleProviderEvent.dispatch(this._styleProvider, Event.CLEAR);
		Assert.isNull(this._control.styleProvider, "Must set custom style provider to null when cleared");
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply style provider when removed from stage");
		TestMain.openfl_root.addChild(this._control);
		Assert.isFalse(this._styleProvider.appliedStyles, "Must not apply cleared style provider when waiting after removal");
	}
}

class TestStyleProvider extends EventDispatcher implements IStyleProvider {
	public var appliedStyles(default, null) = false;

	public function reset():Void {
		this.appliedStyles = false;
	}

	public function applyStyles(target:IStyleObject):Void {
		appliedStyles = true;
	}
}
