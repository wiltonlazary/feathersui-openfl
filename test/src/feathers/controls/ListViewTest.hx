/*
	Feathers UI
	Copyright 2020 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls;

import feathers.events.ScrollEvent;
import openfl.events.Event;
import feathers.data.ArrayCollection;
import massive.munit.Assert;

@:keep
class ListViewTest {
	private var _listView:ListView;

	@Before
	public function prepare():Void {
		this._listView = new ListView();
		TestMain.openfl_root.addChild(this._listView);
	}

	@After
	public function cleanup():Void {
		if (this._listView.parent != null) {
			this._listView.parent.removeChild(this._listView);
		}
		this._listView = null;
		Assert.areEqual(0, TestMain.openfl_root.numChildren, "Test cleanup failed to remove all children from the root");
	}

	@Test
	public function testValidateWithNullDataProvider():Void {
		this._listView.validateNow();
	}

	@Test
	public function testValidateWithFilledDataProviderAndThenNullDataProvider():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		this._listView.validateNow();
		this._listView.dataProvider = null;
		this._listView.validateNow();
	}

	@Test
	public function testDispatchChangeEventAfterSetSelectedIndex():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		this._listView.validateNow();
		var changed = false;
		this._listView.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		Assert.isFalse(changed);
		this._listView.selectedIndex = 1;
		Assert.isTrue(changed);
	}

	@Test
	public function testDispatchChangeEventAfterSetSelectedItem():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		this._listView.validateNow();
		var changed = false;
		this._listView.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		Assert.isFalse(changed);
		this._listView.selectedItem = this._listView.dataProvider.get(1);
		Assert.isTrue(changed);
	}

	@Test
	public function testSelectedItemAfterSetSelectedIndex():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		Assert.isNull(this._listView.selectedItem);
		this._listView.selectedIndex = 1;
		Assert.areEqual(this._listView.dataProvider.get(1), this._listView.selectedItem);
	}

	@Test
	public function testSelectedIndexAfterSetSelectedItem():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		Assert.areEqual(-1, this._listView.selectedIndex);
		this._listView.selectedItem = this._listView.dataProvider.get(1);
		Assert.areEqual(1, this._listView.selectedIndex);
	}

	@Test
	public function testDeselectAllOnNullDataProvider():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		this._listView.selectedIndex = 1;
		var changed = false;
		this._listView.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		Assert.isFalse(changed);
		this._listView.dataProvider = null;
		Assert.isTrue(changed);
		Assert.areEqual(-1, this._listView.selectedIndex);
		Assert.areEqual(null, this._listView.selectedItem);
	}

	@Test
	public function testResetScrollOnNullDataProvider():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		this._listView.scrollX = 10.0;
		this._listView.scrollY = 10.0;
		var scrolled = false;
		this._listView.addEventListener(ScrollEvent.SCROLL, function(event:ScrollEvent):Void {
			scrolled = true;
		});
		Assert.isFalse(scrolled);
		this._listView.dataProvider = null;
		Assert.isTrue(scrolled);
		Assert.areEqual(0.0, this._listView.scrollX);
		Assert.areEqual(0.0, this._listView.scrollY);
	}

	@Test
	public function testDeselectAllOnDataProviderRemoveAll():Void {
		this._listView.dataProvider = new ArrayCollection([{text: "One"}, {text: "Two"}, {text: "Three"}]);
		this._listView.selectedIndex = 1;
		var changed = false;
		this._listView.addEventListener(Event.CHANGE, function(event:Event):Void {
			changed = true;
		});
		Assert.isFalse(changed);
		this._listView.dataProvider.removeAll();
		Assert.isTrue(changed);
		Assert.areEqual(-1, this._listView.selectedIndex);
		Assert.areEqual(null, this._listView.selectedItem);
	}
}
