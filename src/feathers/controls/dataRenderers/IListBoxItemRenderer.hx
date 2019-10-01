/*
	Feathers UI
	Copyright 2019 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls.dataRenderers;

/**
	A data renderer for the `ListBox` component.

	@see feathers.controls.ListBox
	@see feathers.data.IFlatCollection

	@since 1.0.0
**/
interface IListBoxItemRenderer extends IDataRenderer {
	/**
		The index of the data in a flat collection.
	**/
	public var index(default, set):Int;
}
