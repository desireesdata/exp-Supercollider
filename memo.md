# Supercollider par l'exemple : un mémo

> A ajouter : 
> 
> -> Un mot sur Supercollider.
> -> Parler de sa spécificité (le CTRL + ENTREE) et le fait que le programme ne se déroule pas de bas en haut comme un script python.

## Comment ça marche (grossomodo)

Toi = musicien = codeur.

**Étape 1 – toi (dans sclang)**
Tu écris du code, par ex. :

```supercollider
{ SinOsc.ar(440) * 0.1 }.play;
```

**Étape 2 – sclang**

* Analyse la fonction `{ ... }`.
* Crée une description de graphe DSP (une “recette” : un oscillateur → multiplication → sortie).
* Emballe cette description en messages OSC.

🔹 **Étape 3 – scsynth (le serveur audio)**

* Reçoit ces messages OSC.
* Construit le graphe DSP dans sa mémoire.
* Exécute le graphe en temps réel, c’est-à-dire qu’il calcule les échantillons audio en continu.
* Envoie les échantillons calculés à la carte son via les pilotes audio (CoreAudio sur macOS, ALSA/JACK sur Linux, etc.).

---

- **sclang = cerveau + traducteur**

-  **OSC = le courrier**

-  **scsynth = moteur audio temps réel**

- **pilotes audio = porte de sortie vers ton matériel**

## Syntaxe de base (juste le nécessaire avant de faire du son)

### Variables

#### Valeurs numériques

```smalltalk
a = 2;
a.postln;
a + 2;
a * 1;
a = a / 2;
a = a * 10;
a.postln;
```

> Essayez d'exécuter la même ligne plusieurs fois pour comprendre l'aspect dynamique de la mémoire.

-> Un mot sur le fait qu'une valeur est toujours renvoyée.

#### Chaînes de caractères

```smalltalk
mot = "bonjour !"; // ne marche pas !
String mot = "bonjour !"; // ne marche pas non plus !
m = "bonjour !"; // marche car les noms de variables avec un seul caractères peuvent changer de type dynamiquement
m.postln;

~mot = "salut !"; // marche ! La tilde dit qu'on a une variable globale
mot.postln;
```

> - **Déclaration** = “Je réserve une boîte étiquetée `x`”.
>   
>   - Déclaration `var x;`: c’est purement syntaxique → ne renvoie rien.
> 
> - **Affectation** = “Je mets un objet (par ex. `"bonjour"`) dans la boîte `x`”.
>   
>   - **Affectation** : renvoie la valeur affectée (valeur pas toujours attrapée)
> 
> - Varialbes d'une lettre = variables globales prédéfinies.

### Opérateur de duplication

```smalltalk
hey !3 
```

Répète trois fois "hey". Utile pour dupliquer un signal mono => stéréo (on verra ultérieurement)

### Symboles

Sorte d'étiquette pour nommer des choses (ex: des fonctions) :

```
\code
```

### Blocks

Sorte de pipeline, de chaîne de traitement solidaire qu'on peut utiliser d'un coup.

```smalltalk
(
   a.postln;
   ~mot.postln; // renvoie la dernière valeur
)
```

Exécute tout d'un coup ET renvoie la dernière valeur du "pipeline". On solidarise les actions en quelque sorte.

```smalltalk
(
var etincelle; // déclaration d'une variable globale
etincelle = "je vis et meurs";
etincelle.postln;
)

etincelle; // ne marche pas en-dehors du bloc
```

### Tableaux (ou Arrays)

```smalltalk
~frequences = [100, 200, 300, 400, 500, 600]; // on donne une *liste* de valeurs
~frequences.at(0); // on accède au premier élément
~frequences.at(1); // on accède au deuxième élément
~frequences.at(4); // Devinette : on accède à quel élément ?
~frequences.last(); // On accède au dernier élément
~frequences.(3).postln; // on peut bien sûr print un élément
~frequences.last().postln;
```

On peut aussi utiliser la méthode series de la classe Array :

```smalltalk
soleil = Array.series(3, 1, 1); // on va avoir un tableau de 3 "places", en commençant par 1, et en avançant de 1
~dizaines = Array.series(11, 0, 10); // compte de 0 à 100

~dizaines = ~dizaines.scramble; // on applique une méthode qui "mélange" les positions (permutation aléatoire)
```

### Fonctions

