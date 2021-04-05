/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls;

/**
	Minimum requirements for a scroll bar to be usable with subclasses of the
	`BaseScrollContainer` component.

	@event feathers.events.ScrollEvent.SCROLL_START Dispatched when scrolling
	starts.

	@event feathers.events.ScrollEvent.SCROLL_COMPLETE Dispatched when scrolling
	completes.

	@since 1.0.0
**/
@:event(feathers.events.ScrollEvent.SCROLL_START)
@:event(feathers.events.ScrollEvent.SCROLL_COMPLETE)
interface IScrollBar extends IRange {
	/**
		The amount the value must change to increment or decrement by a "step".

		@since 1.0.0
	**/
	@:flash.property
	public var step(get, set):Float;

	/**
		The amount the scroll bar value must change to get from one "page" to
		the next.

		@since 1.0.0
	**/
	@:flash.property
	public var page(get, set):Float;
}
