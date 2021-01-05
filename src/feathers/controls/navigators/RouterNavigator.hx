/*
	Feathers UI
	Copyright 2020 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */

package feathers.controls.navigators;

import feathers.motion.effects.IEffectContext;
import feathers.themes.steel.components.SteelRouterNavigatorStyles;
import openfl.display.DisplayObject;
import openfl.events.Event;
#if html5
import js.Lib;
import js.html.Window;
#else
import lime.ui.KeyCode;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
#end

/**
	Integrates with the HTML5 history API to allow navigation between views,
	including support for the browser's native back and forward buttons.

	This component is designed for use in web browsers, but provides a decent
	implementation for native apps. Ideally, native apps should use
	`StackNavigator` instead, as it provides more advanced navigation
	capabilities that are impossible to integrate with the HTML5 history API.

	@see [Tutorial: How to use the RouterNavigator component](https://feathersui.com/learn/haxe-openfl/router-navigator/)
	@see `feathers.controls.navigators.Route`
	@see `feathers.controls.navigators.RouterAction`
	@see `feathers.controls.navigators.RouterNavigator`

	@since 1.0.0
**/
@:access(feathers.controls.navigators.Route)
@:styleContext
class RouterNavigator extends BaseNavigator {
	/**
		Creates a new `RouterNavigator` object.

		@since 1.0.0
	**/
	public function new() {
		initializeRouterNavigatorTheme();
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, routerNavigator_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, routerNavigator_removedFromStageHandler);
	}

	#if html5
	private var htmlWindow:Window;
	#else
	private var _history:Array<HistoryItem> = [];
	private var _forwardHistory:Array<HistoryItem> = [];
	#end

	/**
		The base URL path where the project will be deployed.

		For example, if your project will be deployed to
		`https://www.example.com/my-project/`, the base path will be
		`/my-project`.

		@since 1.0.0
	**/
	public var basePath:String = null;

	/**
		The default transition to use for forward navigation actions.

		@see `StackNavigator.backTransition`

		@since 1.0.0
	**/
	@:style
	public var forwardTransition:(DisplayObject, DisplayObject) -> IEffectContext = null;

	/**
		The default transition to use for back navigation actions.

		@see `StackNavigator.forwardTransition`

		@since 1.0.0
	**/
	@:style
	public var backTransition:(DisplayObject, DisplayObject) -> IEffectContext = null;

	/**
		The default transition to use for replace navigation actions.

		@since 1.0.0
	**/
	@:style
	public var replaceTransition:(DisplayObject, DisplayObject) -> IEffectContext = null;

	private function initializeRouterNavigatorTheme():Void {
		SteelRouterNavigatorStyles.initialize();
	}

	/**
		Adds a route to the navigator.

		The following example adds a new route for the "/settings" URL path:

		```hx
		var route = Route.withClass("/settings", SettingsView);
		navigator.addRoute(route);
		```

		@since 1.0.0
	**/
	public function addRoute(route:Route):Void {
		this.addItemInternal(route.path, route);
		if (this.stage != null && this.activeItemView == null) {
			var matched = this.matchRoute();
			if (matched == route) {
				this.showItemInternal(matched.path, null);
			}
		}
	}

	/**
		Pushes a new entry onto the history stack. The route to display will be
		determined automatically.

		The following example navigates to the "/settings" URL path:

		```hx
		navigator.push("/settings");
		```

		@see `feathers.controls.navigators.Route.path`

		@since 1.0.0
	**/
	public function push(path:String, ?state:Dynamic, ?transition:(DisplayObject, DisplayObject) -> IEffectContext):DisplayObject {
		#if html5
		if (this.basePath != null && !StringTools.startsWith(path, this.basePath + "/")) {
			var needsSlash = !StringTools.startsWith(path, "/");
			path = this.basePath + (needsSlash ? "/" : "") + path;
		}
		this.htmlWindow.history.pushState(state, null, path);
		#else
		this._history.push(new HistoryItem(Location.fromString(path), state));
		this._forwardHistory.resize(0);
		#end
		if (transition == null) {
			transition = this.forwardTransition;
		}
		return this.matchRouteAndShow(transition);
	}

	/**
		Replaces the current entry onto the history stack. The route to display
		will be determined automatically.

		The following example navigates to the "/settings" URL path without
		adding a new history entry:

		```hx
		navigator.replace("/settings");
		```

		@see `feathers.controls.navigators.Route.path`

		@since 1.0.0
	**/
	public function replace(path:String, ?state:Dynamic, ?transition:(DisplayObject, DisplayObject) -> IEffectContext):DisplayObject {
		#if html5
		if (this.basePath != null && !StringTools.startsWith(path, this.basePath + "/")) {
			var needsSlash = !StringTools.startsWith(path, "/");
			path = this.basePath + (needsSlash ? "/" : "") + path;
		}
		this.htmlWindow.history.replaceState(state, null, path);
		#else
		this._history[this._history.length - 1] = new HistoryItem(Location.fromString(path), state);
		this._forwardHistory.resize(0);
		#end
		if (transition == null) {
			transition = this.replaceTransition;
		}
		return this.matchRouteAndShow(transition);
	}

	/**
		Moves the pointer in the history stack by _n_ entries.

		The following examples goes back 2 entries in the history stack.

		```hx
		navigator.go(-2);
		```

		@since 1.0.0
	**/
	public function go(n:Int, ?transition:(DisplayObject, DisplayObject) -> IEffectContext):DisplayObject {
		if (n == 0) {
			return this.activeItemView;
		}
		#if html5
		this.htmlWindow.history.go(n);
		#else
		if (n > 0) {
			for (i in 0...Std.int(Math.min(n, this._forwardHistory.length))) {
				var item = this._forwardHistory.shift();
				this._history.push(item);
			}
		} else {
			for (i in 0...Std.int(Math.min(-n, this._history.length))) {
				var item = this._history.pop();
				this._forwardHistory.unshift(item);
			}
		}
		#end
		if (transition == null) {
			transition = (n < 0) ? this.backTransition : this.forwardTransition;
		}
		return this.matchRouteAndShow(transition);
	}

	/**
		Navigates to the previous item on the history stack.

		The following examples goes back in history by 1 entry.

		```hx
		navigator.goBack();
		```

		@since 1.0.0
	**/
	public function goBack(?transition:(DisplayObject, DisplayObject) -> IEffectContext):DisplayObject {
		return this.go(-1, transition);
	}

	/**
		Navigates to the next item on the history stack.

		The following examples goes forward in history by 1 entry.

		```hx
		navigator.goForward();
		```

		@since 1.0.0
	**/
	public function goForward(?transition:(DisplayObject, DisplayObject) -> IEffectContext):DisplayObject {
		return this.go(1, transition);
	}

	private function routerNavigator_addedToStageHandler(event:Event):Void {
		#if html5
		this.htmlWindow = cast(Lib.global, js.html.Window);
		this.htmlWindow.addEventListener("popstate", htmlWindow_popstateHandler);
		#else
		this.stage.addEventListener(KeyboardEvent.KEY_UP, routerNavigator_stage_keyUpHandler, false, 0, true);
		#end
		this.matchRouteAndShow(null);
	}

	/**
		Returns the current location.

		@since 1.0.0
	**/
	public var location(get, never):#if html5 js.html.Location #else Location #end;

	private function get_location():#if html5 js.html.Location #else Location #end {
		#if html5
		return this.htmlWindow.location;
		#else
		if (this._history.length > 0) {
			return this._history[this._history.length - 1].location;
		}
		return new Location("/");
		#end
	}

	private function matchRoute():Route {
		#if html5
		var pathname = this.htmlWindow.location.pathname;
		if (this.basePath != null && StringTools.startsWith(pathname, this.basePath + "/")) {
			pathname = pathname.substr(this.basePath.length);
		}
		#else
		var pathname = "/";
		if (this._history.length > 0) {
			var item = this._history[this._history.length - 1];
			pathname = item.location.pathname;
		}
		#end
		pathname = pathname.toLowerCase();
		for (path => route in this._addedItems) {
			path = path.toLowerCase();
			if (pathname == path) {
				return cast(route, Route);
			}
			if (path == "*") {
				return cast(route, Route);
			}
		}
		return null;
	}

	private function matchRouteAndShow(transition:(DisplayObject, DisplayObject) -> IEffectContext):DisplayObject {
		var matched = this.matchRoute();
		if (matched != null) {
			return this.showItemInternal(matched.path, transition);
		}
		this.clearActiveItemInternal(null);
		return null;
	}

	override private function getView(id:String):DisplayObject {
		var item = cast(this._addedItems.get(id), Route);
		var view = item.getView(this);
		if (item.injectState != null) {
			#if html5
			var state = this.htmlWindow.history.state;
			#else
			var state = null;
			if (this._history.length > 0) {
				var historyItem = this._history[this._history.length - 1];
				state = historyItem.state;
			}
			#end
			item.injectState(view, state);
		}
		return view;
	}

	override private function disposeView(id:String, view:DisplayObject):Void {
		var item = cast(this._addedItems.get(id), Route);
		item.returnView(view);
	}

	private function routerNavigator_removedFromStageHandler(event:Event):Void {
		#if html5
		if (this.htmlWindow != null) {
			this.htmlWindow.removeEventListener("popstate", htmlWindow_popstateHandler);
			this.htmlWindow = null;
		}
		#else
		this.stage.removeEventListener(KeyboardEvent.KEY_UP, routerNavigator_stage_keyUpHandler);
		#end
	}

	#if html5
	private function htmlWindow_popstateHandler(event:js.html.PopStateEvent):Void {
		event.preventDefault();
		// there's no good way to determine if we went forward or back
		// so it may be better not to use a transition in this case
		this.matchRouteAndShow(null);
	}
	#else
	private function routerNavigator_stage_keyUpHandler(event:KeyboardEvent):Void {
		if (!this._enabled) {
			return;
		}
		switch (event.keyCode) {
			#if flash
			case Keyboard.BACK:
				{
					this.routerNavigator_stage_backKeyUpHandler(event);
				}
			#end
			case KeyCode.APP_CONTROL_BACK:
				{
					this.routerNavigator_stage_backKeyUpHandler(event);
				}
		}
	}

	private function routerNavigator_stage_backKeyUpHandler(event:Event):Void {
		if (event.isDefaultPrevented()) {
			return;
		}
		if (this._history.length < 1) {
			// can't go back
			return;
		}
		event.preventDefault();
		var item = this._history.pop();
		this._forwardHistory.unshift(item);
		this.matchRouteAndShow(this.backTransition);
	}
	#end
}

