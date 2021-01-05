import com.feathersui.components.ViewPaths;
import com.feathersui.components.views.AssetLoaderScreen;
import com.feathersui.components.views.ButtonScreen;
import com.feathersui.components.views.CalloutScreen;
import com.feathersui.components.views.CheckScreen;
import com.feathersui.components.views.ComboBoxScreen;
import com.feathersui.components.views.DrawerScreen;
import com.feathersui.components.views.GridViewScreen;
import com.feathersui.components.views.GroupListViewScreen;
import com.feathersui.components.views.HDividedBoxScreen;
import com.feathersui.components.views.LabelScreen;
import com.feathersui.components.views.ListViewScreen;
import com.feathersui.components.views.MainMenu;
import com.feathersui.components.views.PageIndicatorScreen;
import com.feathersui.components.views.PageNavigatorScreen;
import com.feathersui.components.views.PanelScreen;
import com.feathersui.components.views.PopUpListViewScreen;
import com.feathersui.components.views.PopUpManagerScreen;
import com.feathersui.components.views.ProgressBarScreen;
import com.feathersui.components.views.RadioScreen;
import com.feathersui.components.views.SliderScreen;
import com.feathersui.components.views.TabBarScreen;
import com.feathersui.components.views.TabNavigatorScreen;
import com.feathersui.components.views.TextAreaScreen;
import com.feathersui.components.views.TextCalloutScreen;
import com.feathersui.components.views.TextInputScreen;
import com.feathersui.components.views.ToggleSwitchScreen;
import com.feathersui.components.views.TreeViewScreen;
import com.feathersui.components.views.VDividedBoxScreen;
import feathers.controls.Application;
import feathers.controls.navigators.Route;
import feathers.controls.navigators.RouterAction;
import feathers.controls.navigators.RouterNavigator;
import openfl.events.Event;

class Main extends Application {
	public function new() {
		super();
	}

	private var _navigator:RouterNavigator;

	override private function initialize():Void {
		this._navigator = new RouterNavigator();
		#if feathersui.com
		// to build for the feathersui.com website, run the following command:
		// haxelib run openfl build html5 -final --haxedef=feathersui.com
		this._navigator.basePath = "/samples/haxe-openfl/components-explorer";
		#end
		this.addChild(this._navigator);

		var mainMenu = Route.withClass(ViewPaths.MAIN_MENU, MainMenu, [Event.CHANGE => NewAction(createPushPathAction)]);
		this._navigator.addRoute(mainMenu);

		var assetLoader = Route.withClass(ViewPaths.ASSET_LOADER, AssetLoaderScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(assetLoader);

		var button = Route.withClass(ViewPaths.BUTTON, ButtonScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(button);

		var callout = Route.withClass(ViewPaths.CALLOUT, CalloutScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(callout);

		var check = Route.withClass(ViewPaths.CHECK, CheckScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(check);

		var comboBox = Route.withClass(ViewPaths.COMBO_BOX, ComboBoxScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(comboBox);

		var hDividedBox = Route.withClass(ViewPaths.HORIZONTAL_DIVIDED_BOX, HDividedBoxScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(hDividedBox);

		var vDividedBox = Route.withClass(ViewPaths.VERTICAL_DIVIDED_BOX, VDividedBoxScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(vDividedBox);

		var drawer = Route.withClass(ViewPaths.DRAWER, DrawerScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(drawer);

		var gridView = Route.withClass(ViewPaths.GRID_VIEW, GridViewScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(gridView);

		var groupListView = Route.withClass(ViewPaths.GROUP_LIST_VIEW, GroupListViewScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(groupListView);

		var label = Route.withClass(ViewPaths.LABEL, LabelScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(label);

		var listView = Route.withClass(ViewPaths.LIST_VIEW, ListViewScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(listView);

		var pageIndicator = Route.withClass(ViewPaths.PAGE_INDICATOR, PageIndicatorScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(pageIndicator);

		var pageNavigator = Route.withClass(ViewPaths.PAGE_NAVIGATOR, PageNavigatorScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(pageNavigator);

		var panel = Route.withClass(ViewPaths.PANEL, PanelScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(panel);

		var popUpListView = Route.withClass(ViewPaths.POP_UP_LIST_VIEW, PopUpListViewScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(popUpListView);

		var popUpManager = Route.withClass(ViewPaths.POP_UP_MANAGER, PopUpManagerScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(popUpManager);

		var progressBar = Route.withClass(ViewPaths.PROGRESS_BAR, ProgressBarScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(progressBar);

		var radio = Route.withClass(ViewPaths.RADIO, RadioScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(radio);

		var slider = Route.withClass(ViewPaths.SLIDER, SliderScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(slider);

		var tabBar = Route.withClass(ViewPaths.TAB_BAR, TabBarScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(tabBar);

		var tabNavigator = Route.withClass(ViewPaths.TAB_NAVIGATOR, TabNavigatorScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(tabNavigator);

		var textArea = Route.withClass(ViewPaths.TEXT_AREA, TextAreaScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(textArea);

		var textCallout = Route.withClass(ViewPaths.TEXT_CALLOUT, TextCalloutScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(textCallout);

		var textInput = Route.withClass(ViewPaths.TEXT_INPUT, TextInputScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(textInput);

		var toggleSwitch = Route.withClass(ViewPaths.TOGGLE_SWITCH, ToggleSwitchScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(toggleSwitch);

		var treeView = Route.withClass(ViewPaths.TREE_VIEW, TreeViewScreen, [Event.COMPLETE => createBackAction(ViewPaths.MAIN_MENU)]);
		this._navigator.addRoute(treeView);
	}

	private function createPushPathAction(event:Event):RouterAction {
		var screen = cast(event.currentTarget, MainMenu);
		return Push(screen.selectedViewPaths);
	}

	private function createBackAction(path:String):RouterAction {
		#if html5
		// on the web, links generally always go forward in history, even if
		// that doesn't match the direction of the navigation hierarchy
		return Push(path, null, this._navigator.backTransition);
		#else
		// on other platforms, back goes back.
		// this may return to a different path than the parameter specifies
		return GoBack();
		#end
	}
}
