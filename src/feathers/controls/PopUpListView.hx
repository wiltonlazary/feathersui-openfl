/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls;

import feathers.events.ListViewEvent;
import openfl.events.FocusEvent;
import feathers.core.IFocusObject;
import feathers.core.IIndexSelector;
import feathers.utils.MeasurementsUtil;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.utils.DisplayObjectRecycler;
import feathers.data.ListViewItemState;
import openfl.display.DisplayObject;
import feathers.themes.steel.components.SteelPopUpListViewStyles;
import openfl.events.TouchEvent;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import feathers.events.FeathersEvent;
import openfl.events.Event;
import feathers.core.InvalidationFlag;
import feathers.data.IFlatCollection;
import feathers.layout.Measurements;
import feathers.core.PopUpManager;
import openfl.events.MouseEvent;
import feathers.controls.popups.IPopUpAdapter;
import feathers.core.FeathersControl;
import feathers.core.IDataSelector;
#if air
import openfl.ui.Multitouch;
#end
#if lime
import lime.ui.KeyCode;
#end

/**
	Displays a `Button` that may be triggered to display a `ListView` as a
	pop-up. The list view may be customized to display in different ways, such
	as a drop-down, inside a `Callout`, or as a modal overlay.

	The following example creates a pop-up list, gives it a data provider, tells
	the item renderer how to interpret the data, and listens for when the
	selection changes:

	```hx
	var listView = new PopUpListView();

	listView.dataProvider = new ArrayCollection([
		{ text: "Milk" },
		{ text: "Eggs" },
		{ text: "Bread" },
		{ text: "Steak" },
	]);

	listView.itemToText = (item:Dynamic) -> {
		return item.text;
	};

	listView.addEventListener(Event.CHANGE, (event:Event) -> {
		var list = cast(event.currentTarget, PopUpListView);
		trace("PopUpListView changed: " + listView.selectedIndex + " " + listView.selectedItem.text);
	});

	this.addChild(list);
	```

	@event openfl.events.Event.CHANGE Dispatched when either
	`PopUpListView.selectedItem` or `PopUpListView.selectedIndex` changes.

	@event openfl.events.Event.OPEN Dispatched when the pop-up list view is
	opened.

	@event openfl.events.Event.CLOSE Dispatched when the pop-up list view is
	closed.

	@event feathers.events.ListViewEvent.ITEM_TRIGGER Dispatched when the user
	taps or clicks an item renderer in the pop-up list view. The pointer must
	remain within the bounds of the item renderer on release, and the list
	view cannot scroll before release, or the gesture will be ignored.

	@see [Tutorial: How to use the PopUpListView component](https://feathersui.com/learn/haxe-openfl/pop-up-list-view/)
	@see `feathers.controls.ComboBox`

	@since 1.0.0
**/
@:event(openfl.events.Event.CHANGE)
@:event(openfl.events.Event.OPEN)
@:event(openfl.events.Event.CLOSE)
@:event(feathers.events.ListViewEvent.ITEM_TRIGGER)
@:meta(DefaultProperty("dataProvider"))
@defaultXmlProperty("dataProvider")
@:styleContext
class PopUpListView extends FeathersControl implements IIndexSelector implements IDataSelector<Dynamic> implements IFocusObject {
	private static final INVALIDATION_FLAG_BUTTON_FACTORY = InvalidationFlag.CUSTOM("buttonFactory");
	private static final INVALIDATION_FLAG_LIST_VIEW_FACTORY = InvalidationFlag.CUSTOM("listViewFactory");

	/**
		The variant used to style the `Button` child component in a theme.

		To override this default variant, set the
		`PopUpListView.customButtonVariant` property.

		@see [Feathers UI User Manual: Themes](https://feathersui.com/learn/haxe-openfl/themes/)

		@see `PopUpListView.customButtonVariant`

		@since 1.0.0
	**/
	public static final CHILD_VARIANT_BUTTON = "popUpListView_button";

