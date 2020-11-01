package fsignal;

/**
 * ...
 * @author Andreas Rønning
 */
#if !js
@:generic 
#end
class Signal1<T>
{
	var _listeners:Array<Listener1<T>> ;
	var _listenerCount:Int = 0;
	public var listenerCount(get, null):Int;
	public var oneshot:Bool;
	public function new(oneshot:Bool = false) 
	{
		this.oneshot = oneshot;
		_listeners = new Array<Listener1<T>>();
	}
	public function add(func:T->Void):Void {
		remove(func);
		_listeners.push( new Listener1<T>(ListenerType.NORMAL, func) );
		_listenerCount++;
	}
	public function remove(func:T->Void):Void {
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
	public function addOnce(func:T->Void):Void {
		remove(func);
		_listeners.push( new Listener1<T>(ListenerType.ONCE, func) );
		_listenerCount++;
	}
	public function removeAll():Void {
		_listeners = new Array<Listener1<T>>();
		_listenerCount = 0;
	}
	public function dispose():Void {
		_listeners = null;
		_listenerCount = 0;
	}
	public function dispatch(value:T):Void {
		for (i in _listeners) 
		{
			i.execute(value);
			if (i.type == ListenerType.ONCE) {
				_listeners.remove(i);
			}
		}
		if (oneshot) removeAll();
	}
}
#if !js
@:generic
#end
private class Listener1<T> {
	public var func:T->Void;
	public var type:ListenerType;
	public inline function execute(arg:T):Void {
		func(arg);
	}
	public inline function new(type:ListenerType, func:T->Void) {
		this.type = type;
		this.func = func;
	}
}