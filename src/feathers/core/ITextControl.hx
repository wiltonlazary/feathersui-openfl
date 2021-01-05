/*
	Feathers UI
	Copyright 2020 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.core;

/**
	A user interface control that displays text.

	@since 1.0.0
**/
interface ITextControl extends IUIControl {
	/**
		The text to display.

		@since 1.0.0
	**/
	@:flash.property
	public var text(get, set):String;
}
