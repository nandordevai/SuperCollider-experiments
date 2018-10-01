(
SynthDef(\kick, {
    arg
    out = 0,
    pan = 0,
    amp = 1,
	tune = 1,
	popLevel = 0.15,
	clickLevel = 0.2;

    var bodyFreq = EnvGen.ar(Env([261, 120, 51] * tune, [0.035, 0.08], curve: \exp));
    var bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3));
    var body = SinOsc.ar(bodyFreq) * bodyAmp;

    var popFreq = XLine.kr(750, 261, 0.02);
    var popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001));
    var pop = SinOsc.ar(popFreq) * popAmp;

    var clickAmp = EnvGen.ar(Env.perc(0.001, 0.01));
    var click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;

    var snd = (body + (pop * popLevel) + (click * clickLevel)).tanh;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).play;
);

(
SynthDef(\snare, {
	arg
	out = 0,
	pan = 0,
	amp = 1;

	var popFreq = EnvGen.ar(Env([3261, 410, 160], [0.005, 0.01], curve: \exp));
    var popAmp = EnvGen.ar(Env.perc(0.001, 0.11)) * 0.7;
    var pop = SinOsc.ar(popFreq) * popAmp;
    var noiseAmp = EnvGen.ar(Env.perc(0.01, 0.2));
    var noise = BPF.ar(WhiteNoise.ar, 810, 1.6) * noiseAmp;

    var snd = (pop + noise);

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).play;
);

(
SynthDef(\clap, {
	arg
	out = 0,
	amp = 0.5,
	pan = 0,
	dur = 1;

    var env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

	var noise1 = BPF.ar(
		in: LPF.ar(
			in: HPF.ar(
				in: WhiteNoise.ar(env1),
				freq: 600),
			freq: XLine.kr(7200, 4000, 0.03)),
		freq: 1620,
		rq: 3);

    var env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    var noise2 = BPF.ar(
		in: LPF.ar(
			in: HPF.ar(
				in: WhiteNoise.ar(env2),
				freq: 1000),
			freq: 7600),
		freq: 1230,
		rq: 0.7,
		mul: 0.7);

    var snd = ((noise1 + noise2) * 2).softclip;

    Out.ar(out, Pan2.ar(snd, pan, amp));
}).play;
);

(
var base;

base = Pbind(\amp, 0.3);

Ppar([
    Pbindf(
        base,
        \instrument, Pseq([\kick, \snare, \kick, \kick, \snare], inf),
        \dur, Pseq([4, 3, 3, 2, 4], inf)
    ),
    Pbindf(
        base,
        \instrument, Pseq([Pn(\hihat, 16), Pn(\clap, 16)], inf),
        \dur, Pseq([Rest(2), 2, Rest(2), 2], inf)
    )
]).play(TempoClock(2.3 * 4));
);