	/**
		The variant used to style the `ListView` child component in a theme.

		To override this default variant, set the
		`PopUpListView.customListViewVariant` property.

		@see [Feathers UI User Manual: Themes](https://feathersui.com/learn/haxe-openfl/themes/)

		@see `PopUpListView.customListViewVariant`

		@since 1.0.0
	**/
	public static final CHILD_VARIANT_LIST_VIEW = "popUpListView_listView";

	private static function defaultButtonFactory():Button {
		return new Button();
	}

	private static function defaultListViewFactory():ListView {
		return new ListView();
	}

	/**
		Creates a new `PopUpListView` object.

		@since 1.0.0
	**/
	public function new(?dataProvider:IFlatCollection<Dynamic>) {
		initializePopUpListViewTheme();

		super();

		this.dataProvider = dataProvider;

		this.addEventListener(FocusEvent.FOCUS_IN, popUpListView_focusInHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, popUpListView_removedFromStageHandler);
	}

	private var button:Button;
	private var listView:ListView;

	private var buttonMeasurements:Measurements = new Measurements();

	private var _dataProvider:IFlatCollection<Dynamic>;

	/**
		The collection of data displayed by the list view.

		Items in the collection must be class instances or anonymous structures.
		Do not add primitive values (such as strings, booleans, or numeric
		values) directly to the collection.

		Additionally, all items in the collection must be unique object
		instances. Do not add the same instance to the collection more than
		once because a runtime exception will be thrown.

		The following example passes in a data provider and tells the item
		renderer how to interpret the data:

		```hx
		listView.dataProvider = new ArrayCollection([
			{ text: "Milk" },
			{ text: "Eggs" },
			{ text: "Bread" },
			{ text: "Chicken" },
		]);

		listView.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		```

		@default null

		@see `feathers.data.ArrayCollection`

		@since 1.0.0
	**/
	@:flash.property
	public var dataProvider(get, set):IFlatCollection<Dynamic>;

	private function get_dataProvider():IFlatCollection<Dynamic> {
		return this._dataProvider;
	}

	private function set_dataProvider(value:IFlatCollection<Dynamic>):IFlatCollection<Dynamic> {
		if (this._dataProvider == value) {
			return this._dataProvider;
		}
		var oldSelectedIndex = this._selectedIndex;
		var oldSelectedItem = this._selectedItem;
		this._dataProvider = value;
		if (this._dataProvider == null || this._dataProvider.length == 0) {
			// use the setter
			this.selectedIndex = -1;
		} else {
			// use the setter
			this.selectedIndex = 0;
		}
		// this ensures that Event.CHANGE will dispatch for selectedItem
		// changing, even if selectedIndex has not changed.
		if (this._selectedIndex == oldSelectedIndex && this._selectedItem != oldSelectedItem) {
			this.setInvalid(SELECTION);
			FeathersEvent.dispatch(this, Event.CHANGE);
		}
		this.setInvalid(DATA);
		return this._dataProvider;
	}

	private var _ignoreListViewChange = false;

	private var _selectedIndex:Int = -1;

	/**
		@see `feathers.core.IIndexSelector.selectedIndex`
	**/
	@:flash.property
	public var selectedIndex(get, set):Int;

	private function get_selectedIndex():Int {
		return this._selectedIndex;
	}

	private function set_selectedIndex(value:Int):Int {
		if (this._dataProvider == null) {
			value = -1;
		}
		if (this._selectedIndex == value) {
			return this._selectedIndex;
		}
		this._selectedIndex = value;
		// using variable because if we were to call the selectedItem setter,
		// then this change wouldn't be saved properly
		if (this._selectedIndex == -1) {
			this._selectedItem = null;
		} else {
			this._selectedItem = this._dataProvider.get(this._selectedIndex);
		}
		this.setInvalid(SELECTION);
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._selectedIndex;
	}

