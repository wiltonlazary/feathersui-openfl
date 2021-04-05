package com.feathersui.components.views;

import feathers.controls.Button;
import feathers.controls.Check;
import feathers.controls.Header;
import feathers.controls.Panel;
import feathers.events.TriggerEvent;
import feathers.layout.VerticalLayout;
import openfl.events.Event;

class CheckScreen extends Panel {
	private var check:Check;
	private var selectedCheck:Check;
	private var disabledCheck:Check;
	private var selectedDisabledCheck:Check;

	override private function initialize():Void {
		super.initialize();
		this.createHeader();

		var layout = new VerticalLayout();
		layout.horizontalAlign = CENTER;
		layout.verticalAlign = MIDDLE;
		layout.gap = 20.0;
		this.layout = layout;

		this.check = new Check();
		this.check.text = "Check";
		this.check.addEventListener(Event.CHANGE, check_changeHandler);
		this.addChild(this.check);

		this.selectedCheck = new Check();
		this.selectedCheck.text = "Selected Check";
		this.selectedCheck.selected = true;
		this.addChild(this.selectedCheck);

		this.disabledCheck = new Check();
		this.disabledCheck.text = "Disabled Check";
		this.disabledCheck.enabled = false;
		this.addChild(this.disabledCheck);

		this.selectedDisabledCheck = new Check();
		this.selectedDisabledCheck.text = "Selected & Disabled Check";
		this.selectedDisabledCheck.selected = true;
		this.selectedDisabledCheck.enabled = false;
		this.addChild(this.selectedDisabledCheck);
	}

	private function createHeader():Void {
		var header = new Header();
		header.text = "Check";
		this.header = header;

		var backButton = new Button();
		backButton.text = "Back";
		backButton.addEventListener(TriggerEvent.TRIGGER, backButton_triggerHandler);
		header.leftView = backButton;
	}

	private function check_changeHandler(event:Event):Void {
		trace("Check selected change: " + this.check.selected);
	}

	private function backButton_triggerHandler(event:TriggerEvent):Void {
		this.dispatchEvent(new Event(Event.COMPLETE));
	}
}
