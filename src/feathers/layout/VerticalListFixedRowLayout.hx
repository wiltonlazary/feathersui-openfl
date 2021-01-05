/*
	Feathers UI
	Copyright 2020 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.layout;

import openfl.geom.Point;
import feathers.core.IValidating;
import feathers.events.FeathersEvent;
import feathers.layout.IVirtualLayout.VirtualLayoutRange;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
	A simple list layout that positions items from top to bottom, in a single
	column, where every item has the same width and height. The items fill the
	entire width of the container. The height of items is determined by the
	measured height of the first item, or it may be overridden using the
	`rowHeight` property.

	@since 1.0.0
**/
@:event(openfl.events.Event.CHANGE)
class VerticalListFixedRowLayout extends EventDispatcher implements IVirtualLayout {
	/**
		Creates a new `VerticalListFixedRowLayout` object.

		@since 1.0.0
	**/
	public function new() {
		super();
	}

	private var _scrollX:Float = 0.0;

	/**
		@see `feathers.layout.IScrollLayout.scrollX`
	**/
	@:flash.property
	public var scrollX(get, set):Float;

	private function get_scrollX():Float {
		return this._scrollX;
	}

	private function set_scrollX(value:Float):Float {
		this._scrollX = value;
		return this._scrollX;
	}

	private var _scrollY:Float = 0.0;

	/**
		@see `feathers.layout.IScrollLayout.scrollY`
	**/
	@:flash.property
	public var scrollY(get, set):Float;

	private function get_scrollY():Float {
		return this._scrollY;
	}

	private function set_scrollY(value:Float):Float {
		this._scrollY = value;
		return this._scrollY;
	}

	private var _virtualCache:Array<Dynamic>;

	/**
		@see `feathers.layout.IVirtualLayout.virtualCache`
	**/
	@:flash.property
	public var virtualCache(get, set):Array<Dynamic>;

	private function get_virtualCache():Array<Dynamic> {
		return this._virtualCache;
	}

	private function set_virtualCache(value:Array<Dynamic>):Array<Dynamic> {
		this._virtualCache = value;
		return this._virtualCache;
	}

	/**
		@see `feathers.layout.IScrollLayout.elasticTop`
	**/
	@:flash.property
	public var elasticTop(get, never):Bool;

	private function get_elasticTop():Bool {
		return true;
	}

	/**
		@see `feathers.layout.IScrollLayout.elasticRight`
	**/
	@:flash.property
	public var elasticRight(get, never):Bool;

	private function get_elasticRight():Bool {
		return false;
	}

	/**
		@see `feathers.layout.IScrollLayout.elasticBottom`
	**/
	@:flash.property
	public var elasticBottom(get, never):Bool;

	private function get_elasticBottom():Bool {
		return true;
	}

	/**
		@see `feathers.layout.IScrollLayout.elasticLeft`
	**/
	@:flash.property
	public var elasticLeft(get, never):Bool;

	private function get_elasticLeft():Bool {
		return false;
	}

	/**
		@see `feathers.layout.IScrollLayout.requiresLayoutOnScroll`
	**/
	@:flash.property
	public var requiresLayoutOnScroll(get, never):Bool;

	private function get_requiresLayoutOnScroll():Bool {
		return true;
	}

	private var _rowHeight:Null<Float> = null;

	/**
		The height to set on each item, or `null`, if the row height should be
		calculated automatically.

		In the following example, the layout's row height is set to 20 pixels:

		```hx
		layout.rowHeight = 20.0;
		```

		@default null

		@since 1.0.0
	**/
	@:flash.property
	public var rowHeight(get, set):Null<Float>;

	private function get_rowHeight():Null<Float> {
		return this._rowHeight;
	}

	private function set_rowHeight(value:Null<Float>):Null<Float> {
		if (this._rowHeight == value) {
			return this._rowHeight;
		}
		this._rowHeight = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._rowHeight;
	}

	private var _requestedRowCount:Null<Float> = null;

