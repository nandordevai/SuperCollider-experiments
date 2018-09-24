StageLimiter.activate;

(
SynthDef('saw', {
	var
	freq = 220,
	detune = 0.2,
	signal,
	osc1,
	osc2,
	lfo1,
	lfo1_amount = -0.25,
	filter;

	osc1 = Saw.ar(freq: freq);
	osc2 = Saw.ar(freq: freq + detune);
	lfo1 = SinOsc.kr(freq: 1).abs();
	filter = RLPF.ar(
		in: [osc1, osc2],
		freq: 1000 * (1 + (lfo1 * lfo1_amount))
	);
	signal = FreeVerb.ar(
		in: filter,
		mix: 0.5,
		room: 1
	);

	Out.ar(0, Pan2.ar(signal, 0));
}).add();
)

~saw = Synth('saw');