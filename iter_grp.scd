(
SynthDef.new(\iter, {
	arg freq = 40;
	var temp, sum, env;
	env = EnvGen.kr(
		Env.perc(0.01, 5, 1, -2),
		doneAction: 2
	);
	sum = 0;
	10.do {
		temp = VarSaw.ar(
			freq * { Rand(0.99, 1.02) }!2,
			{Rand(0.0, 1.0)}!2,
			{ExpRand(0.005, 0.05)}!2
		);
		sum = sum + temp;
	};
	sum = sum * 0.1 * env;
	Out.ar(0, sum);
}).add;
)

Synth(\iter);
Synth(\iter, [\freq, 80]);
Synth(\iter, [\freq, 160]);
Synth(\iter, [\freq, 320]);

(
SynthDef.new(\iter2, {
	arg freq = 200, dev = 1.02;
	var temp, sum;
	sum = 0;
	20.do {
		arg count;
		temp = SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({ Rand(0.05, 0.2) }!2).range(dev.reciprocal, dev)
		);
		temp = temp * LFNoise1.kr({ Rand(0.5, 8) }!2).exprange(0.01, 1);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth(\iter2);
x.set(\freq, 180);
x.set(\dev, 1.5);

(
SynthDef.new(\blip, {
	arg out, dust = 2, fund = 300;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund, 4 * fund).round(fund);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(dust);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;
)

(
SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)

~reverbBus = Bus.audio(s, 1);
~reverbBus2 = Bus.audio(s, 2);

~srcGroup = Group.new();
~fxGroup = Group.after(~srcGroup);

b = Synth(\blip, [\out, ~reverbBus2], ~srcGroup);
r = Synth(\reverb, [\in, ~reverbBus2], ~fxGroup);
b.set(\dust, 10);
b.free;

8.do {
	Synth(
		\blip,
		[
			\out, ~reverbBus2,
			\fund, exprand(60, 300).round(30)
		],
		~srcGroup
	);
}

~srcGroup.set(\fund, 300);
~srcGroup.free;

Server.default
