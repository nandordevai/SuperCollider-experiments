(
~dur = 0.25;
~decay = 2.5;
~muteAmount = 0.5;
~octave = -2;

~onOSCReceive = { |msg, time, addr|
	switch (msg[0],
		'/1/fader1', { ~dur = msg[1] },
		'/1/fader2', { ~decay = msg[1] * 5 },
		'/1/fader3', { ~muteAmount = msg[1] },
	)
};
);

thisProcess.addOSCRecvFunc(~onOSCReceive);

(
SynthDef(\pluck, {
	arg
	amp = 0.1,
	freq = 440,
	mutedString = 0.1,
	decay = 5;

	var env, snd;
	env = Env.linen(0, decay, 0).kr(2);
	snd = Pluck.ar(
		in: WhiteNoise.ar(amp),
		trig: Impulse.kr(0),
		maxdelaytime: 0.1,
		delaytime: freq.reciprocal,
		decaytime: decay,
		coef: mutedString);
	Out.ar(0, [snd, snd]);
}).add();
);

thisThread.randSeed = 4;

(
p = Pbind(*[
	instrument: 'pluck',
	scale: Scale.harmonicMinor,
	degree: Pseq((0..7).scramble, inf),
	ctranspose: Pfunc { ~octave * 12 },
	dur: Pfunc { ~dur },
	decay: Pfunc { ~decay },
	mutedString: Pfunc { ~muteAmount }
]).play(TempoClock(80 / 60));
);

// p.stop();