
//1.Hello word

// a.
{SinOsc.ar}.play;

/*
Ce que fait .play :
Elle crée un SynthDef temporaire (basé sur ta fonction).
Elle l’envoie au serveur (s.sendSynthDef).
Elle instancie un Synth sur le serveur.
Elle retourne un objet Synth côté langage.

Tu entends du son, et un Synth existe sur le serveur.
Mais tu ne l’as pas stocké dans une variable → tu ne peux pas le .free après.
*/

// b.
x = {SinOsc.ar}.play;
x.free;
/*
x n’est pas une Function, mais un Synth (une instance en cours sur le serveur).
Donc x.free fonctionne : ça envoie un message “libère le node” au serveur.
*/

// c.
x = {SinOsc.ar};
x.play;
x.free; // ne marche pas ! car x est une Function, pas un Synth.

// Il faut donc faire :
x = {SinOsc.ar};
y = x.play; // la fonction play crée un synth def et l'envoie sur le serveur; et renvoie un synth côté langage. y représente ce synth retourné
y.free


// d.
(
z = {
	var freq, sig;
	freq = 200;
	sig = SinOsc.ar(freq, 0.3);
}
)

y = z.play;
y.free;


// e.
(
z = {
	var freq, sig;
	freq = LFNoise0.kr(8, 100, 400);
	sig = SinOsc.ar(freq, 0.3);
}
)

y = z.play;
y.free;

// f.
(
z = {
	var freq, sig;
	freq = LFNoise0.kr(8).range(100, 400);
	sig = SinOsc.ar(freq, 0.3);
}
)

y = z.play;
y.free;


// g. Compensation exponentielle de la perception logarithmique
(
z = {
	var freq, sig;
	freq = LFNoise0.kr(8).exprange(100, 400);
	sig = SinOsc.ar(freq, 0.3);
}
)

y = z.play;
y.free;


/*
Quand tu fais x.play, ça crée un Synth temporaire sur le serveur, mais tu ne le stockes pas.
(le Synth existe, mais x continue de pointer vers la Function)

Donc x.free essaye de “libérer” une Function, ce qui n’a pas de sens → pas d’effet.
*/
/////////////////////////////////////////////////////////////////////


/***********************************/

// 2: avec un synthdef pour "mettre en machine" le son :D
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