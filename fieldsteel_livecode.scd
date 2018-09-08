MIDIIn.connectAll;

m = MIDIOut.new(0);
m.latency = 0;

m.noteOn(0, 60, 64);
m.noteOff(0, 60, 64);

(
Tdef(\t0, {
	loop{
		var note;
		note = {Scale.minorPentatonic.degrees.choose+50+[36,48].choose}.dup([2,3,4].choose);
		note.do({
			arg n;
			m.noteOn(0, n, 5);
		});
		0.125.wait;
		note.do({
			arg n;
			m.noteOff(0, n);
		});
		[1.875].choose.wait;
	};
}).play;
)

Tdef(\t0).stop;

r.stop

m.noteOff(0, [ 87, 63, 36, 54 ])

(
CmdPeriod.add({
	(0..127).do({
		arg n;
		m.noteOff(0, n);
	});
});
)

r.stop;

////////////////////////////////

t = TempoClock.new(108/60).permanent_(true);
t.schedAbs(t.nextBar, {t.beats.postln;4});
t.stop;
Pbindef(\p0).play(t, quant:4);

(
Pbindef(\p0,
	\type, \midi,
	\dur, 1/4,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, Pseq([38,38,50],inf)+Prand([24,12,3,0,-12],inf)+12,
	\amp, 0.05,
	\sustain, Pexprand(0.01,1,inf),
).quant_(4);
)

Pbindef(\p0).stop;
Pbindef(\p0).clear;

m.control(0, 20, 60);
m.control(0, 20, 61);

Pbindef(\p1).play(t, quant:4);

(
Pbindef(\p1,
	\type, \midi,
	\dur, 1,
	\midicmd, \control,
	\midiout, m,
	\chan, 0,
	\ctlNum, 20,
	\control, Pwhite(0,127,inf),
).quant_(4);
)

Pbindef(\p1).stop;
Pbindef(\p1).clear;

////////////////////////////

Ndef.all.do({arg n; n.clear});

Ndef(\clock).fadeTime_(0).play;

~beatBus = Bus.control(s, 1);
~divBus = Bus.control(s,1);
~bpm = 108;
(
Ndef(\clock, {
	Out.kr(~beatBus, Impulse.kr(~bpm/60));
	Out.kr(~divBus, Impulse.kr(4*~bpm/60));
});
)

Ndef(\a).fadeTime_(3).play;
Ndef(\a).clear(10);
(
Ndef(\a, {
	arg amp=0.05, pan=0;
	var sig, env, gate, freq;
	gate = In.kr(~divBus);
	freq = TChoose.kr(gate, [38]);
	freq = freq + TChoose.kr(gate, [-12,0]);
	freq = freq.midicps;
	sig = PMOsc.ar(freq, freq*TChoose.kr(gate,[0.5,1,1.5,2,3]), 2);
	env = Env.perc(0,0.5,1,-6).kr(0, gate);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
});
)

Ndef(\c).fadeTime_(3).playN([0,1,~verbBus.index,~verbBus.index+1],[1,1,0.5,0.5]);
Ndef(\c).clear;
Ndef(\c).clear(5);
(
Ndef(\c, {
	arg amp=0.05, pan=0;
	var sig, env, gate, freq;
	gate = In.kr(~divBus);
	freq = TChoose.kr(gate, Scale.minorPentatonic.degrees+50);
	freq = freq + TChoose.kr(gate, [0,12,24,36]);
	freq = freq.midicps;
	sig = PMOsc.ar(freq, freq*TChoose.kr(gate,[0.5,1,1.5,2,3]), 1);
	env = Env.perc(0,0.2,1,-6).kr(0, gate);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
});
)

~verbBus = Bus.audio(s, 2);

Ndef(\verb).fadeTime_(3).play(0);

Ndef(\a).playN([0,1,~verbBus.index,~verbBus.index+1],[1,1,0.5,0.5]);

(
Ndef(\verb, {
	GVerb.ar(In.ar(~verbBus, 2), 200, 3);
})
)

Ndef(\verb).clear;

Ndef(\b).fadeTime_(3).playN([0,1,~verbBus.index,~verbBus.index+1],[1,1,0.5,0.5]);

(
Ndef(\b, {
	arg pan=0, amp=0.05;
	var sig, env, gate;
	gate = In.kr(~divBus, 1);
	sig = WhiteNoise.ar;
	sig = RLPF.ar(sig, TExpRand.kr(1000,15000,gate), 0.2);
	env = Env.perc(0,0.05,1,-4).kr(0,gate);
	sig = Pan2.ar(sig, TRand.kr(-0.5,0.5,gate), amp);
	sig = sig * env;
});
)

Ndef(\b).clear(10);
