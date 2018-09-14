// Tama synth, from https://github.com/Enkerli/tama-synth

(
SynthDef(\tama, {
	arg
	note = 52,
	amp = 1,
	out_bus = 0,
	pan=0.0,
	gate=1,
	tension=0.05,
	loss=0.9,
	vel=1,
	dur=1;

	var signal, freq;
	var lossexp=LinLin.ar(loss,0.0,1.0,0.9,1.0);
	var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
	var excitation = EnvGen.kr(Env.perc, gate, timeScale: 1, doneAction: 0) * PinkNoise.ar(0.4);

	freq = note.midicps;
	signal = amp * MembraneCircle.ar(excitation, tension * (freq / 60.midicps), lossexp);
	DetectSilence.ar(signal, doneAction:2);
	signal = signal * EnvGen.ar(Env.perc, gate, vel * 0.5, 0, dur, 2);
	signal = Pan2.ar(signal, pan);
	Out.ar(out_bus, signal);
}).add();
);

~tension = 0.01;
~loss = 1.99;
~vel = 1;

(
p = Pbind(*[
	instrument: 'tama',
	note: Pseq([60, 80, 75, 80], inf),
	dur: Pseq([1, 0.5, 0.5], inf),
	tension: Pfunc { ~tension },
	loss: Pfunc { ~loss },
	vel: Pfunc { ~vel },
]).play(TempoClock(110 / 60));
);

p.stop();