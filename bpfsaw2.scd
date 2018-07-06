(
SynthDef(\bpfsaw, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0, pan=0;
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(0.2).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env *amp;
	Out.ar(out, sig);
}).add;
)

(
10.do {
	Synth(
		\bpfsaw,
		[
			\freq, 50,
			\amp, 0.4,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, rrand(-1, 1),
		],
	);
}
)

(
SynthDef(\bpfsaw_pan, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0, pan=0;
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5, detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin, cfmax),
		LFNoise1.kr(0.1).exprange(rqmin, rqmax)
	);
	sig = PanAz.ar(8, sig, LFNoise1.kr(0.5));
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
10.do {
	Synth(
		\bpfsaw_pan,
		[
			\freq, 40,
			\amp, 0.5,
			\cfmin, 200,
			\cfmax, 2000,
			\rqmin, 0.05,
			\rqmax, 0.03,
		],
	);
}
)

(
SynthDef(\bpfsaw_rand, {
	arg atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0, pan=0, cfhzmin=0.1, cfhzmax=0.3, lsf=200, ldb=0;
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction: 2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5, detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(
			LFNoise1.kr(4).exprange(cfhzmin, cfhzmax)
		).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
	sig = BLowShelf.ar(sig, lsf, 0.5, ldb);
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
10.do {
	Synth(
		\bpfsaw_rand,
		[
			\freq, 50,
			\amp, 0.5,
			\cfmin, 100,
			\cfmax, 2500,
			\rqmin, 0.01,
			\rqmax, 0.05,
			\cfhzmin, 1,
			\cfhzmax, 5,
			\ldb, 6,
		],
	);
}
)

Synth.new(
	\bpfsaw_rand,
	[
		\freq, 4,
		\atk, 0,
		\rqmin, 0.005,
		\rqmax, 0.008,
		\cfmin, 880,
		\cfmax, 880
	]
)

~marimba = Pbind(
	\instrument, \bpfsaw_rand,
	\dur, Prand([0.5, 1], inf),
	\freq, Prand([1/2, 2/3, 1, 4/3, 2, 5/2, 3, 4, 6, 8], inf),
	\detune, 0,
	\rqmin, 0.005,
	\rqmax, 0.008,
	\cfmin, Prand((Scale.minor.degrees + 64).midicps, inf) * Prand([0.5, 1, 2], inf),
	\cfmax, Pkey(\cfmin) * Pwhite(1.008, 1.025, inf),
	\atk, 3,
	\sus, 1,
	\rel, 5,
	\amp, 1,
).play;

~chords = Pbind(
	\instrument, \bpfsaw_rand,
	\dur, Pwhite(4.5, 7.0, inf),
	\midinote, Pxrand([
		[23, 35, 54, 63, 64],
		[45, 52, 54, 59, 61, 64],
		[28, 40, 47, 56, 59, 63],
		[42, 52, 57, 61, 63]
	], inf),
	\detune, Pexprand(0.05, 0.2, inf),
	\cfmin, 100,
	\cfmax, 1500,
	\rqmin, Pexprand(0.01, 0.15, inf),
	\atk, Pwhite(2.0, 2.5, inf),
	\rel, Pwhite(6.5, 10.0, inf),
	\ldb, 6,
	\amp, 0.2,
	\out, 0,
).play;

~chords.stop;

~marimba.stop;