	/**
		@see `feathers.core.IIndexSelector.maxSelectedIndex`
	**/
	@:flash.property
	public var maxSelectedIndex(get, never):Int;

	private function get_maxSelectedIndex():Int {
		if (this._dataProvider == null) {
			return -1;
		}
		return this._dataProvider.length - 1;
	}

	private var _selectedItem:Dynamic = null;

	/**
		@see `feathers.core.IDataSelector.selectedItem`
	**/
	@:flash.property
	public var selectedItem(get, set):Dynamic;

	private function get_selectedItem():Dynamic {
		return this._selectedItem;
	}

	private function set_selectedItem(value:Dynamic):Dynamic {
		if (this._dataProvider == null) {
			// use the setter
			this.selectedIndex = -1;
			return this._selectedItem;
		}
		// use the setter
		this.selectedIndex = this._dataProvider.indexOf(value);
		return this._selectedItem;
	}

	private var _itemRendererRecycler:DisplayObjectRecycler<Dynamic, ListViewItemState, DisplayObject> = DisplayObjectRecycler.withClass(ItemRenderer);

	/**
		Manages item renderers used by the pop-up list view.

		In the following example, the pop-up list view uses a custom item
		renderer class:

		```hx
		listView.itemRendererRecycler = DisplayObjectRecycler.withClass(CustomItemRenderer);
		```

		@since 1.0.0
	**/
	@:flash.property
	public var itemRendererRecycler(get, set):DisplayObjectRecycler<Dynamic, ListViewItemState, DisplayObject>;

	private function get_itemRendererRecycler():DisplayObjectRecycler<Dynamic, ListViewItemState, DisplayObject> {
		return this._itemRendererRecycler;
	}

	private function set_itemRendererRecycler(value:DisplayObjectRecycler<Dynamic, ListViewItemState, DisplayObject>):DisplayObjectRecycler<Dynamic,
		ListViewItemState, DisplayObject> {
		if (this._itemRendererRecycler == value) {
			return this._itemRendererRecycler;
		}
		this._itemRendererRecycler = value;
		this.setInvalid(DATA);
		return this._itemRendererRecycler;
	}

	/**
		Converts an item to text to display within the pop-up `ListView`, or
		within the `Button`, if the item is selected. By default, the
		`toString()` method is called to convert an item to text. This method
		may be replaced to provide custom text.

		For example, consider the following item:

		```hx
		{ text: "Example Item" }
		```

		If the `ListView` should display the text "Example Item", a custom
		implementation of `itemToText()` might look like this:

		```hx
		listView.itemToText = (item:Dynamic) -> {
			return item.text;
		};
		```

		@since 1.0.0
	**/
	public dynamic function itemToText(data:Dynamic):String {
		return Std.string(data);
	}

	/**
		Manages how the list view is displayed when it is opened and closed.

		In the following example, a custom pop-up adapter is provided:

		```hx
		comboBox.popUpAdapter = new DropDownPopUpAdapter();
		```

		@since 1.0.0
	**/
	@:style
	public var popUpAdapter:IPopUpAdapter = null;

	private var _previousCustomButtonVariant:String = null;

	/**
		A custom variant to set on the button, instead of
		`PopUpListView.CHILD_VARIANT_BUTTON`.

		The `customButtonVariant` will be not be used if the result of
		`buttonFactory` already has a variant set.

		@see `PopUpListView.CHILD_VARIANT_BUTTON`

		@since 1.0.0
	**/
	@:style
	public var customButtonVariant:String = null;

	private var _previousCustomListViewVariant:String = null;

	/**
		A custom variant to set on the pop-up list view, instead of
		`PopUpListView.CHILD_VARIANT_LIST_VIEW`.

		The `customListViewVariant` will be not be used if the result of
		`listViewFactory` already has a variant set.

		@see `PopUpListView.CHILD_VARIANT_LIST_VIEW`

		@since 1.0.0
	**/
	@:style
	public var customListViewVariant:String = null;

