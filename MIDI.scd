MIDIClient.sources;
MIDIClient.restart;
MIDIClient.init();
MIDIIn.connectAll;
MIDIIn.connect(2);

MIDIdef.noteOn(\noteOnTest, { "key down".postln });
MIDIdef(\noteOnTest).disable;
MIDIdef(\noteOnTest).enable;
MIDIdef(\noteOnTest).free;
MIDIdef.noteOn(\noteOnTest, { "key down".postln }).permanent_(true);

(
MIDIdef.noteOn(\noteOnTest, {
	arg velocity, note, channel, src;
	{
		var sig, env;
		sig = SinOsc.ar(note.midicps)!2;
		env = EnvGen.kr(Env.perc, doneAction: 2);
		sig = sig * env * velocity.linexp(1, 127, 0.01, 0.3);
	}.play
});
)

(
SynthDef.new(\midi, {
	arg freq = 220, amp = 0.3;
	var sig, env;
	sig = SinOsc.ar(freq)!2;
	env = EnvGen.kr(Env.perc, doneAction: 2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

Synth.new(\midi);

(
MIDIdef.noteOn(\noteOnTest, {
	arg velocity, note, channel, src;
	~notes[note] = Synth.new(
		\midi, [
			\freq, note.midicps,
			\amp, velocity.linexp(1, 127, 0.01, 0.3),
			\gate, 1,
			\bend, ~bend.linlin(0, 16383, -2, 2)
		])
});
)

(
MIDIdef.noteOff(\noteOffTest, {
	arg velocity, note, channel, src;
	~notes[note].set(\gate, 0);
	~notes[note] = nil;
});
)

(
MIDIdef.bend(\bendTest, {
	arg val;
	~bend = val;
	~notes.do {
		arg synth;
		synth.set(\bend, val.linlin(0, 16383, -2, 2));
	};
});
)

~bend = 8192;

(
SynthDef.new(\midi, {
	arg freq = 220, amp = 0.3, gate = 0, bend = 0;
	var sig, env;
	sig = SinOsc.ar(freq * bend.midiratio)!2;
	env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

m = Synth.new(\midi, [\gate, 1]);
m.set(\gate, 0);

~notes = Array.newClear(128);
