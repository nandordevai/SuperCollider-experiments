(
SynthDef("hihat", {
	arg
	out = 0,
	amp = 0.5,
	att = 0.01,
	rel = 0.1, // open
	// rel = 0.5, // open
	ffreq = 7000,
	pan = 0;

	var env = Env.perc(att, rel, amp).kr(doneAction: 2);
	var snd = HPF.ar(in: WhiteNoise.ar, freq: ffreq) * env;
	Out.ar(out, Pan2.ar(snd, pan));
}).play;
);

(
SynthDef("snare", {
	arg
	out = 0,
	amp = 1,
	sinfreq = 180,
	att = 0.01,
	rel = 0.2,
	ffreq = 2000,
	pan = 0;

	var env = Env.perc(att, rel, amp).kr(doneAction: 2);
	var snd1 = HPF.ar(
		in: WhiteNoise.ar,
		freq: ffreq
	);
	var snd2 = SinOsc.ar(
		freq: sinfreq
	);
	var sum = (snd1 + snd2) * env;
	Out.ar(out, Pan2.ar(sum, pan));
}).play;
);

(
SynthDef("kick", {
	arg
	out = 0,
	amp = 1,
	sinfreq = 60,
	glissf = 0.9,
	att = 0.01,
	rel = 0.45,
	pan = 0;

	var env, snd, ramp;

	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	ramp = XLine.kr(
		start: sinfreq,
		end: sinfreq * glissf,
		dur: rel
	);
	snd = SinOsc.ar(freq: ramp, mul: env);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
}).play;
);