x = { SinOsc.ar([300, 500]) }.play;

(
SynthDef.new(\multi, {
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new([0, 1, 0], [10, 10], [1, -1]),
		doneAction: 2
	);
	amp = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0, 1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig);
}).add;
)

Synth.new(\multi)

{ PinkNoise.ar(0.5!2) }.play;
