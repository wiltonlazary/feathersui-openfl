/*
	Feathers UI
	Copyright 2021 Bowler Hat LLC. All Rights Reserved.

	This program is free software. You can redistribute and/or modify it in
	accordance with the terms of the accompanying license agreement.
 */
 package feathers.data;

 import openfl.errors.RangeError;
 import haxe.io.Error;
 import utest.Assert;
 import utest.Test;
 import feathers.events.HierarchicalCollectionEvent;
 import openfl.events.Event;
 
 @:keep class ArrayHierarchicalCollectionTest extends Test {
	 private var _collection:ArrayHierarchicalCollection<MockItem>;
	 private var _1:MockItem;
	 private var _2:MockItem;
	 private var _3:MockItem;
	 private var _4:MockItem;
	 private var _5:MockItem;
	 private var _1a:MockItem;
	 private var _1b:MockItem;
	 private var _1c:MockItem;
 
	 public function new() {
		 super();
	 }
 
	 public function setup():Void {
		 this._1a = new MockItem("1-A");
		 this._1b = new MockItem("1-B", [new MockItem("1-B-I")]);
		 this._1c = new MockItem("1-C");
		 this._1 = new MockItem("1", [this._1a, this._1b, this._1c]);
		 this._2 = new MockItem("2", [new MockItem("2-A")]);
		 this._3 = new MockItem("3");
		 this._4 = new MockItem("4", [new MockItem("4-A"), new MockItem("4-B")]);
		 this._5 = new MockItem("5", []);
		 this._collection = new ArrayHierarchicalCollection([this._1, this._2, this._3, this._4, this._5], (item:MockItem) -> item.children);
	 }
 
	 public function teardown():Void {
		 this._collection = null;
	 }
 
	 public function testLength():Void {
		 Assert.equals(5, this._collection.getLength(), "Collection getLength() returns wrong length");
		 Assert.equals(5, this._collection.getLength([]), "Collection getLength() returns wrong length");
		 Assert.equals(3, this._collection.getLength([0]), "Collection getLength() returns wrong length");
		 Assert.equals(1, this._collection.getLength([1]), "Collection getLength() returns wrong length");
		 Assert.equals(0, this._collection.getLength([4]), "Collection getLength() returns wrong length");
		 Assert.equals(1, this._collection.getLength([0, 1]), "Collection getLength() returns wrong length");
	 }
 
	 public function testLocationOf():Void {
		 Assert.equals(1, this._collection.locationOf(this._1).length, "Collection locationOf() returns wrong location");
		 Assert.equals(0, this._collection.locationOf(this._1)[0], "Collection locationOf() returns wrong location");
		 Assert.equals(2, this._collection.locationOf(this._1a).length, "Collection locationOf() returns wrong location");
		 Assert.equals(0, this._collection.locationOf(this._1a)[0], "Collection locationOf() returns wrong location");
		 Assert.equals(0, this._collection.locationOf(this._1a)[1], "Collection locationOf() returns wrong location");
		 Assert.equals(2, this._collection.locationOf(this._1b).length, "Collection locationOf() returns wrong location");
		 Assert.equals(0, this._collection.locationOf(this._1b)[0], "Collection locationOf() returns wrong location");
		 Assert.equals(1, this._collection.locationOf(this._1b)[1], "Collection locationOf() returns wrong location");
		 Assert.equals(2, this._collection.locationOf(this._1c).length, "Collection locationOf() returns wrong location");
		 Assert.equals(0, this._collection.locationOf(this._1c)[0], "Collection locationOf() returns wrong location");
		 Assert.equals(2, this._collection.locationOf(this._1c)[1], "Collection locationOf() returns wrong location");
		 Assert.equals(1, this._collection.locationOf(this._2).length, "Collection locationOf() returns wrong location");
		 Assert.equals(1, this._collection.locationOf(this._2)[0], "Collection locationOf() returns wrong location");
		 Assert.equals(1, this._collection.locationOf(this._3).length, "Collection locationOf() returns wrong location");
		 Assert.equals(2, this._collection.locationOf(this._3)[0], "Collection locationOf() returns wrong location");
		 Assert.equals(1, this._collection.locationOf(this._4).length, "Collection locationOf() returns wrong location");
		 Assert.equals(3, this._collection.locationOf(this._4)[0], "Collection locationOf() returns wrong location");
		 Assert.equals(1, this._collection.locationOf(this._5).length, "Collection locationOf() returns wrong location");
		 Assert.equals(4, this._collection.locationOf(this._5)[0], "Collection locationOf() returns wrong location");
		 Assert.isNull(this._collection.locationOf(new MockItem("Not in collection")),
			 "Collection locationOf() must return null for items not in collection");
	 }
 
	 public function testContains():Void {
		 Assert.isTrue(this._collection.contains(this._1), "Collection contains() returns wrong result for item in collection");
		 Assert.isTrue(this._collection.contains(this._1a), "Collection contains() returns wrong result for item in collection");
		 Assert.isTrue(this._collection.contains(this._1b), "Collection contains() returns wrong result for item in collection");
		 Assert.isTrue(this._collection.contains(this._1c), "Collection contains() returns wrong result for item in collection");
		 Assert.isTrue(this._collection.contains(this._2), "Collection contains() returns wrong result for item in collection");
		 Assert.isTrue(this._collection.contains(this._3), "Collection contains() returns wrong result for item in collection");
		 Assert.isTrue(this._collection.contains(this._4), "Collection contains() returns wrong result for item in collection");
		 Assert.isFalse(this._collection.contains(new MockItem("Not in collection")),
			 "Collection contains() returns wrong result for item not in collection");
	 }
 
	 public function testGet():Void {
		 Assert.equals(this._1, this._collection.get([0]), "Collection get() returns wrong item");
		 Assert.equals(this._1a, this._collection.get([0, 0]), "Collection get() returns wrong item");
		 Assert.equals(this._1b, this._collection.get([0, 1]), "Collection get() returns wrong item");
		 Assert.equals(this._1c, this._collection.get([0, 2]), "Collection get() returns wrong item");
		 Assert.equals(this._2, this._collection.get([1]), "Collection get() returns wrong item");
		 Assert.equals(this._3, this._collection.get([2]), "Collection get() returns wrong item");
		 Assert.equals(this._4, this._collection.get([3]), "Collection get() returns wrong item");
		 Assert.equals(this._5, this._collection.get([4]), "Collection get() returns wrong item");
		 Assert.raises(function() {
			 this._collection.get(null);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.get([100]);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.get([-1]);
		 }, RangeError);
	 }
 
	 public function testAddAt():Void {
		 var itemToAdd = new MockItem("New Item");
		 var originalLength = this._collection.getLength([0]);
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var addItemEvent = false;
		 var locationFromEvent:Array<Int> = null;
		 this._collection.addEventListener(HierarchicalCollectionEvent.ADD_ITEM, function(event:HierarchicalCollectionEvent):Void {
			 addItemEvent = true;
			 locationFromEvent = event.location;
		 });
		 this._collection.addAt(itemToAdd, [0, 1]);
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after adding to collection");
		 Assert.isTrue(addItemEvent, "HierarchicalCollectionEvent.ADD_ITEM must be dispatched after adding to collection");
		 Assert.equals(originalLength + 1, this._collection.getLength([0]), "Collection length must change after adding to collection");
		 Assert.equals(2, this._collection.locationOf(itemToAdd).length, "Adding item to collection returns incorrect location");
		 Assert.equals(0, this._collection.locationOf(itemToAdd)[0], "Adding item to collection returns incorrect location");
		 Assert.equals(1, this._collection.locationOf(itemToAdd)[1], "Adding item to collection returns incorrect location");
		 Assert.equals(2, locationFromEvent.length, "Adding item to collection returns incorrect location in event");
		 Assert.equals(0, locationFromEvent[0], "Adding item to collection returns incorrect location in event");
		 Assert.equals(1, locationFromEvent[1], "Adding item to collection returns incorrect location in event");
 
		 Assert.raises(function() {
			 this._collection.addAt(itemToAdd, null);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.addAt(itemToAdd, [100]);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.addAt(itemToAdd, [-1]);
		 }, RangeError);
	 }
 
	 public function testAddAtEndOfBranch():Void {
		 var itemToAdd = new MockItem("New Item");
		 var originalLength = this._collection.getLength([0]);
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var addItemEvent = false;
		 var locationFromEvent:Array<Int> = null;
		 this._collection.addEventListener(HierarchicalCollectionEvent.ADD_ITEM, function(event:HierarchicalCollectionEvent):Void {
			 addItemEvent = true;
			 locationFromEvent = event.location;
		 });
		 this._collection.addAt(itemToAdd, [0, originalLength]);
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after adding to collection");
		 Assert.isTrue(addItemEvent, "HierarchicalCollectionEvent.ADD_ITEM must be dispatched after adding to collection");
		 Assert.equals(originalLength + 1, this._collection.getLength([0]), "Collection length must change after adding to collection");
		 Assert.equals(2, this._collection.locationOf(itemToAdd).length, "Adding item to collection returns incorrect location");
		 Assert.equals(0, this._collection.locationOf(itemToAdd)[0], "Adding item to collection returns incorrect location");
		 Assert.equals(originalLength, this._collection.locationOf(itemToAdd)[1], "Adding item to collection returns incorrect location");
		 Assert.equals(2, locationFromEvent.length, "Adding item to collection returns incorrect location in event");
		 Assert.equals(0, locationFromEvent[0], "Adding item to collection returns incorrect location in event");
		 Assert.equals(originalLength, locationFromEvent[1], "Adding item to collection returns incorrect location in event");
	 }
 
	 public function testSet():Void {
		 var itemToAdd = new MockItem("New Item");
		 var originalLength = this._collection.getLength([0]);
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var replaceItemEvent = false;
		 var locationFromEvent:Array<Int> = null;
		 this._collection.addEventListener(HierarchicalCollectionEvent.REPLACE_ITEM, function(event:HierarchicalCollectionEvent):Void {
			 replaceItemEvent = true;
			 locationFromEvent = event.location;
		 });
		 this._collection.set([0, 1], itemToAdd);
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after replacing in collection");
		 Assert.isTrue(replaceItemEvent, "HierarchicalCollectionEvent.REPLACE_ITEM must be dispatched after replacing in collection");
		 Assert.equals(originalLength, this._collection.getLength([0]), "Collection length must not change after replacing in collection");
		 Assert.equals(2, this._collection.locationOf(itemToAdd).length, "Replacing item in collection returns incorrect location");
		 Assert.equals(0, this._collection.locationOf(itemToAdd)[0], "Replacing item in collection returns incorrect location");
		 Assert.equals(1, this._collection.locationOf(itemToAdd)[1], "Replacing item in collection returns incorrect location");
		 Assert.equals(2, locationFromEvent.length, "Replacing item in collection returns incorrect location in event");
		 Assert.equals(0, locationFromEvent[0], "Replacing item in collection returns incorrect location in event");
		 Assert.equals(1, locationFromEvent[1], "Replacing item in collection returns incorrect location in event");
 
		 Assert.raises(function() {
			 this._collection.set(null, itemToAdd);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.set([100], itemToAdd);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.set([-1], itemToAdd);
		 }, RangeError);
	 }
 
	 public function testSetAfterEndOfBranch():Void {
		 var itemToAdd = new MockItem("New Item");
		 var originalLength = this._collection.getLength([0]);
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var replaceItemEvent = false;
		 var locationFromEvent:Array<Int> = null;
		 this._collection.addEventListener(HierarchicalCollectionEvent.REPLACE_ITEM, function(event:HierarchicalCollectionEvent):Void {
			 replaceItemEvent = true;
			 locationFromEvent = event.location;
		 });
		 this._collection.set([0, originalLength], itemToAdd);
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after setting item after end of collection");
		 Assert.isTrue(replaceItemEvent, "HierarchicalCollectionEvent.REPLACE_ITEM must be dispatched after setting item after end of collection");
		 Assert.equals(originalLength + 1, this._collection.getLength([0]), "Collection length must change after setting item after end in collection");
		 Assert.equals(2, this._collection.locationOf(itemToAdd).length, "Setting item after end of collection returns incorrect location");
		 Assert.equals(0, this._collection.locationOf(itemToAdd)[0], "Setting item after end of collection returns incorrect location");
		 Assert.equals(originalLength, this._collection.locationOf(itemToAdd)[1], "Setting item after end of collection returns incorrect location");
		 Assert.equals(2, locationFromEvent.length, "Setting item after end of collection returns incorrect location in event");
		 Assert.equals(0, locationFromEvent[0], "Setting item after end of collection returns incorrect location in event");
		 Assert.equals(originalLength, locationFromEvent[1], "Setting item after end of collection returns incorrect location in event");
	 }
 
	 public function testRemove():Void {
		 var originalLength = this._collection.getLength([0]);
		 var itemToRemove = this._collection.get([0, 1]);
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var removeItemEvent = false;
		 var locationFromEvent:Array<Int> = null;
		 this._collection.addEventListener(HierarchicalCollectionEvent.REMOVE_ITEM, function(event:HierarchicalCollectionEvent):Void {
			 removeItemEvent = true;
			 locationFromEvent = event.location;
		 });
		 this._collection.remove(itemToRemove);
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after removing from collection");
		 Assert.isTrue(removeItemEvent, "HierarchicalCollectionEvent.REMOVE_ITEM must be dispatched after removing from collection");
		 Assert.equals(originalLength - 1, this._collection.getLength([0]), "Collection length must change after removing from collection");
		 Assert.equals(null, this._collection.locationOf(itemToRemove), "Removing item from collection returns incorrect location");
		 Assert.equals(2, locationFromEvent.length, "Removing item from collection returns incorrect location in event");
		 Assert.equals(0, locationFromEvent[0], "Removing item from collection returns incorrect location in event");
		 Assert.equals(1, locationFromEvent[1], "Removing item from collection returns incorrect location in event");
	 }
 
	 public function testRemoveAt():Void {
		 var originalLength = this._collection.getLength([0]);
		 var itemToRemove = this._collection.get([0, 1]);
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var removeItemEvent = false;
		 var locationFromEvent:Array<Int> = null;
		 this._collection.addEventListener(HierarchicalCollectionEvent.REMOVE_ITEM, function(event:HierarchicalCollectionEvent):Void {
			 removeItemEvent = true;
			 locationFromEvent = event.location;
		 });
		 this._collection.removeAt([0, 1]);
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after removing from collection");
		 Assert.isTrue(removeItemEvent, "HierarchicalCollectionEvent.REMOVE_ITEM must be dispatched after removing from collection");
		 Assert.equals(originalLength - 1, this._collection.getLength([0]), "Collection length must change after removing from collection");
		 Assert.equals(null, this._collection.locationOf(itemToRemove), "Removing item from collection returns incorrect location");
		 Assert.equals(2, locationFromEvent.length, "Removing item from collection returns incorrect location in event");
		 Assert.equals(0, locationFromEvent[0], "Removing item from collection returns incorrect location in event");
		 Assert.equals(1, locationFromEvent[1], "Removing item from collection returns incorrect location in event");
 
		 Assert.raises(function() {
			 this._collection.removeAt(null);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.removeAt([100]);
		 }, RangeError);
		 Assert.raises(function() {
			 this._collection.removeAt([-1]);
		 }, RangeError);
	 }
 
	 public function testRemoveAll():Void {
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var removeAllEvent = false;
		 this._collection.addEventListener(HierarchicalCollectionEvent.REMOVE_ALL, function(event:HierarchicalCollectionEvent):Void {
			 removeAllEvent = true;
		 });
		 var resetEvent = false;
		 this._collection.addEventListener(HierarchicalCollectionEvent.RESET, function(event:HierarchicalCollectionEvent):Void {
			 resetEvent = true;
		 });
		 this._collection.removeAll();
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after removing all from collection");
		 Assert.isTrue(removeAllEvent, "HierarchicalCollectionEvent.REMOVE_ALL must be dispatched after removing all from collection");
		 Assert.isFalse(resetEvent, "HierarchicalCollectionEvent.RESET must not be dispatched after removing all from collection");
		 Assert.equals(0, this._collection.getLength(), "Collection length must change after removing all from collection");
	 }
 
	 public function testRemoveAllWithEmptyCollection():Void {
		 this._collection = new ArrayHierarchicalCollection();
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var removeAllEvent = false;
		 this._collection.addEventListener(HierarchicalCollectionEvent.REMOVE_ALL, function(event:HierarchicalCollectionEvent):Void {
			 removeAllEvent = true;
		 });
		 this._collection.removeAll();
		 Assert.isFalse(changeEvent, "Event.CHANGE must not be dispatched after removing all from empty collection");
		 Assert.isFalse(removeAllEvent, "HierarchicalCollectionEvent.REMOVE_ALL must not be dispatched after removing all from empty collection");
	 }
 
	 public function testResetArray():Void {
		 var newArray = [this._5, this._4, this._3];
		 var changeEvent = false;
		 this._collection.addEventListener(Event.CHANGE, function(event:Event):Void {
			 changeEvent = true;
		 });
		 var removeAllEvent = false;
		 this._collection.addEventListener(HierarchicalCollectionEvent.REMOVE_ALL, function(event:HierarchicalCollectionEvent):Void {
			 removeAllEvent = true;
		 });
		 var resetEvent = false;
		 this._collection.addEventListener(HierarchicalCollectionEvent.RESET, function(event:HierarchicalCollectionEvent):Void {
			 resetEvent = true;
		 });
		 this._collection.array = newArray;
		 Assert.isTrue(changeEvent, "Event.CHANGE must be dispatched after resetting collection");
		 Assert.isTrue(resetEvent, "HierarchicalCollectionEvent.RESET must be dispatched after resetting collection");
		 Assert.isFalse(removeAllEvent, "HierarchicalCollectionEvent.REMOVE_ALL must not be dispatched after resetting from collection");
		 Assert.equals(newArray.length, this._collection.getLength(), "Collection length must change after resetting collection with data of new size");
	 }
 
	 public function testResetArrayToNull():Void {
		 this._collection.array = null;
		 Assert.isOfType(this._collection.array, Array, "Setting collection source to null should replace with an empty value.");
		 Assert.equals(0, this._collection.getLength(), "Collection length must change after resetting collection source with empty valee");
	 }
 
	 public function testUpdateAt():Void {
		 var updateItemEvent = false;
		 var updateItemLocation:Array<Int> = null;
		 this._collection.addEventListener(HierarchicalCollectionEvent.UPDATE_ITEM, function(event:HierarchicalCollectionEvent):Void {
			 updateItemEvent = true;
			 updateItemLocation = event.location;
		 });
		 this._collection.updateAt([0, 1, 0]);
		 Assert.isTrue(updateItemEvent, "HierarchicalCollectionEvent.UPDATE_ITEM must be dispatched after calling updateAt()");
		 Assert.equals(3, updateItemLocation.length, "HierarchicalCollectionEvent.UPDATE_ITEM must be dispatched with correct location");
		 Assert.equals(0, updateItemLocation[0], "HierarchicalCollectionEvent.UPDATE_ITEM must be dispatched with correct location");
		 Assert.equals(1, updateItemLocation[1], "HierarchicalCollectionEvent.UPDATE_ITEM must be dispatched with correct location");
		 Assert.equals(0, updateItemLocation[2], "HierarchicalCollectionEvent.UPDATE_ITEM must be dispatched with correct location");
 
		 Assert.raises(function():Void {
			 this._collection.updateAt(null);
		 }, RangeError);
		 Assert.raises(function():Void {
			 this._collection.updateAt([100]);
		 }, RangeError);
		 Assert.raises(function():Void {
			 this._collection.updateAt([-1]);
		 }, RangeError);
	 }
 
	 public function testUpdateAll():Void {
		 var updateAllEvent = false;
		 this._collection.addEventListener(HierarchicalCollectionEvent.UPDATE_ALL, function(event:HierarchicalCollectionEvent):Void {
			 updateAllEvent = true;
		 });
		 this._collection.updateAll();
		 Assert.isTrue(updateAllEvent, "HierarchicalCollectionEvent.UPDATE_ALL must be dispatched after calling updateAll()");
	 }
 }
 
 private class MockItem {
	 public function new(text:String, ?children:Array<MockItem>) {
		 this.text = text;
		 this.children = children;
	 }
 
	 public var text:String;
	 public var children:Array<MockItem>;
 }
 