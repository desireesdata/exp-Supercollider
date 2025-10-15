

// SYNTHESE ADDITIVE PAS A PAS :-D

/********************************************/
/********************************************/
/********************************************/
// 1. Synthèse additivie, mais en dupliquant à la main le même synth (comme si on avait plusieurs instruments)
(
SynthDef(\additif_laborieux, {|freq, amp=0.3|
	var sig;
	sig = SinOsc.ar(freq, 0, amp/2, 0); // Je divise juste l'amplitude par deux pour pas avoir trop de son dans la tronche :D
	Out.ar(0, sig!2);
}).add;
)


a = Synth(\additif_laborieux, [\freq, 100, \amp, 0.4]);
a.free;

b = Synth(\additif_laborieux, [\freq, 200, \amp, 0.2]);
b.free;

c = Synth(\additif_laborieux, [\freq, 300, \amp, 0.1]);
c.free;

(
a.free;
b.free;
c.free;
)


/********************************************/
/********************************************/
/********************************************/
//2 Synthese additive, mais en dupliquant avec une boucle le même synth (tjrs comme si on avait plusieurs instruments)
(
SynthDef(\additif_laborieux, {|freq, amp=0.3|
	var sig;
	sig = SinOsc.ar(freq, 0, amp/2, 0); // Je divise juste l'amplitude par deux pour pas avoir trop de son dans la tronche :D
	Out.ar(0, sig!2);
}).add;
)

// juste pour montrer la méthode series sur un tableau :
Array.series(3, 100, 100); // prépare trois place, commence à 100 et ajoute 100 pour "remplir" les trois places

// on peut l'utiliser pour faire de véritables pour qui permettent de parcourir le tableau avec un do:
(
Array.series(3, 100, 100).do({ |freq, index|
	var amp;
	amp = 0.4 * (0.5 ** index);
	amp.postln();
	Synth(\additif_laborieux, [\freq, freq, \amp, 0.1])
});
)


(
a.free;
b.free;
c.free;
)


/********************************************/
/********************************************/
/********************************************/
//3 Synthese additive, mais le synthétiseur incorpore "tout en un" ses propres harmoniques, sans être dupliqué. On mélange directement les signaux.

// Array.fill(n, { |i| ... }) crée un tableau de n éléments en évaluant la fonction pour chaque index i.
// Mix.fill = Array.fill + sommation automatique du tableau.

(
SynthDef(\additive_mieux, {|fondamentale=100, amp=0.4|
	var sig;
	sig = Mix.fill(3, {|i|
		var freq = fondamentale * (i + 1);
		var a = amp / ( i + 1);
		SinOsc.ar(freq, 0, a);
	});
	Out.ar(0, sig!2)
}).add;
)

d = Synth(\additive_mieux, [\fondamentale, 100])