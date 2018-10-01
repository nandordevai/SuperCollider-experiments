(
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1);
~k.play;
)

~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\rate,Pwhite(1,1.2));

//footwork kickdrums
(
p.clock.tempo = 2.4;
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pbjorklund2(Pseq([3,3,3,5],inf),8)/4,\amp,1,\rate,Pseq([1,1.2],inf));
~k.play;
)

(
~kick = Pbind(*[
	'instrument': 'bplay',
	'buf': d["k"][0],
	'dur': Pbjorklund2(Pseq([3, 3, 3, 5], inf), 8) / 4,
	'amp': 1,
	'rate': Pseq([1, 1.2], inf)
])
)
~kick.play;
~kick.stop;

//skittery hi-hats
(
p.clock.tempo = 1.5;
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pwrand([0.25,Pseq([0.125],2),0.5,Pseq([0.125/2],4)],[4,1,1,0.5].normalizeSum,inf),\amp,Pwhite(0.2,1));
~h.play;
)

(
p.clock.tempo = 90 / 60;
~hihat = Pbind(*[
	'instrument': 'bplay',
	'buf': d["ch"][0],
	'dur': Pwrand(
		[0.25, Pseq([1/8], 2), 0.5, Pseq([1/16], 4)],
		[4,    1,              1,   0.5            ].normalizeSum(),
		inf
	),
	'amp': Pwhite(0.2, 1)
]);
);
~hihat.play;
~hihat.stop;

//offset percussion patterns for techno feel behind a basic kick

p.clock.tempo = 135/60;
~c = Pbind(
	\instrument, \bplay,
	\buf, d["sfx"][6],
	\dur, Pbjorklund2(
		Pexprand(2, 15).round(1),
		16,
		inf,
		Pwhite(1, 5).asStream
	) / 4,
	\amp, 1,
	\rate, 2.2
)

(
~c2 = Pbind(
	\instrument, \bplay,
	\buf, d["sfx"][6],
	\dur, Pbjorklund2(
		k: Pexprand(2, 15).round(1),
		n: 16,
		length: inf,
		offset: Pwhite(1, 5).asStream
	) / 4,
	\amp, 1,
	\rate, 1.9
);
)

(
~kick = Pbind(
	\instrument, \bplay,
	\buf, d["sk"][0],
	\dur, 1,
	\amp, 1,
	\rate, Pseq([0.6, 1, 1, 1], inf)
)
)

~c.play;
~c2.play;
~kick.play;

~kick.stop;
~c2.stop;
~c.stop;

//snare running forwards and back
(
p.clock.tempo = 150/60;
~sn = Pbind(\instrument,\bplay,\buf,d["s"][4],\dur,Pwhite(1,4)/2,\amp,1,\rate,Prand([1,-1],inf),\pos,Pkey(\rate).linlin(-2,2,0.9,0));
~sn.play;
)
~sn.stop;

//SinFB Bass
(
SynthDef(\sinfb, {
    arg freq = 440, atk = 0.01, sus = 0, rel = 1, fb = 0, amp = 0.3, out = 0, pan=0;
    var sig, env;
    env = EnvGen.ar(Env.linen(atk,sus,rel),1,1,0,1,2);
    sig = SinOscFB.ar(freq,fb,1);
    sig = sig*env;
    Out.ar(out,Pan2.ar(sig,pan,amp));
}).add;
);

~sinfb = Pbind(\instrument,\sinfb,\dur,0.25,\degree,Pseq((0..7),inf));
~sinfb.play;


~sinfb = Pbind(\instrument,\sinfb,\scale,Scale.chromatic(\et12),\degree,Pseq((0..12).pyramid.mirror,inf),\octave,6,\dur,0.125/2,\amp,0.3,\fb,0.8,\rel,0.1)



(
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,0.25,\amp,Pwhite(0.25,1));
~h.play;
)
~h.stop

(
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,0.75,\amp,1);
~c.play;
)

~kick.play;

(
~oh = Pbind(
	\instrument, \bplay,
	\buf, d["oh"][0],
	\dur, 1,
	\amp, 1
);
~oh.play(fadeTime: 0);
)