	private var _buttonFactory:() -> Button;

	/**
		Creates the button, which must be of type `feathers.controls.Button`.

		In the following example, a custom button factory is provided:

		```hx
		listView.buttonFactory = () ->
		{
			return new Button();
		};
		```

		@see `feathers.controls.Button`

		@since 1.0.0
	**/
	@:flash.property
	public var buttonFactory(get, set):() -> Button;

	private function get_buttonFactory():() -> Button {
		return this._buttonFactory;
	}

	private function set_buttonFactory(value:() -> Button):() -> Button {
		if (this._buttonFactory == value) {
			return this._buttonFactory;
		}
		this._buttonFactory = value;
		this.setInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
		return this._buttonFactory;
	}

	private var _listViewFactory:() -> ListView;

	/**
		Creates the list view that is displayed as a pop-up. The list view must
		be of type `feathers.controls.ListView`.

		In the following example, a custom list view factory is provided:

		```hx
		listView.listViewFactory = () ->
		{
			return new ListView();
		};
		```

		@see `feathers.controls.ListView`

		@since 1.0.0
	**/
	@:flash.property
	public var listViewFactory(get, set):() -> ListView;

	private function get_listViewFactory():() -> ListView {
		return this._listViewFactory;
	}

	private function set_listViewFactory(value:() -> ListView):() -> ListView {
		if (this._listViewFactory == value) {
			return this._listViewFactory;
		}
		this._listViewFactory = value;
		this.setInvalid(INVALIDATION_FLAG_LIST_VIEW_FACTORY);
		return this._listViewFactory;
	}

	/**
		Indicates if the list view pop-up is open or closed.

		@see `PopUpListView.openListView()`
		@see `PopUpListView.closeListView()`

		@since 1.0.0
	**/
	@:flash.property
	public var open(get, never):Bool;

	private function get_open():Bool {
		return this.listView != null && this.listView.parent != null;
	}

	override public function showFocus(show:Bool):Void {
		super.showFocus(show);
		if (this.button != null) {
			this.button.showFocus(show);
		}
	}

