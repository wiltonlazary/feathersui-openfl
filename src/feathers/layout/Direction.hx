/*
	Feathers UI
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.layout;

/**
	Constants that define a direction.

	Note: Some constants may not be valid for certain properties. Please see
	the description of the property in the API reference for complete details.

	@since 1.0.0
**/
@:enum
abstract Direction(String) {
	/**
		The object will be oriented vertically.

		@since 1.0.0
	**/
	var VERTICAL = "vertical";

	/**
		The object will be oriented horizontally.

		@since 1.0.0
	**/
	var HORIZONTAL = "horizontal";

	/**
		The object will be oriented in no particular direction.

		@since 1.0.0
	**/
	var NONE = "none";
}
