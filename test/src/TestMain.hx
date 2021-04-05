import openfl.display.Sprite;
import utest.Runner;
import utest.ui.common.PackageResult;
import utest.ui.common.ResultAggregator;
import utest.ui.text.HtmlReport;

class TestMain extends Sprite {
	public static var openfl_root:Sprite;

	public function new() {
		super();

		openfl_root = this;

		var runner = new Runner();
		runner.addCase(new feathers.controls.AssetLoaderTest());
		runner.addCase(new feathers.controls.BasicButtonMeasurementTest());
		runner.addCase(new feathers.controls.BasicButtonTest());
		runner.addCase(new feathers.controls.BasicToggleButtonTest());
		runner.addCase(new feathers.controls.ButtonTest());
		runner.addCase(new feathers.controls.GridViewTest());
		runner.addCase(new feathers.controls.GroupListViewTest());
		runner.addCase(new feathers.controls.HProgressBarTest());
		runner.addCase(new feathers.controls.HScrollBarTest());
		runner.addCase(new feathers.controls.HSliderTest());
		runner.addCase(new feathers.controls.LabelTest());
		runner.addCase(new feathers.controls.LayoutGroupTest());
		runner.addCase(new feathers.controls.ListViewTest());
		runner.addCase(new feathers.controls.navigators.StackNavigatorTest());
		runner.addCase(new feathers.controls.ScrollContainerTest());
		runner.addCase(new feathers.controls.TabBarTest());
		runner.addCase(new feathers.controls.TextInputTest());
		runner.addCase(new feathers.controls.ToggleButtonTest());
		runner.addCase(new feathers.controls.ToggleSwitchTest());
		runner.addCase(new feathers.controls.TreeViewTest());
		runner.addCase(new feathers.controls.VScrollBarTest());
		runner.addCase(new feathers.controls.VSliderTest());
		runner.addCase(new feathers.core.ComponentLifecycleTest());
		runner.addCase(new feathers.core.DefaultPopUpManagerTest());
		runner.addCase(new feathers.core.InvalidationTest());
		runner.addCase(new feathers.core.MinAndMaxDimensionsTest());
		runner.addCase(new feathers.core.PopUpManagerTest());
		runner.addCase(new feathers.core.RestrictedStyleTest());
		runner.addCase(new feathers.core.ScaleTest());
		runner.addCase(new feathers.data.ArrayCollectionTest());
		runner.addCase(new feathers.data.ArrayHierarchicalCollectionTest());
		runner.addCase(new feathers.data.TreeCollectionTest());
		runner.addCase(new feathers.layout.AnchorLayoutTest());
		runner.addCase(new feathers.layout.HorizontalLayoutTest());
		runner.addCase(new feathers.layout.MeasurementsTest());
		runner.addCase(new feathers.layout.VerticalLayoutTest());
		runner.addCase(new feathers.style.ClassVariantStyleProviderTest());
		runner.addCase(new feathers.style.FunctionStyleProviderTest());
		runner.addCase(new feathers.style.StyleProviderAndVariantTest());
		runner.addCase(new feathers.style.StyleProviderRestrictedStyleTest());
		runner.addCase(new feathers.style.ThemeTest());
		runner.addCase(new feathers.themes.DefaultThemeTest());
		#if js
		if(#if (haxe_ver >= 4.0) js.Syntax.code #else untyped __js__ #end("typeof window != 'undefined'")) {
			new HtmlReport(runner, true);
		} else {
			new NoExitPrintReport(runner);
		}
		#else
		new NoExitPrintReport(runner);
		#end
		var aggregator = new ResultAggregator(runner, true);
		aggregator.onComplete.add(aggregator_onComplete);
		runner.run();
	}

	private function aggregator_onComplete(result:PackageResult):Void {
		var stats = result.stats;
		var exitCode = stats.isOk ? 0 : 1;
		var message = 'Successes: ${stats.successes}, Failures: ${stats.failures}, Errors: ${stats.errors}, Warnings: ${stats.warnings}, Skipped: ${stats.ignores}';
		#if html5
		if (exitCode == 0) {
			js.html.Console.info(message);
		} else {
			js.html.Console.error(message);
		}
		#else
		trace(message);
		#end

		#if sys
		Sys.exit(exitCode);
		#elseif html5
		// cast(js.Lib.global, js.html.Window).close();
		#elseif air
		flash.desktop.NativeApplication.nativeApplication.exit(exitCode);
		#elseif flash
		if (flash.system.Security.sandboxType == "localTrusted") {
			flash.system.System.exit(exitCode);
		} else {
			flash.Lib.fscommand("quit");
		}
		#end
	}
}
