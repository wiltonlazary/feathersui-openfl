import feathers.controls.ButtonState;
import feathers.themes.ClassVariantTheme;
import openfl.text.TextFormat;
import openfl.display.GradientType;
import feathers.skins.RectangleSkin;
import feathers.controls.Button;

class CustomTheme extends ClassVariantTheme {
	public static final VARIANT_FANCY_BUTTON:String = "custom-fancy-button";

	public function new() {
		super();

		// to provide default styles, pass null for the variant
		this.styleProvider.setStyleFunction(Button, null, setButtonStyles);

		// custom themes may provide their own unique variants
		this.styleProvider.setStyleFunction(Button, VARIANT_FANCY_BUTTON, setFancyButtonStyles);
	}

	private function setButtonStyles(button:Button):Void {
		var backgroundSkin = new RectangleSkin();
		backgroundSkin.border = SolidColor(1.0, 0xff0000);
		backgroundSkin.setBorderForState(DOWN, SolidColor(1.0, 0xcc0000));
		backgroundSkin.fill = SolidColor(0xffffff);
		backgroundSkin.setFillForState(DOWN, SolidColor(0xffeeee));
		backgroundSkin.cornerRadius = 10.0;
		button.backgroundSkin = backgroundSkin;

		var format = new TextFormat("_sans", 16, 0xff0000);
		button.textFormat = format;

		var downFormat = new TextFormat("_sans", 16, 0xcc0000);
		button.setTextFormatForState(DOWN, downFormat);

		button.paddingTop = 10.0;
		button.paddingBottom = 10.0;
		button.paddingLeft = 20.0;
		button.paddingRight = 20.0;
	}

	private function setFancyButtonStyles(button:Button):Void {
		var backgroundSkin = new RectangleSkin();
		backgroundSkin.cornerRadius = 10.0;
		backgroundSkin.border = Gradient(2, LINEAR, [0xff9999, 0xcc0000], [1.0, 1.0], [0, 255], 90 * Math.PI / 180);
		backgroundSkin.setBorderForState(DOWN, Gradient(2, LINEAR, [0xff0000, 0xcc0000], [1.0, 1.0], [0, 255], 90 * Math.PI / 180));
		backgroundSkin.fill = Gradient(LINEAR, [0xff9999, 0xff0000], [1.0, 1.0], [0, 255], 90 * Math.PI / 180);
		backgroundSkin.setFillForState(DOWN, Gradient(LINEAR, [0xff9999, 0xff0000], [1.0, 1.0], [0, 255], 270 * Math.PI / 180));
		button.backgroundSkin = backgroundSkin;

		var format = new TextFormat("_sans", 20, 0xffeeee, true, true);
		button.textFormat = format;

		button.paddingTop = 10.0;
		button.paddingBottom = 10.0;
		button.paddingLeft = 20.0;
		button.paddingRight = 20.0;
	}
}
