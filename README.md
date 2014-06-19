FSignal 
=======
(aka 'Hey look, yet another Haxe signals implementation!')

Simple cross plat Signals for Haxe.
Uses generics for strong typing on compatible platforms. 

Three variations exist, starting with 0 arguments up to 3.
For instance, a signal that dispatches two floats and a string would be declared as such:

    var sig = new fsignal.Signal3<Float,Float,String>();

Signals support the usual add, addOnce, removeAll and dispose.
Additionally, the signal constructor can enable a "oneshot" mode where the listener list is cleared every dispatch. 