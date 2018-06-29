(
SynthDef.new(\simple_subtractive, {
	arg note, cutoff_freq, res;
	var osc1, amp_env, signal, filter_env;
	filter_env = EnvGen.kr(
		Env.new([1, 0], [0.5])
	);
	osc1 = RLPF.ar(Saw.ar(note.midicps)!2, cutoff_freq * filter_env, res);
	amp_env = EnvGen.kr(
		Env.new([0, 1, 0.8, 0.8, 0], [0.01, 0.2, 0.1, 0.2]),
		doneAction: 2
	);
	signal = osc1 * amp_env;
	Out.ar(0, signal);
}).add;
)

s = Synth(\simple_subtractive, [\note, 32, \cutoff_freq, 4000, \res, 0.1]);

(
Pbind(
    \instrument, \simple_subtractive,
    \note, Pseq([32, 32, 44, 44, 39, 39, 35, 35], inf),
	\cutoff_freq, 4000,
	\res, 0.1
).play;
)