	/**
		The exact number of rows to render, if the height of the container has
		not been set explicitly. If `null`, falls back to `requestedMinRowCount`
		and `requestedMaxRowCount`.

		In the following example, the layout's requested row count is set to 2 items:

		```hx
		layout.requestedRowCount = 2.0;
		```

		@default null

		@since 1.0.0
	**/
	@:flash.property
	public var requestedRowCount(get, set):Null<Float>;

	private function get_requestedRowCount():Null<Float> {
		return this._requestedRowCount;
	}

	private function set_requestedRowCount(value:Null<Float>):Null<Float> {
		if (this._requestedRowCount == value) {
			return this._requestedRowCount;
		}
		this._requestedRowCount = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._requestedRowCount;
	}

	private var _requestedMinRowCount:Null<Float> = null;

	/**
		The minimum number of rows to render, if the height of the container has
		not been set explicitly. If `null`, this property is ignored.

		If `requestedRowCount` is also set, this property is ignored.

		In the following example, the layout's requested minimum row count is
		set to 2 complete items:

		```hx
		layout.requestedMinRowCount = 2.0;
		```

		@default null

		@since 1.0.0
	**/
	@:flash.property
	public var requestedMinRowCount(get, set):Null<Float>;

	private function get_requestedMinRowCount():Null<Float> {
		return this._requestedMinRowCount;
	}

	private function set_requestedMinRowCount(value:Null<Float>):Null<Float> {
		if (this._requestedMinRowCount == value) {
			return this._requestedMinRowCount;
		}
		this._requestedMinRowCount = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._requestedMinRowCount;
	}

	private var _requestedMaxRowCount:Null<Float> = null;

	/**
		The maximum number of rows to render, if the height of the container has
		not been set explicitly. If `null`, the maximum number of rows is the
		total number of items displayed by the layout.

		If `requestedRowCount` is also set, this property is ignored.

		In the following example, the layout's requested maximum row count is
		set to 5 complete items:

		```hx
		layout.requestedMaxRowCount = 5.0;
		```

		@default null

		@since 1.0.0
	**/
	@:flash.property
	public var requestedMaxRowCount(get, set):Null<Float>;

	private function get_requestedMaxRowCount():Null<Float> {
		return this._requestedMaxRowCount;
	}

