/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.layout;

import feathers.core.IMeasureObject;
import feathers.core.IValidating;
import feathers.events.FeathersEvent;
import openfl.display.DisplayObject;
import openfl.errors.ArgumentError;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
	Positions items from top to bottom in a single column, and all items are
	resized to have the same width and height.

	@event openfl.events.Event.CHANGE

	@see [Tutorial: How to use VerticalDistributedLayout with layout containers](https://feathersui.com/learn/haxe-openfl/vertical-distributed-layout/)

	@since 1.0.0
**/
@:event(openfl.events.Event.CHANGE)
class VerticalDistributedLayout extends EventDispatcher implements ILayout {
	/**
		Creates a new `VerticalDistributedLayout` object.

		@since 1.0.0
	**/
	public function new() {
		super();
	}

	private var _paddingTop:Float = 0.0;

	/**
		The space, in pixels, between the parent container's top edge and its
		content.

		In the following example, the layout's top padding is set to 20 pixels:

		```hx
		layout.paddingTop = 20.0;
		```

		@default 0.0

		@since 1.0.0
	**/
	@:flash.property
	public var paddingTop(get, set):Float;

	private function get_paddingTop():Float {
		return this._paddingTop;
	}

	private function set_paddingTop(value:Float):Float {
		if (this._paddingTop == value) {
			return this._paddingTop;
		}
		this._paddingTop = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._paddingTop;
	}

	private var _paddingRight:Float = 0.0;

	/**
		The space, in pixels, between the parent container's right edge and its
		content.

		In the following example, the layout's right padding is set to 20 pixels:

		```hx
		layout.paddingRight = 20.0;
		```

		@default 0.0

		@since 1.0.0
	**/
	@:flash.property
	public var paddingRight(get, set):Float;

	private function get_paddingRight():Float {
		return this._paddingRight;
	}

	private function set_paddingRight(value:Float):Float {
		if (this._paddingRight == value) {
			return this._paddingRight;
		}
		this._paddingRight = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._paddingRight;
	}

	private var _paddingBottom:Float = 0.0;

	/**
		The space, in pixels, between the parent container's bottom edge and its
		content.

		In the following example, the layout's bottom padding is set to 20 pixels:

		```hx
		layout.paddingBottom = 20.0;
		```

		@default 0.0

		@since 1.0.0
	**/
	@:flash.property
	public var paddingBottom(get, set):Float;

	private function get_paddingBottom():Float {
		return this._paddingBottom;
	}

	private function set_paddingBottom(value:Float):Float {
		if (this._paddingBottom == value) {
			return this._paddingBottom;
		}
		this._paddingBottom = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._paddingBottom;
	}

	private var _paddingLeft:Float = 0.0;

	/**
		The space, in pixels, between the parent container's left edge and its
		content.

		In the following example, the layout's left padding is set to 20 pixels:

		```hx
		layout.paddingLeft = 20.0;
		```

		@default 0.0

		@since 1.0.0
	**/
	@:flash.property
	public var paddingLeft(get, set):Float;

	private function get_paddingLeft():Float {
		return this._paddingLeft;
	}

	private function set_paddingLeft(value:Float):Float {
		if (this._paddingLeft == value) {
			return this._paddingLeft;
		}
		this._paddingLeft = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._paddingLeft;
	}

	private var _gap:Float = 0.0;

	/**
		The space, in pixels, between each two adjacent items in the layout.

		In the following example, the layout's gap is set to 20 pixels:

		```hx
		layout.gap = 20.0;
		```

		@default 0.0

		@since 1.0.0
	**/
	@:flash.property
	public var gap(get, set):Float;

	private function get_gap():Float {
		return this._gap;
	}

	private function set_gap(value:Float):Float {
		if (this._gap == value) {
			return this._gap;
		}
		this._gap = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._gap;
	}

	private var _maxItemHeight:Float = 1.0 / 0.0; // Math.POSITIVE_INFINITY bug workaround

	/**
		The maximum height of an item in the layout.

		In the following example, the layout's maximum item height is set to 20
		pixels:

		```hx
		layout.maxItemHeight = 20.0;
		```

		@since 1.0.0
	**/
	@:flash.property
	public var maxItemHeight(get, set):Float;

	private function get_maxItemHeight():Float {
		return this._maxItemHeight;
	}

	private function set_maxItemHeight(value:Float):Float {
		if (this._maxItemHeight == value) {
			return this._maxItemHeight;
		}
		this._maxItemHeight = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._maxItemHeight;
	}

	private var _minItemHeight:Float = 0.0;

	/**
		The minimum height of an item in the layout.

		In the following example, the layout's minimum item height is set to 20
		pixels:

		```hx
		layout.minItemHeight = 20.0;
		```

		@since 1.0.0
	**/
	@:flash.property
	public var minItemHeight(get, set):Float;

	private function get_minItemHeight():Float {
		return this._minItemHeight;
	}

	private function set_minItemHeight(value:Float):Float {
		if (this._minItemHeight == value) {
			return this._minItemHeight;
		}
		this._minItemHeight = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._minItemHeight;
	}

	private var _horizontalAlign:HorizontalAlign = LEFT;

	/**
		How the content is positioned horizontally (along the x-axis) within the
		container.

		The following example aligns the container's content to the right:

		```hx
		layout.horizontalAlign = RIGHT;
		```

		@default feathers.layout.HorizontalAlign.LEFT

		@see `feathers.layout.HorizontalAlign.LEFT`
		@see `feathers.layout.HorizontalAlign.CENTER`
		@see `feathers.layout.HorizontalAlign.RIGHT`
		@see `feathers.layout.HorizontalAlign.JUSTIFY`

		@since 1.0.0
	**/
	@:flash.property
	public var horizontalAlign(get, set):HorizontalAlign;

	private function get_horizontalAlign():HorizontalAlign {
		return this._horizontalAlign;
	}

	private function set_horizontalAlign(value:HorizontalAlign):HorizontalAlign {
		if (this._horizontalAlign == value) {
			return this._horizontalAlign;
		}
		this._horizontalAlign = value;
		this.dispatchEvent(new Event(Event.CHANGE));
		return this._horizontalAlign;
	}

	/**
		Sets all four padding properties to the same value.

		@see `VerticalDistributedLayout.paddingTop`
		@see `VerticalDistributedLayout.paddingRight`
		@see `VerticalDistributedLayout.paddingBottom`
		@see `VerticalDistributedLayout.paddingLeft`

		@since 1.0.0
	**/
	public function setPadding(value:Float):Void {
		this.paddingTop = value;
		this.paddingRight = value;
		this.paddingBottom = value;
		this.paddingLeft = value;
	}

	/**
		@see `feathers.layout.ILayout.layout()`
	**/
	public function layout(items:Array<DisplayObject>, measurements:Measurements, ?result:LayoutBoundsResult):LayoutBoundsResult {
		this.applyDistributedHeight(items, measurements.height, measurements.minHeight, measurements.maxHeight);

		var contentWidth = 0.0;
		var contentHeight = this._paddingTop;
		for (item in items) {
			var layoutObject:ILayoutObject = null;
			if (Std.is(item, ILayoutObject)) {
				layoutObject = cast(item, ILayoutObject);
				if (!layoutObject.includeInLayout) {
					continue;
				}
			}
			if (Std.is(item, IValidating)) {
				cast(item, IValidating).validateNow();
			}
			if (contentWidth < item.width) {
				contentWidth = item.width;
			}
			item.y = contentHeight;
			contentHeight += item.height + this._gap;
		}
		var maxItemWidth = contentWidth;
		contentWidth += this._paddingLeft + this._paddingRight;
		contentHeight += this._paddingBottom;
		if (items.length > 0) {
			contentHeight -= this._gap;
		}

		var viewPortWidth = contentWidth;
		if (measurements.width != null) {
			viewPortWidth = measurements.width;
		} else {
			if (measurements.minWidth != null && viewPortWidth < measurements.minWidth) {
				viewPortWidth = measurements.minWidth;
			} else if (measurements.maxWidth != null && viewPortWidth > measurements.maxWidth) {
				viewPortWidth = measurements.maxWidth;
			}
		}
		var viewPortHeight = contentHeight;
		if (measurements.height != null) {
			viewPortHeight = measurements.height;
		} else {
			if (measurements.minHeight != null && viewPortHeight < measurements.minHeight) {
				viewPortHeight = measurements.minHeight;
			} else if (measurements.maxHeight != null && viewPortHeight > measurements.maxHeight) {
				viewPortHeight = measurements.maxHeight;
			}
		}

		this.applyHorizontalAlign(items, maxItemWidth, viewPortWidth);

		if (contentWidth < viewPortWidth) {
			contentWidth = viewPortWidth;
		}
		if (contentHeight < viewPortHeight) {
			contentHeight = viewPortHeight;
		}

		if (result == null) {
			result = new LayoutBoundsResult();
		}
		result.contentWidth = contentWidth;
		result.contentHeight = contentHeight;
		result.viewPortWidth = viewPortWidth;
		result.viewPortHeight = viewPortHeight;
		return result;
	}

	private inline function validateItems(items:Array<DisplayObject>) {
		for (item in items) {
			if (Std.is(item, IValidating)) {
				cast(item, IValidating).validateNow();
			}
		}
	}

	private function applyDistributedHeight(items:Array<DisplayObject>, explicitHeight:Null<Float>, explicitMinHeight:Null<Float>,
			explicitMaxHeight:Null<Float>):Void {
		var maxMinHeight = 0.0;
		var totalPercentHeight = 0.0;
		for (item in items) {
			if (Std.is(item, IValidating)) {
				cast(item, IValidating).validateNow();
			}
			var itemMinHeight = 0.0;
			if (Std.is(item, IMeasureObject)) {
				var measureItem = cast(item, IMeasureObject);
				itemMinHeight = measureItem.minHeight;
			}
			if (maxMinHeight < itemMinHeight) {
				maxMinHeight = itemMinHeight;
			}
			totalPercentHeight += 100.0;
		}
		var remainingHeight = 0.0;
		if (explicitHeight != null) {
			remainingHeight = explicitHeight;
		} else {
			remainingHeight = this._paddingTop + this._paddingBottom + ((maxMinHeight + this._gap) * items.length) - this._gap;
			if (explicitMinHeight != null && remainingHeight < explicitMinHeight) {
				remainingHeight = explicitMinHeight;
			} else if (explicitMaxHeight != null && remainingHeight > explicitMaxHeight) {
				remainingHeight = explicitMaxHeight;
			}
		}
		remainingHeight -= (this._paddingTop + this._paddingBottom + this._gap * (items.length - 1));
		if (remainingHeight < 0.0) {
			remainingHeight = 0.0;
		}
		var percentToPixels = remainingHeight / totalPercentHeight;
		for (item in items) {
			var itemHeight = percentToPixels * 100.0;
			if (itemHeight < this._minItemHeight) {
				itemHeight = this._minItemHeight;
			} else if (itemHeight > this._maxItemHeight) {
				itemHeight = this._maxItemHeight;
			}
			item.height = itemHeight;
			if (Std.is(item, IValidating)) {
				// changing the width of the item may cause its height
				// to change, so we need to validate. the height is
				// needed for measurement.
				cast(item, IValidating).validateNow();
			}
		}
	}

	private inline function applyHorizontalAlign(items:Array<DisplayObject>, maxItemWidth:Float, viewPortWidth:Float):Void {
		for (item in items) {
			var layoutObject:ILayoutObject = null;
			if (Std.is(item, ILayoutObject)) {
				layoutObject = cast(item, ILayoutObject);
				if (!layoutObject.includeInLayout) {
					continue;
				}
			}
			switch (this._horizontalAlign) {
				case RIGHT:
					item.x = Math.max(this._paddingLeft, this._paddingLeft + (viewPortWidth - this._paddingLeft - this._paddingRight) - item.width);
				case CENTER:
					item.x = Math.max(this._paddingLeft, this._paddingLeft + (viewPortWidth - this._paddingLeft - this._paddingRight - item.width) / 2.0);
				case LEFT:
					item.x = this._paddingLeft;
				case JUSTIFY:
					item.x = this._paddingLeft;
					item.width = viewPortWidth - this._paddingLeft - this._paddingRight;
				default:
					throw new ArgumentError("Unknown horizontal align: " + this._horizontalAlign);
			}
		}
	}
}
