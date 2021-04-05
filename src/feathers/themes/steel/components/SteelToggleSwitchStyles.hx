/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.themes.steel.components;

import feathers.skins.CircleSkin;
import feathers.controls.BasicToggleButton;
import feathers.controls.ToggleSwitch;
import feathers.skins.RectangleSkin;
import feathers.style.Theme;
import feathers.themes.steel.BaseSteelTheme;

/**
	Initialize "steel" styles for the `ToggleSwitch` component.

	@since 1.0.0
**/
@:dox(hide)
@:access(feathers.themes.steel.BaseSteelTheme)
class SteelToggleSwitchStyles {
	public static function initialize(?theme:BaseSteelTheme):Void {
		if (theme == null) {
			theme = Std.downcast(Theme.fallbackTheme, BaseSteelTheme);
		}
		if (theme == null) {
			return;
		}

		var styleProvider = theme.styleProvider;
		if (styleProvider.getStyleFunction(ToggleSwitch, null) == null) {
			styleProvider.setStyleFunction(ToggleSwitch, null, function(toggle:ToggleSwitch):Void {
				if (toggle.trackSkin == null) {
					var trackSkin = new RectangleSkin();
					trackSkin.width = 64.0;
					trackSkin.height = 32.0;
					trackSkin.minWidth = 64.0;
					trackSkin.minHeight = 32.0;
					trackSkin.cornerRadius = 16.0;
					trackSkin.border = theme.getInsetBorder();
					trackSkin.disabledBorder = theme.getInsetBorder();
					trackSkin.selectedBorder = theme.getSelectedInsetBorder();
					trackSkin.fill = theme.getInsetFill();
					trackSkin.selectedFill = theme.getReversedActiveThemeFill();
					trackSkin.disabledFill = theme.getDisabledInsetFill();

					var track = new BasicToggleButton();
					track.toggleable = false;
					track.keepDownStateOnRollOut = true;
					track.backgroundSkin = trackSkin;
					toggle.trackSkin = track;
				}
				if (toggle.thumbSkin == null) {
					var thumbSkin = new CircleSkin();
					thumbSkin.width = 32.0;
					thumbSkin.height = 32.0;
					thumbSkin.minWidth = 32.0;
					thumbSkin.minHeight = 32.0;
					thumbSkin.border = theme.getBorder();
					thumbSkin.disabledBorder = theme.getBorder();
					thumbSkin.fill = theme.getButtonFill();
					thumbSkin.disabledFill = theme.getButtonDisabledFill();

					var thumb = new BasicToggleButton();
					thumb.toggleable = false;
					thumb.keepDownStateOnRollOut = true;
					thumb.backgroundSkin = thumbSkin;
					toggle.thumbSkin = thumb;
				}
				if (toggle.focusRectSkin == null) {
					var focusRectSkin = new RectangleSkin();
					focusRectSkin.fill = null;
					focusRectSkin.border = theme.getFocusBorder();
					focusRectSkin.cornerRadius = 16.0;
					toggle.focusRectSkin = focusRectSkin;
				}
			});
		}
	}
}