~oh.quant = [4, 1/2]

~oh.stop;

(
~oh = Pbind(
	\instrument, \bplay,
	\buf, d["oh"][0],
	\dur, Pseq([0.5,Pseq([1],inf)],inf),
	\amp, 1
);
~oh.play();
)

~oh.class



//same example but with all rhythms constrained
(
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,Pwhite(1,5.0).round(1),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pwhite(0.25,0.75).round(0.25),\amp,Pwhite(0.2,1));
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,Pwhite(0.75,2).round(0.75),\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pwhite(1,5.0).round(0.5),\amp,1);
~sn.play;~h.play;~c.play;~t.play;
)
//sounds more palatable with everything arranged properly
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~k.play;
)


//same example again
(
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,Pwhite(1,5.0).round(1),\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pwhite(0.25,0.75).round(0.25),\amp,Pwhite(0.2,1));
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,Pwhite(0.75,2).round(0.75),\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pwhite(1,5.0).round(0.5),\amp,1);
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~sn.play;~h.play;~c.play;~t.play;~k.play;
)
//added whole note fx, short, medium and long.
(
~fx1 = Pbind(\instrument,\bplay,\buf,d["sfx"][0],\dur,Pwhite(1,5),\amp,1);
~fx2 = Pbind(\instrument,\bplay,\buf,d["fx"][0],\dur,Pwhite(1,10),\amp,1);
~fx3 = Pbind(\instrument,\bplay,\buf,d["lfx"][0],\dur,Pwhite(10,40),\amp,1);
~fx1.play;~fx2.play;~fx3.play;
)



//layering at different pitches - kicks
(
p.clock.tempo = 2.3;
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pbjorklund2(3,8)/4,\amp,1,\rate,Pseq([1,1.2],inf));
~k.play;
)
//kicks at a different pitch. Evaluate this a few times to get different permutations
(
~k2 = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pbjorklund2(3,8)/4,\amp,1,\rate,Pseq([1,1.8],inf)*4);
~k2.play;
)


//layering of slightly different rhythms
//rhythm 1
(
p.clock.tempo = 1.7;
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t.play;
)
//rhythm 2, using a different tom for contrast
//also re-evaluating rhythm 1 to get them playing together
(
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t2 = Pbind(\instrument,\bplay,\buf,d["t"][1],\dur,Pseq([1,1,1,0.25],inf),\amp,1);
~t2.play;
)
//rhythm 3 for more
(
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pseq([1,1,1,0.5],inf),\amp,1);
~t2 = Pbind(\instrument,\bplay,\buf,d["t"][1],\dur,Pseq([1,1,1,0.25],inf),\amp,1);
~t3 = Pbind(\instrument,\bplay,\buf,d["t"][2],\dur,Pseq([1,1,1,0.75],inf),\amp,1);
~t3.play;
)
//kick underneath to illustrate
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~oh = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,1,\rate,1);
~oh.play;
~k.play;
)

//complimentary rhythms:
//the 'polyrhythmic clap' from the Basics example
(
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,0.75,\amp,1);
~c.play;
)
//clap added at a similar rhythm (euclidean 3,8)
(
~c2 = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,Pbjorklund2(3,8)/4,\amp,1);
~c2.play;
)


//StageLimiter throttling
//a complex rhythm
(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
        0.25: [1,0.75,0.1,0.3,0.6,0.1],
        0.1: [0.5,1,2],
        2: [0.5,0.75,0.5,1]
        ), 4);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,l/2,\amp,1,\rate,2);
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l*2,\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,l,\amp,1,\rate,Pseq([1.2,1.4,1.7],inf));
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,l*4,\amp,1,\rate,0.8);
~ding = Pbind(\instrument,\bplay,\buf,d["ding"][0],\dur,Pwhite(1,5),\amp,1,\rate,0.2);
~h.play;~c.play;~t.play;~ding.play;~sn.play;
)
//extremely loud kick throttles everything else
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,3,\rate,0.5);
~k.play;
)