	/**
		Opens the pop-up list, if it is not already open.

		The following example opens the pop-up list:

		```hx
		if(!listView.open)
		{
			listView.openListView();
		}
		```

		When the pop-up list opens, the component will dispatch an event of type
		`Event.OPEN`.

		@see `PopUpListView.open`
		@see `PopUpListView.closeListView()`
		@see `openfl.events.Event.OPEN`

		@since 1.0.0
	**/
	public function openListView():Void {
		if (this.open || this.stage == null) {
			return;
		}
		if (this.popUpAdapter != null) {
			this.popUpAdapter.addEventListener(Event.OPEN, popUpListView_popUpAdapter_openHandler);
			this.popUpAdapter.addEventListener(Event.CLOSE, popUpListView_popUpAdapter_closeHandler);
			this.popUpAdapter.open(this.listView, this.button);
		} else {
			PopUpManager.addPopUp(this.listView, this.button);
			FeathersEvent.dispatch(this, Event.OPEN);
		}
		this.listView.validateNow();
		this.stage.focus = this.listView;
		this.listView.addEventListener(Event.REMOVED_FROM_STAGE, popUpListView_listView_removedFromStageHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, popUpListView_stage_mouseDownHandler, false, 0, true);
		this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, popUpListView_stage_touchBeginHandler, false, 0, true);
		this.listView.scrollToIndex(this._selectedIndex);
	}

	/**
		Closes the pop-up list, if it is open.

		The following example closes the pop-up list:

		```hx
		if(listView.open)
		{
			listView.closeListView();
		}
		```

		When the pop-up list closes, the component will dispatch an event of
		type `Event.CLOSE`.

		@see `PopUpListView.open`
		@see `PopUpListView.openListView()`
		@see `openfl.events.Event.CLOSE`

		@since 1.0.0
	**/
	public function closeListView():Void {
		if (!this.open) {
			return;
		}
		// TODO: fix this when focus manager is implemented
		this.stage.focus = this;
		if (this.popUpAdapter != null) {
			this.popUpAdapter.close();
		} else {
			this.listView.parent.removeChild(this.listView);
			FeathersEvent.dispatch(this, Event.CLOSE);
		}
	}

	private function initializePopUpListViewTheme():Void {
		SteelPopUpListViewStyles.initialize();
	}

	override private function update():Void {
		var dataInvalid = this.isInvalid(DATA);
		var selectionInvalid = this.isInvalid(SELECTION);
		var stateInvalid = this.isInvalid(STATE);
		if (this._previousCustomButtonVariant != this.customButtonVariant) {
			this.setInvalidationFlag(INVALIDATION_FLAG_BUTTON_FACTORY);
		}
		if (this._previousCustomListViewVariant != this.customListViewVariant) {
			this.setInvalidationFlag(INVALIDATION_FLAG_LIST_VIEW_FACTORY);
		}
		var buttonFactoryInvalid = this.isInvalid(INVALIDATION_FLAG_BUTTON_FACTORY);
		var listViewFactoryInvalid = this.isInvalid(INVALIDATION_FLAG_LIST_VIEW_FACTORY);

		if (buttonFactoryInvalid) {
			this.createButton();
		}
		if (listViewFactoryInvalid) {
			this.createListView();
		}

		if (dataInvalid || listViewFactoryInvalid) {
			this.refreshData();
		}

		if (selectionInvalid || listViewFactoryInvalid || buttonFactoryInvalid) {
			this.refreshSelection();
		}

		if (stateInvalid || listViewFactoryInvalid || buttonFactoryInvalid) {
			this.refreshEnabled();
		}

		this.measure();
		this.layoutChildren();

		this._previousCustomButtonVariant = this.customButtonVariant;
		this._previousCustomListViewVariant = this.customListViewVariant;
	}

	private function createButton():Void {
		if (this.button != null) {
			this.button.removeEventListener(MouseEvent.MOUSE_DOWN, popUpListView_button_mouseDownHandler);
			this.button.removeEventListener(TouchEvent.TOUCH_BEGIN, popUpListView_button_touchBeginHandler);
			this.button.removeEventListener(KeyboardEvent.KEY_DOWN, popUpListView_button_keyDownHandler);
			this.removeChild(this.button);
			this.button = null;
		}
		var factory = this._buttonFactory != null ? this._buttonFactory : defaultButtonFactory;
		this.button = factory();
		if (this.button.variant == null) {
			this.button.variant = this.customButtonVariant != null ? this.customButtonVariant : PopUpListView.CHILD_VARIANT_BUTTON;
		}
		this.button.addEventListener(MouseEvent.MOUSE_DOWN, popUpListView_button_mouseDownHandler);
		this.button.addEventListener(TouchEvent.TOUCH_BEGIN, popUpListView_button_touchBeginHandler);
		this.button.addEventListener(KeyboardEvent.KEY_DOWN, popUpListView_button_keyDownHandler);
		this.button.initializeNow();
		this.buttonMeasurements.save(this.button);
		this.addChild(this.button);
	}

	private function createListView():Void {
		if (this.listView != null) {
			this.listView.removeEventListener(Event.CHANGE, popUpListView_listView_changeHandler);
			this.listView.removeEventListener(ListViewEvent.ITEM_TRIGGER, popUpListView_listView_itemTriggerHandler);
			this.listView.removeEventListener(KeyboardEvent.KEY_UP, popUpListView_listView_keyUpHandler);
			this.listView = null;
		}
		var factory = this._listViewFactory != null ? this._listViewFactory : defaultListViewFactory;
		this.listView = factory();
		if (this.listView.variant == null) {
			this.listView.variant = this.customListViewVariant != null ? this.customListViewVariant : PopUpListView.CHILD_VARIANT_LIST_VIEW;
		}
		this.listView.addEventListener(Event.CHANGE, popUpListView_listView_changeHandler);
		this.listView.addEventListener(ListViewEvent.ITEM_TRIGGER, popUpListView_listView_itemTriggerHandler);
		this.listView.addEventListener(KeyboardEvent.KEY_UP, popUpListView_listView_keyUpHandler);
	}

	private function refreshData():Void {
		this.listView.dataProvider = this._dataProvider;
		this.listView.itemRendererRecycler = this._itemRendererRecycler;
		this.listView.itemToText = this.itemToText;
	}

	private function refreshSelection():Void {
		var oldIgnoreListViewChange = this._ignoreListViewChange;
		this._ignoreListViewChange = true;
		this.listView.selectedIndex = this._selectedIndex;
		this._ignoreListViewChange = oldIgnoreListViewChange;

		if (this._selectedItem != null) {
			this.button.text = this.itemToText(this._selectedItem);
		} else {
			this.button.text = "";
		}
	}

	private function refreshEnabled():Void {
		this.button.enabled = this._enabled;
		this.listView.enabled = this._enabled;
	}

	private function measure():Bool {
		var needsWidth = this.explicitWidth == null;
		var needsHeight = this.explicitHeight == null;
		var needsMinWidth = this.explicitMinWidth == null;
		var needsMinHeight = this.explicitMinHeight == null;
		var needsMaxWidth = this.explicitMaxWidth == null;
		var needsMaxHeight = this.explicitMaxHeight == null;
		if (!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight && !needsMaxWidth && !needsMaxHeight) {
			return false;
		}

		MeasurementsUtil.resetFluidlyWithParent(this.buttonMeasurements, this.button, this);
		this.button.validateNow();

		var newWidth = this.explicitWidth;
		if (needsWidth) {
			newWidth = this.button.width;
		}

		var newHeight = this.explicitHeight;
		if (needsHeight) {
			newHeight = this.button.height;
		}

		var newMinWidth = this.explicitMinWidth;
		if (needsMinWidth) {
			newMinWidth = this.button.minWidth;
		}

		var newMinHeight = this.explicitMinHeight;
		if (needsMinHeight) {
			newMinHeight = this.button.minHeight;
		}

		return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
	}

	private function layoutChildren():Void {
		this.button.validateNow();
		if (this.button.width != this.actualWidth) {
			this.button.width = this.actualWidth;
		}
		if (this.button.height != this.actualHeight) {
			this.button.height = this.actualHeight;
		}
		this.button.validateNow();
	}

	private function navigateWithKeyboard(event:KeyboardEvent):Void {
		if (event.isDefaultPrevented()) {
			return;
		}
		if (this._dataProvider == null || this._dataProvider.length == 0) {
			return;
		}
		var result = this._selectedIndex;
		switch (event.keyCode) {
			case Keyboard.UP:
				result = result - 1;
			case Keyboard.DOWN:
				result = result + 1;
			case Keyboard.LEFT:
				result = result - 1;
			case Keyboard.RIGHT:
				result = result + 1;
			case Keyboard.PAGE_UP:
				result = result - 1;
			case Keyboard.PAGE_DOWN:
				result = result + 1;
			case Keyboard.HOME:
				result = 0;
			case Keyboard.END:
				result = this._dataProvider.length - 1;
			default:
				// not keyboard navigation
				return;
		}
		if (result < 0) {
			result = 0;
		} else if (result >= this._dataProvider.length) {
			result = this._dataProvider.length - 1;
		}
		event.preventDefault();
		// use the setter
		this.selectedIndex = result;
	}

	private function popUpListView_button_keyDownHandler(event:KeyboardEvent):Void {
		if (!this._enabled) {
			return;
		}
		if (!open) {
			this.navigateWithKeyboard(event);
		}
		if (event.keyCode != Keyboard.SPACE && event.keyCode != Keyboard.ENTER) {
			return;
		}
		if (this.open) {
			event.preventDefault();
			this.closeListView();
		} else {
			event.preventDefault();
			this.openListView();
		}
	}

	private function popUpListView_button_mouseDownHandler(event:MouseEvent):Void {
		if (!this._enabled) {
			return;
		}
		if (this.open) {
			this.closeListView();
		} else {
			this.openListView();
		}
	}

	private function popUpListView_button_touchBeginHandler(event:TouchEvent):Void {
		if (!this._enabled) {
			return;
		}
		if (event.isPrimaryTouchPoint #if air && Multitouch.mapTouchToMouse #end) {
			// ignore the primary one because MouseEvent.MOUSE_DOWN will catch it
			return;
		}
		if (this.open) {
			this.closeListView();
		} else {
			this.openListView();
		}
	}

	private function popUpListView_listView_itemTriggerHandler(event:ListViewEvent):Void {
		this.dispatchEvent(event);
		if (this.popUpAdapter == null || !this.popUpAdapter.persistent) {
			this.closeListView();
		}
	}

	private function popUpListView_listView_changeHandler(event:Event):Void {
		if (this._ignoreListViewChange) {
			return;
		}
		// use the setter
		this.selectedIndex = this.listView.selectedIndex;
	}

	private function popUpListView_listView_removedFromStageHandler(event:Event):Void {
		this.listView.removeEventListener(Event.REMOVED_FROM_STAGE, popUpListView_listView_removedFromStageHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, popUpListView_stage_mouseDownHandler);
		this.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, popUpListView_stage_touchBeginHandler);
	}

	private function popUpListView_focusInHandler(event:FocusEvent):Void {
		if (Reflect.compare(event.target, this) == 0) {
			this.stage.focus = this.button;
		}
	}

	private function popUpListView_removedFromStageHandler(event:Event):Void {
		// if something went terribly wrong, at least make sure that the
		// ListView isn't still visible and blocking the rest of the app
		this.closeListView();
	}

	private function popUpListView_listView_keyUpHandler(event:KeyboardEvent):Void {
		if (!this._enabled) {
			return;
		}
		switch (event.keyCode) {
			case Keyboard.ESCAPE:
				if (event.isDefaultPrevented()) {
					return;
				}
				if (!this.open) {
					return;
				}
				event.preventDefault();
				this.closeListView();
			#if lime
			case KeyCode.APP_CONTROL_BACK:
				if (event.isDefaultPrevented()) {
					return;
				}
				if (!this.open) {
					return;
				}
				event.preventDefault();
				this.closeListView();
			#end
		}
	}

	private function popUpListView_stage_mouseDownHandler(event:MouseEvent):Void {
		if (this.button.hitTestPoint(event.stageX, event.stageY) || this.listView.hitTestPoint(event.stageX, event.stageY)) {
			return;
		}
		this.closeListView();
	}

	private function popUpListView_stage_touchBeginHandler(event:TouchEvent):Void {
		if (event.isPrimaryTouchPoint #if air && Multitouch.mapTouchToMouse #end) {
			// ignore the primary one because MouseEvent.MOUSE_DOWN will catch it
			return;
		}
		if (this.button.hitTestPoint(event.stageX, event.stageY) || this.listView.hitTestPoint(event.stageX, event.stageY)) {
			return;
		}
		this.closeListView();
	}

	private function popUpListView_popUpAdapter_openHandler(event:Event):Void {
		FeathersEvent.dispatch(this, Event.OPEN);
	}

	private function popUpListView_popUpAdapter_closeHandler(event:Event):Void {
		FeathersEvent.dispatch(this, Event.CLOSE);
	}
}
