(
SynthDef.new(\sine, {
	arg freq = 440, attack = 0.005, release = 0.3, amp = 1, pan = 0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0, 1, 0], [attack, release], [1, -1]), doneAction: 2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
	}).add;
)

(
Pdef(\pattern,
	Pbind(
		// \type, \note,
		\instrument, \sine,
		// \dur, Pseq([0.6, 0.15, 0.15, 0.1], inf).trace,
		\dur, Pwhite(0.05, 0.5, inf),
		// \freq, Pseq([330, 247, 370, 220], inf)
		// \midinote, Pseq([62, 74, 69, 64], inf),
		// \freq, Pexprand(50, 4000, inf).round(55),
		\note, Pseq([3], inf),
		\gtranspose, -12,
		\harmonic, Pexprand(1, 80, inf).round,
		\attack, Pwhite(1.0, 2.0, inf),
		\release, Pwhite(2.0, 6.0, inf),
		// \amp, Pexprand(0.01, 0.2, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).play;
)

d = Dictionary.new;

(
d.add(\drum ->
	PathName("/Users/nandi/Music/Samples/Roland PB-300 Rhythm Plus").entries.collect({
		arg sf;
		Buffer.read(s, sf.fullPath);
	});
);
)

d[\drum].choose.play;

(
SynthDef.new(\pb300, {
	arg buf = 0, rate = 1, amp = 1;
	var sig;
	sig = PlayBuf.ar(1, buf, BufRateScale.ir(buf) * rate, doneAction: 2);
	sig = sig * amp;
	Out.ar(0, sig!2);
}).add;
)

// 0 hh_closed.wav
// 1 hh_open.wav
// 2 kick.wav
// 3 kick2.wav
// 4 ride.wav
// 5 snare.wav
// 6 wood.wav

(
Pdef(\drumseq,
	Pbind(
		\instrument, \pb300,
		\dur, Pseq([1/16], inf),
		\stretch, 60 / 128 * 4,
		// \buf, Pxrand(d[\drum], inf),
		\buf, Pwrand(
			[d[\drum][0], d[\drum][1], d[\drum][2], d[\drum][3], d[\drum][4], d[\drum][5], d[\drum][6]],
			// [0.3, 0.2, 0.2, 0.1, 0.1, 0.05, 0.05],
			[6, 4, 4, 2, 2, 1, 1].normalizeSum,
			inf
		),
		\rate, 1,
		// \amp, Pseq([0.7] ++ (0.2!7), inf),
		\amp, Pseq([Pexprand(0.7, 0.9, 1), Pexprand(0.1, 0.3, 7)], inf),
	);
// ).play(quant: 60 / 128 * 4);
).quant_(60 / 128 * 4);
)