//trap(ish) hi-hats
//Has a choice of four rhythmic patterns with lesser chance for each, results in a mostly 0.25-duration hat which can potentially go quite quickly
(
p.clock.tempo = 75/60;
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pwrand([0.25,Pseq([0.125],4),Pseq([0.25]/3,3),Pseq([0.125]/2,4)],[0.6,0.3,0.09,0.01],inf),\amp,1,\rate,2);
~h.play;
)


//occasional variation on 4/4 kick
(
p.clock.tempo = 2.3;
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,Pwrand([1,Pseq([0.75],4),Pbjorklund2(3,8,1)/4],[0.9,0.08,0.02],inf),\amp,1);
~k.play;
)
//open hat for reference
(
~oh = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,1,\rate,1.4);
~oh.play;
)


//cutoff percussion. This Pbind uses (0..100)/100 to split the sample into 100 sections of 0.03 and play over them
(
p.clock.tempo = 2.4;
~perc = Pbind(\instrument,\vplay,\buf,d["fx"][1],\rel,0.03,\dur,0.25,\pos,Pseq((0..100)/100,inf));
~perc.play;
)


//back-and-forth snare
(
~sn = Pbind(\instrument,\vplay,\buf,d["s"][0],\dur,Pbjorklund2(Pwhite(1,6),16)/4,\amp,1,\rate,Prand([-1,1],inf),\pos,Pkey(\rate).linlin(-1,1,0.99,0));
~sn.play;
)

//four randomised euclidean rhythms with four different samples.
//sounds better, producing a much greater variety of rhythmic forms.
(
p.clock.tempo = 2.2;
~k = Pbind(\instrument,\bplay,\buf,d["k"][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["ch"][1],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~t = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(Pwhite(1,8),Pwhite(1,16))/4,\amp,1);
~k.play;
~sn.play;
~h.play;
~t.play;
)


//Complex rhythm that obfuscates the central rhythmic centre
(
p.clock.tempo = 1.5;
~h = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pbjorklund2(Pwhite(10,35),41,inf,Pwhite(0,10).asStream)/8,\amp,Pexprand(0.1,1),\pan,-1);
~h2 = Pbind(\instrument,\bplay,\buf,d["ch"][0],\dur,Pbjorklund2(Pwhite(10,35),40,inf,Pwhite(0,10).asStream)/8,\amp,Pexprand(0.1,1),\pan,1);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,Pbjorklund2(Pwhite(1,5),Pwhite(1,32))/4,\amp,1,\rate,Pwrand([1,-1],[0.8,0.2],inf),\pos,Pkey(\rate).linlin(1,-1,0,0.999));
~ding = Pbind(\instrument,\bplay,\buf,d["ding"][0],\dur,Pbjorklund2(Pwhite(1,3),25)/4,\amp,0.6,\rate,0.6,\pan,-1);
~ding2 = Pbind(\instrument,\bplay,\buf,d["ding"][0],\dur,Pbjorklund2(Pwhite(1,3),20)/4,\amp,0.6,\rate,0.7,\pan,1);
~t1 = Pbind(\instrument,\bplay,\buf,d["mt"][0],\dur,Pbjorklund2(Pseq([1,1,1,Pwhite(10,15,1).asStream],inf),36,inf,Pwhite(0,2).asStream)/8,\amp,1);
~t2 = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(Pseq([1,1,1,Pwhite(10,15,1).asStream],inf),40,inf,Pwhite(0,2).asStream)/8,\amp,1,\rate,2);
~t1.play;~t2.play;~h.play;~h2.play;~sn.play;~ding.play;~ding2.play;
)
//a slightly more rhythmic element, tracing the rhythm out a bit more
(
~ring1 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,Scale.minor,\degree,Pwrand([0,4],[0.8,0.2],inf),\octave,Pwrand([2,3],[0.8,0.2],inf),\dur,0.125,\d,0.25,\a,Pexprand(0.0001,200),\pan,0,\amp,1);
~ring1.play
)
//Add unce unce unce and simmer gently to unify flavours.
(
~ring1 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,Scale.minor,\degree,Pwrand([0,4],[0.8,0.2],inf),\octave,Pwrand([2,3,4],[0.6,0.2,0.2],inf),\dur,0.125,\d,0.2,\a,Pexprand(0.02,900),\pan,0,\amp,1);
~k = Pbind(\instrument,\bplay,\buf,d["k"][1],\dur,0.5,\amp,2);
~k.play;
)
//offbeat hat because cheesy rhythms are good fun
(
~oh = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,Pseq([0.5,Pseq([1],inf)],inf)/2,\amp,1);
~oh.play;
)


