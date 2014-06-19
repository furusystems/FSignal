package fsignal;

/**
 * ...
 * @author Andreas Rønning
 */
class Signal
{
	var _listeners:Array<Listener0>;
	var _listenerCount:Int = 0;
	public var listenerCount(get_listenerCount, null):Int;
	public var oneshot:Bool;
	public function new(oneshot:Bool = false) 
	{
		this.oneshot = oneshot;
		_listeners = new Array<Listener0>();
	}
	public inline function add(func:Void->Void):Void {
		remove(func);
		_listeners.push( new Listener0(ListenerType.NORMAL, func) );
		_listenerCount++;
	}
	public function remove(func:Void->Void):Void {
		for (l in _listeners) 
		{
			if (l.func == func) {
				_listeners.remove(l);
				_listenerCount--;
				break;
			}
		}
	}
	inline function get_listenerCount():Int 
	{
		return _listenerCount;
	}
	public function addOnce(func:Void->Void):Void {
		remove(func);
		_listeners.push( new Listener0(ListenerType.ONCE, func) );
		_listenerCount++;
	}
	public inline function removeAll():Void {
		_listeners = new Array<Listener0>();
		_listenerCount = 0;
	}
	public inline function dispose():Void {
		_listeners = null;
		_listenerCount = 0;
	}
	public function dispatch():Void {
		for (i in _listeners) 
		{
			i.execute();
			if (i.type == ListenerType.ONCE) {
				_listeners.remove(i);
			}
		}
		if (oneshot) removeAll();
	}
}
private class Listener0 {
	public var func:Void->Void;
	public var type:ListenerType;
	public inline function execute():Void {
		func();
	}
	public inline function new(type:ListenerType, func:Void->Void) {
		this.type = type;
		this.func = func;
	}
}