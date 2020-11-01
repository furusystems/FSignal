package fsignal;
/**
 * ...
 * @author Andreas Rønning
*/
#if !js
@:generic
#end
 class Signal3<T,T2,T3>
{
	var _listeners:Array<Listener3<T,T2,T3>> ;
	var _listenerCount:Int = 0;
	public var listenerCount(get, null):Int;
	public var oneshot:Bool;
	public function new(oneshot:Bool = false) 
	{
		this.oneshot = oneshot;
		_listeners = new Array<Listener3<T,T2,T3>>();
	}
	public function add(func:T->T2->T3->Void):Void {
		remove(func);
		_listeners.push( new Listener3<T,T2,T3>(ListenerType.NORMAL, func) );
		_listenerCount++;
	}
	public function remove(func:T->T2->T3->Void):Void {
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
	public function addOnce(func:T->T2->T3->Void):Void {
		remove(func);
		_listeners.push( new Listener3<T,T2,T3>(ListenerType.ONCE, func) );
		_listenerCount++;
	}
	public function removeAll():Void {
		_listeners = new Array<Listener3<T,T2,T3>>();
		_listenerCount = 0;
	}
	public function dispose():Void {
		_listeners = null;
		_listenerCount = 0;
	}
	public function dispatch(arg1:T, arg2:T2, arg3:T3):Void {
		for (i in _listeners) 
		{
			i.execute(arg1,arg2,arg3);
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
private class Listener3<T,T2,T3> {
	public var func:T->T2->T3->Void;
	public var type:ListenerType;
	public inline function execute(arg1:T, arg2:T2, arg3:T3):Void {
		func(arg1,arg2,arg3);
	}
	public inline function new(type:ListenerType, func:T->T2->T3->Void) {
		this.type = type;
		this.func = func;
	}
}