//working with offsets - doing a lot with a little
//basic kick
(
p.clock.tempo = 2.13;
~k = Pbind(\instrument,\bplay,\buf,d["k"][0],\dur,1,\amp,1);
~k.play;
)
//Basic 5-16 euclidean rhythm
(
~c = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7);
~c.play;
)
//add another layer at a different pitch
//NOTE: These two might not sound at the same time even though they are the same rhythm, as the rhythmic cycle is longer than 1 beat
(
~c2 = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7,\rate,1.1);
~c2.play;
)
//if you want them to sound together, trigger them together
(
~c2 = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7,\rate,1.1);
~c = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(5,16)/4,\amp,0.7);
)
//offset both
//Note: I am using .asStream here, because a standard Pwhite will not work in the offset argument of Pbjorklund2, as the values need to be embedded as a stream.
//A general rule of mine is that if pattern classes don't work properly, use .asStream on the end of them and they likely will.
(
~c = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(5,16,inf,Pwhite(1,10).asStream)/4,\amp,0.7);
~c2 = Pbind(\instrument,\bplay,\buf,d["t"][0],\dur,Pbjorklund2(5,16,inf,Pwhite(1,15).asStream)/4,\amp,0.7,\rate,1.1);
~c.play;
~c2.play;
)
//and another, slightly different sample
(
~c3 = Pbind(\instrument,\bplay,\buf,d["t"][1],\dur,Pbjorklund2(5,16,inf,Pwhite(0,8).asStream)/4,\amp,0.7,\rate,0.9);
~c3.play
)
//now do the same to the kick
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][2],\dur,Pbjorklund2(3,8)/4,\amp,1,\rate,Pseq([1,1.2],inf));
)
//another kick, slightly different rhythm
(
~k2 = Pbind(\instrument,\bplay,\buf,d["k"][2],\dur,Pbjorklund2(3,16,inf,Pwhite(1,10).asStream)/4,\amp,1,\rate,Pseq([1.1,1.4],inf));
~k2.play;
)
//add sub kick on 1, and you have minimal techno.
(
~sk = Pbind(\instrument,\bplay,\buf,d["sk"][0],\dur,1,\amp,2);
~sk.play;
)



//give a central rhythm to be used by other patterns
l = Pbjorklund2(Pseq([3,3,3,4,3,3,3,5],inf),8)/4;
//block-execute (Ctrl/Cmd+Enter) between these brackets
(
p.clock.tempo = 2.1;
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1,\rate,0.9);
~c3 = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1,\rate,1.1);
~c2 = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1);
~c.play;
~c2.play;
~c3.play;
)
//now individually execute (Shift+Enter) some of these lines to refresh the 'dur'. Listen for variations in rhythm.
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1,\rate,0.9);
~c3 = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1,\rate,1.1);
~c2 = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1);
//if you want to reset, execute the block again