```smalltalk
// fonction anonyme
{
    a.postln;
    ~frequences.at(0);
    ~soleil.last();
} // renvoie une fonction + la dernière valeur


// fonction anonyme
{
    a.postln;
    ~frequences.at(0).postln;
    ~soleil.last().postln;
}.value; // on "active" la fonction (on l'enclenche)

// on peut aussi nommer nos variables pour les réutiliser plus tard :
~pipeline = {
    ~frequences.at(2) * 2; // on mutiplie la valeur du troisième objet de l'array par 2
}

~pipeline.value;
```

#### Paramètres d'une fonction

```smalltalk
~addition = {
    arg x, y;
    (x + y); // retourne x + y
}

~addition.value(2, 3);

~division = {
    arg x, n = 1; // valeur par défaut
    (x / n);

}

~division.value(10);
```

### Boucles (ou méthode "do")

```smalltalk
// "Fais" 3 fois une action (fonction = action)
(3.do({
    ~dizaines.postln;
    })
)

// "Fais" 3 fois une action (fonction = action)
(3.do({
    arg i; // itérateur
    ("\n itérateur : " + i).postln;
    ~dizaines.postln;
    })
)
```

```smalltalk
//itération sur tous les éléments d'un tableau
(
[10, 20, 30].do(
    {
    arg x;
    x.postln;
    }
)
)
```

## Premiers sons

### Signal sinusoïdal : hello world sonore

```
s.boot; // on lance d'abord le serveur
g = {SinOsc.ar([100, 102], 0, 0.3, 0)};
g.play;
```

### SynthDef

```smalltalk
// on définit ce qui va afire du son
(
SynthDef.new(\hello, {
    Out.ar([0, 1], SinOsc.ar(140, 0, 0.1, 0));
}).add;
)

Synth.new(\hello); // instancie une version de notre synthé "hello"
```

Avec une variable c'est mieux pour avoir plus de contrôle :

```smalltalk
// on définit ce qui va afire du son
(
SynthDef.new(\hello, {
    Out.ar([0, 1], SinOsc.ar(140, 0, 0.1, 0));
}).add;
)

x = Synth.new(\hello); // instancie une version de notre synthé "hello"
x.class; // on peut regarder quelle classe c'est 
x.free; // arrête
```

On peut utiliser les paramètres pour changer telle ou telle valeur :

```smalltalk
(
SynthDef.new(\world, {
    arg freq = 40, amp = 0.2;
    Out.ar([0, 1], SinOsc.ar(freq, 0, amp, 0));
}).add;
)

y = Synth.new(\world, [\freq, 40, \amp, 0.6]);
```

### Synthèse additive

```smalltalk
(
SynthDef.new(\world, {
    arg freq = 40, amp = 0.2;
    Out.ar([0, 1], SinOsc.ar(freq, 0, amp, 0));
}).add;
)

y = Synth.new(\world, [\freq, 40, \amp, 0.6]);
y.free;

// Première synthèse additive
(
Array.series(10, 100, 100).do({
    arg i;
    Synth.new(\world, [\freq, i, \amp, 0.02]);
});
)
```

## Lire des fichiers audio

```smalltalk
~b1 = Buffer.read(s, "/home/joel/Musique/supercollider/samples/kick_isa_kurz.wav");
~b1.bufnum;

(SynthDef(\kick, {
    arg obs=0, buf, rate=1, amp=0.3;
    var sig;
    sig = PlayBuf.ar(1, buf, rate, \t_tr.kr(1, 0), 0, 1, 0);
    Out.ar(obs, (sig * amp)!2)
}).add;)

a = Synth(\kick, [\buf, ~b1.bufnum]);
a.set(\rate, 0.5);

b = Synth(\kick, [\buf, ~b1.bufnum]);
b.set(\rate, -1.5);
b.free;
b.play;
```

```smalltalk
~b1 = Buffer.read(s, "/home/joel/Musique/supercollider/samples/kick_isa_kurz.wav");
~b1.bufnum;


(SynthDef(\kickenv, { |out=0, buf=0, rate=1, amp=0.3, loop=1, startPos=0, pan=0, gate=1|
    var sig, env;
    var trig=1;
    env = EnvGen.kr(Env.asr(0.005, 1, 0.01), gate, doneAction:2);
    sig = PlayBuf.ar(2, buf, rate, trig, startPos, loop, 0);
    Out.ar(out, (sig * amp * env));
}).add;)

c = Synth(\kickenv, [\buf, ~b1.bufnum, \loop, 1, \rate, 1,  \pan, 0]);
c.set(\loop, 0;)
c.set(\gate, 0);
```