	private function set_requestedMaxRowCount(value:Null<Float>):Null<Float> {
		if (this._requestedMaxRowCount == value) {
			return this._requestedMaxRowCount;
		}
		this._requestedMaxRowCount = value;
		FeathersEvent.dispatch(this, Event.CHANGE);
		return this._requestedMaxRowCount;
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

	private var _verticalAlign:VerticalAlign = TOP;

	/**
		How the content is positioned vertically (along the y-axis) within the
		container.

		**Note:** The `VerticalAlign.JUSTIFY` constant is not supported by this
		layout.

		The following example aligns the container's content to the bottom:

		```hx
		layout.verticalAlign = BOTTOM;
		```

		@default feathers.layout.VerticalAlign.TOP

		@see `feathers.layout.VerticalAlign.TOP`
		@see `feathers.layout.VerticalAlign.MIDDLE`
		@see `feathers.layout.VerticalAlign.BOTTOM`

		@since 1.0.0
	**/
	@:flash.property
	public var verticalAlign(get, set):VerticalAlign;

	private function get_verticalAlign():VerticalAlign {
		return this._verticalAlign;
	}

	private function set_verticalAlign(value:VerticalAlign):VerticalAlign {
		if (this._verticalAlign == value) {
			return this._verticalAlign;
		}
		this._verticalAlign = value;
		this.dispatchEvent(new Event(Event.CHANGE));
		return this._verticalAlign;
	}

	/**
		@see `feathers.layout.ILayout.layout()`
	**/
	public function layout(items:Array<DisplayObject>, measurements:Measurements, ?result:LayoutBoundsResult):LayoutBoundsResult {
		var viewPortWidth = this.calculateViewPortWidth(items, measurements);
		var itemWidth = viewPortWidth - this._paddingLeft - this._paddingRight;
		var actualRowHeight = this.calculateRowHeight(items, itemWidth);
		var positionY = this._paddingTop;
		for (item in items) {
			if (item != null) {
				if (Std.is(item, ILayoutObject)) {
					if (!cast(item, ILayoutObject).includeInLayout) {
						continue;
					}
				}
				item.x = this._paddingLeft;
				item.y = positionY;
				item.width = itemWidth;
				item.height = actualRowHeight;
			}
			positionY += actualRowHeight + this._gap;
		}
		if (items.length > 0) {
			positionY -= this._gap;
		}
		positionY += this._paddingBottom;

		var viewPortHeight = positionY;
		if (measurements.height != null) {
			viewPortHeight = measurements.height;
		} else {
			if (this._requestedRowCount != null) {
				viewPortHeight = actualRowHeight * this._requestedRowCount;
			} else {
				if (this._requestedMinRowCount != null && items.length < this._requestedMinRowCount) {
					viewPortHeight = actualRowHeight * this._requestedMinRowCount;
				} else if (this._requestedMaxRowCount != null && items.length > this._requestedMaxRowCount) {
					viewPortHeight = actualRowHeight * this._requestedMaxRowCount;
				}
			}
			if (measurements.minHeight != null && viewPortHeight < measurements.minHeight) {
				viewPortHeight = measurements.minHeight;
			} else if (measurements.maxHeight != null && viewPortHeight > measurements.maxHeight) {
				viewPortHeight = measurements.maxHeight;
			}
		}

		this.applyVerticalAlign(items, positionY - this._paddingTop - this._paddingBottom, viewPortHeight);

		if (result == null) {
			result = new LayoutBoundsResult();
		}
		result.contentWidth = viewPortWidth;
		result.contentHeight = positionY;
		result.viewPortWidth = viewPortWidth;
		result.viewPortHeight = viewPortHeight;
		return result;
	}

	private function calculateViewPortWidth(items:Array<DisplayObject>, measurements:Measurements):Float {
		if (measurements.width != null) {
			return measurements.width;
		}
		var maxWidth = 0.0;
		for (i in 0...items.length) {
			var item = items[i];
			if (item == null) {
				continue;
			}
			if (Std.is(item, ILayoutObject)) {
				if (!cast(item, ILayoutObject).includeInLayout) {
					continue;
				}
			}
			if (Std.is(item, IValidating)) {
				cast(item, IValidating).validateNow();
			}
			var itemWidth = item.width;
			if (itemWidth > maxWidth) {
				maxWidth = itemWidth;
			}
		}
		return maxWidth + this._paddingLeft + this._paddingRight;
	}

	private function calculateRowHeight(items:Array<DisplayObject>, itemWidth:Float):Float {
		var actualRowHeight = 0.0;
		if (this._rowHeight != null) {
			actualRowHeight = this._rowHeight;
		} else {
			// find the height of the first existing item
			for (i in 0...items.length) {
				var item = items[i];
				if (item == null) {
					if (this._virtualCache == null || this._virtualCache.length <= i) {
						continue;
					}
					var cacheItem = Std.downcast(this._virtualCache[0], VirtualCacheItem);
					if (cacheItem == null) {
						continue;
					}
					actualRowHeight = cacheItem.itemHeight;
					break;
				}
				item.width = itemWidth;
				if (Std.is(item, ILayoutObject)) {
					if (!cast(item, ILayoutObject).includeInLayout) {
						continue;
					}
				}
				if (Std.is(item, IValidating)) {
					cast(item, IValidating).validateNow();
				}
				actualRowHeight = item.height;
				if (this._virtualCache != null) {
					// since all items are the same height, we can store just
					// one value as an optimization
					var cacheItem = Std.downcast(this._virtualCache[0], VirtualCacheItem);
					if (cacheItem == null) {
						cacheItem = new VirtualCacheItem(actualRowHeight);
						this._virtualCache[0] = cacheItem;
						FeathersEvent.dispatch(this, Event.CHANGE);
					} else if (cacheItem.itemHeight != actualRowHeight) {
						cacheItem.itemHeight = actualRowHeight;
						this._virtualCache[0] = cacheItem;
						FeathersEvent.dispatch(this, Event.CHANGE);
					}
					// changing the item height in the cache may affect the
					// number of items that are visible, so we dispatch
					// Event.CHANGE need to check that again
				}
				break;
			}
		}
		return actualRowHeight;
	}

	/**
		@see `feathers.layout.IVirtualLayout.getVisibleIndices()`
	**/
	public function getVisibleIndices(itemCount:Int, width:Float, height:Float, ?result:VirtualLayoutRange):VirtualLayoutRange {
		var itemHeight = 0.0;
		if (this._rowHeight != null) {
			itemHeight = this._rowHeight;
		} else if (this._virtualCache != null) {
			var cacheItem = Std.downcast(this._virtualCache[0], VirtualCacheItem);
			if (cacheItem != null) {
				itemHeight = cacheItem.itemHeight;
			}
		}
		itemHeight += this._gap;
		var startIndex = 0;
		var endIndex = 0;
		if (itemHeight > 0.0) {
			startIndex = Math.floor((this._scrollY - this._paddingTop) / itemHeight);
			if (startIndex < 0) {
				startIndex = 0;
			}
			endIndex = startIndex + Math.ceil(height / itemHeight);
			if (endIndex >= itemCount) {
				var oldEndIndex = endIndex;
				endIndex = itemCount - 1;
				// for performance reasons, it's better to always display the same
				// number of items, even if we technically don't need that many
				startIndex -= (oldEndIndex - endIndex);
				if (startIndex < 0) {
					startIndex = 0;
				}
			}
		}
		if (result == null) {
			return new VirtualLayoutRange(startIndex, endIndex);
		}
		result.start = startIndex;
		result.end = endIndex;
		return result;
	}

	/**
		@see `feathers.layout.IScrollLayout.getNearestScrollPositionForIndex()`
	**/
	public function getNearestScrollPositionForIndex(index:Int, itemCount:Int, width:Float, height:Float, ?result:Point):Point {
		var itemHeight = 0.0;
		if (this._rowHeight != null) {
			itemHeight = this._rowHeight;
		} else if (this._virtualCache != null) {
			var cacheItem = Std.downcast(this._virtualCache[0], VirtualCacheItem);
			if (cacheItem != null) {
				itemHeight = cacheItem.itemHeight;
			}
		}
		itemHeight += this._gap;

		var maxY = this._paddingTop + (itemHeight * index);
		var minY = maxY + itemHeight - height;

		var targetY = this._scrollY;
		if (targetY < minY) {
			targetY = minY;
		} else if (targetY > maxY) {
			targetY = maxY;
		}
		if (result == null) {
			result = new Point();
		}
		result.x = this._scrollX;
		result.y = targetY;
		return result;
	}

	private inline function applyVerticalAlign(items:Array<DisplayObject>, contentHeight:Float, viewPortHeight:Float):Void {
		if (this._verticalAlign != BOTTOM && this._verticalAlign != MIDDLE) {
			return;
		}
		var maxAlignmentHeight = viewPortHeight - this._paddingTop - this._paddingBottom;
		if (contentHeight >= maxAlignmentHeight) {
			return;
		}
		var verticalOffset = 0.0;
		if (this._verticalAlign == BOTTOM) {
			verticalOffset = maxAlignmentHeight - contentHeight;
		} else if (this._verticalAlign == MIDDLE) {
			verticalOffset = (maxAlignmentHeight - contentHeight) / 2.0;
		}
		for (item in items) {
			if (item == null) {
				continue;
			}
			var layoutObject:ILayoutObject = null;
			if (Std.is(item, ILayoutObject)) {
				layoutObject = cast(item, ILayoutObject);
				if (!layoutObject.includeInLayout) {
					continue;
				}
			}
			item.y = Math.max(this._paddingTop, item.y + verticalOffset);
		}
	}
}

@:dox(hide)
private class VirtualCacheItem {
	public function new(itemHeight:Float) {
		this.itemHeight = itemHeight;
	}

	public var itemHeight:Float;
}