//Start with a random central rhythm, to keep all of the individual parts
//also using a scale as a one-letter variable for quickness
(
p.clock.tempo = 2.32;
l = Pbjorklund2(Pwhite(3,10),16)/4;
e = Scale.chromatic(\et53);
~ring1 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-2,2),\octave,Pwrand([3,4],[0.8,0.2],inf),\dur,l,\d,0.4,\a,Pexprand(0.5,30),\amp,0.5,\pan,1);
~ring2 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-2,2),\octave,Pwrand([3,4],[0.8,0.2],inf),\dur,l,\d,0.4,\a,Pexprand(0.5,30),\amp,0.5,\pan,-1);
~ring3 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-5,5),\octave,Pwrand([4,5],[0.8,0.2],inf),\dur,l,\d,0.5,\a,Pexprand(0.5,30),\amp,0.5,\pan,0);
~ring4 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-5,5),\octave,Pwrand([2,3],[0.8,0.2],inf),\dur,l,\d,0.2,\a,Pexprand(0.5,200),\amp,0.9,\pan,0);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,l,\amp,1);
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,l,\amp,Pwhite(0.2,1));
~ring1.play;~ring2.play;~ring3.play;~ring4.play;~sn.play;~c.play;~h.play;
)
//unify all of these rhythms
//sounds very different
//execute individual lines to make them diverge from this pattern
(
p.clock.tempo = 2.32;
l = Pbjorklund2(Pseq([3,8,2,5,9,10,14,3,5,5,4,9,14],inf),16)/4;
e = Scale.chromatic(\et53);
~ring1 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-2,2),\octave,Pwrand([3,4],[0.8,0.2],inf),\dur,l,\d,0.4,\a,Pexprand(0.5,90),\amp,0.5,\pan,1);
~ring2 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-2,2),\octave,Pwrand([3,4],[0.8,0.2],inf),\dur,l,\d,0.4,\a,Pexprand(0.5,90),\amp,0.5,\pan,-1);
~ring3 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-5,5),\octave,Pwrand([4,5],[0.8,0.2],inf),\dur,l,\d,0.5,\a,Pexprand(0.5,90),\amp,0.5,\pan,0);
~ring4 = Pbind(\instrument,\ring1,\f,Pkey(\freq),\scale,e,\root,0,\degree,Pwhite(-5,5),\octave,Pwrand([2,3],[0.8,0.2],inf),\dur,l,\d,Pexprand(0.2,0.6),\a,Pexprand(1,200),\amp,0.9,\pan,0);
~sn = Pbind(\instrument,\bplay,\buf,d["s"][0],\dur,l,\amp,1);
~c = Pbind(\instrument,\bplay,\buf,d["c"][0],\dur,l,\amp,1);
~h = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,l,\amp,Pwhite(0.2,1))
)
//throw some straight rhythms in to show where the beat lies
(
~k = Pbind(\instrument,\bplay,\buf,d["k"][1],\dur,1,\rate,1,\amp,3);
~oh = Pbind(\instrument,\bplay,\buf,d["oh"][1],\dur,Pseq([0.5,Pseq([1],inf)],inf),\amp,Pwhite(0.5,1),\rate,0.8);
~k.play;
~oh.play;
)






(
~sinfb = Pbind(\instrument,\sinfb,\freq,Pwhite(100,800),\dur,0.1,\amp,0.3,\fb,0.1,\rel,0.3);
~sinfb.play;
)
//frequency being detuned gradually
(
~sinfb = Pbind(\instrument,\sinfb,\freq,Pseq((1..8),inf)*100,\dur,0.1,\amp,0.3,\fb,0.4,\rel,1,\detune,Pseq((1..400),inf));
)

(
~sinfb = Pbind(
	\instrument, \sinfb,
	\scale, Scale.minor(\just),
	\root, Pwhite(0, 4).stutter(8),
	\octave, Pwhite(4, 5).stutter(8),
	\degree, Pseq((0..7), inf),
	\dur, 0.5,
	\amp, 0.3,
	\fb, 1,
	\rel, 0.2
);
~sinfb.play;
)


(
~sinfb = Pbind(\instrument,\sinfb,
    \scale, Scale.major,
    \root, 0,
    \octave, Pwrand([4, [3, 4], [2, 3, 4]], [0.9, 0.08, 0.02],inf),
    \degree, Prand([
		[0, 2, 4],
		[2, 4, 6],
		[7, 2, 4],
		[1, 2, 3],
		[0, -2, -4]
	],inf),
    \dur, Pwhite(5,10),
    \atk, 2,
	\sus, 1,
	\rel, 3,
	\amp, 0.3,
	\fb, 0.1
);
~modulation = {SinOsc.kr(0.1).range(0.01,1.41)};
~sinfb.play;
~sinfb.set(\fb,~modulation);
)






