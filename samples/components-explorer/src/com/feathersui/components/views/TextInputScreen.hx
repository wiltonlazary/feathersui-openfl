package com.feathersui.components.views;

import feathers.layout.VerticalLayout;
import feathers.controls.Button;
import feathers.controls.Label;
import feathers.controls.LayoutGroup;
import feathers.controls.Panel;
import feathers.controls.TextInput;
import feathers.events.TriggerEvent;
import feathers.layout.AnchorLayout;
import feathers.layout.AnchorLayoutData;
import openfl.events.Event;

class TextInputScreen extends Panel {
	private var textInput:TextInput;
	private var textInputWithPrompt:TextInput;
	private var searchTextInput:TextInput;
	private var disabledTextInput:TextInput;

	override private function initialize():Void {
		super.initialize();
		this.createHeader();

		var layout = new VerticalLayout();
		layout.horizontalAlign = CENTER;
		layout.verticalAlign = MIDDLE;
		layout.gap = 20.0;
		this.layout = layout;

		this.textInput = new TextInput();
		this.textInput.text = "";
		this.addChild(this.textInput);

		this.textInputWithPrompt = new TextInput();
		this.textInputWithPrompt.prompt = "An optional prompt";
		this.addChild(this.textInputWithPrompt);

		this.searchTextInput = new TextInput();
		this.searchTextInput.variant = TextInput.VARIANT_SEARCH;
		this.searchTextInput.prompt = "Search";
		this.addChild(this.searchTextInput);

		this.disabledTextInput = new TextInput();
		this.disabledTextInput.enabled = false;
		this.disabledTextInput.text = "Disabled text input";
		this.addChild(this.disabledTextInput);
	}

	private function createHeader():Void {
		var header = new LayoutGroup();
		header.variant = LayoutGroup.VARIANT_TOOL_BAR;
		header.layout = new AnchorLayout();
		this.header = header;

		var headerTitle = new Label();
		headerTitle.variant = Label.VARIANT_HEADING;
		headerTitle.text = "Text Input";
		headerTitle.layoutData = AnchorLayoutData.center();
		header.addChild(headerTitle);

		var backButton = new Button();
		backButton.text = "Back";
		backButton.layoutData = AnchorLayoutData.middleLeft(0.0, 10.0);
		backButton.addEventListener(TriggerEvent.TRIGGER, backButton_triggerHandler);
		header.addChild(backButton);
	}

	private function backButton_triggerHandler(event:TriggerEvent):Void {
		this.dispatchEvent(new Event(Event.COMPLETE));
	}
}
