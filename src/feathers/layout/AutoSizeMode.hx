/*
	Feathers UI
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.layout;

/**
	Constants that determine how a component should automatically calculate its
	own dimensions when no explicit dimensions are provided.

	@since 1.0.0
**/
@:enum
abstract AutoSizeMode(String) {
	/**
		The component will automatically calculate its dimensions to fill the
		entire stage.

		@since 1.0.0
	**/
	var STAGE = "stage";

	/**
		The component will automatically calculate its dimensions to fit its
		content's ideal dimensions.

		@since 1.0.0
	**/
	var CONTENT = "content";
}
