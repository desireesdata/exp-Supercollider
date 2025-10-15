(
SynthDef(\exp, {|amp = 0.1, freq=100|
	var sig;
	sig = SinOsc.ar(freq, 0, amp, 0);
	Out.ar(0, sig!2);
}).add;
)

"hey" !3

~test = Synth(\exp);
~test.free;
~test.set(\freq, 100) // change la hauteur du son :-)
~test.set(\amp, 0.05) // change l'amplitude :-)