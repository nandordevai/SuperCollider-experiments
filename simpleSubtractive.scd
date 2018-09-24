MIDIClient.init;
MIDIIn.connectAll;

(
SynthDef.new(\mono, {
	arg
	note,
	cutoff_freq = 4000,
	res = 0.1,
	gate = 1;

	var
	osc1,
	filter_out,
	amp_env,
	signal,
	filter_env,
	gen;

	filter_env = EnvGen.kr(
		Env.new([1, 0.01], [0.5], 'exp')
	);
	amp_env = Env.adsr(0.01, 0.2, 0.8, 0.2);
	gen = EnvGen.kr(amp_env, gate, doneAction: 2);
	osc1 = Saw.ar(note.midicps)!2;
	filter_out = RLPF.ar(osc1, cutoff_freq * filter_env, res);
	signal = filter_out * gen;
	Out.ar(0, signal);
}).add;
);

~notes = Array.newClear(128);

(
MIDIdef.noteOn(\noteOn, {
	arg velocity, note;
	~notes[note] = Synth(
		\mono, [
			\note, note,
			\cutoff_freq, velocity.linexp(0, 127, 200, 15000)
	]);
});
);

(
MIDIdef.noteOff(\noteOff, {
	arg velocity, note;
	~notes[note].set(*[gate: 0]);
});
);

(
MIDIdef.cc(\modwheel, {
	arg val;
	~notes.do {
		arg synth;
		var freq;
		freq = val.linlin(0, 127, 400, 18000);
		synth.set(\cutoff_freq, freq);
	};
});
);