#if !html5
private class HistoryItem {
	public function new(location:Location, state:Dynamic) {
		this.location = location;
		this.state = state;
	}

	public var location:Location;
	public var state:Dynamic;
}

class Location {
	public static function fromString(value:String):Location {
		var pathname = value;
		var search = "";
		var hash = "";
		var splitWithHash = pathname.split("#");
		pathname = splitWithHash[0];
		if (splitWithHash.length > 1) {
			hash = splitWithHash[1];
		}
		var splitWithSearch = pathname.split("?");
		pathname = splitWithSearch[0];
		if (splitWithSearch.length > 1) {
			search = splitWithSearch[1];
		}
		return new Location(pathname, search, hash);
	}

	public function new(pathname:String, search:String = "", hash:String = "") {
		this._pathname = pathname;
		this._search = search;
		this._hash = hash;
	}

	private var _protocol:String = "file:";

	@:flash.property
	public var protocol(get, null):String;

	public function get_protocol():String {
		return this._protocol;
	}

	private var _hostname:String = ".";

	@:flash.property
	public var hostname(get, null):String;

	public function get_hostname():String {
		return ".";
	}

	@:flash.property
	public var host(get, null):String;

	public function get_host():String {
		return this.hostname;
	}

	@:flash.property
	public var port(get, null):String;

	public function get_port():String {
		return "";
	}

	@:flash.property
	public var origin(get, never):String;

	public function get_origin():String {
		return this._protocol + "//" + this._hostname;
	}

	private var _pathname:String = "/";

	@:flash.property
	public var pathname(get, never):String;

	public function get_pathname():String {
		return this._pathname;
	}

	private var _search:String = "";

	@:flash.property
	public var search(get, never):String;

	public function get_search():String {
		return this._search;
	}

	private var _hash:String = "";

	@:flash.property
	public var hash(get, never):String;

	public function get_hash():String {
		return this._hash;
	}

	@:flash.property
	public var href(get, never):String;

	public function get_href():String {
		return this.origin + this.pathname + this.search + this.hash;
	}
}
#end
