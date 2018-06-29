~b0 = Buffer.read(s, "/Users/nandi/Music/Loops/Santoor/70_D_Santoor_01_SP.wav");
~b1 = Buffer.read(s, "/Users/nandi/Music/Loops/Gambian Percussion/140_LaminJamin_21_SP.wav");

~b0.play;
~b1.play;

~b0.zero;
~b0.read("/Users/nandi/Music/Loops/Santoor/70_D_Santoor_01_SP.wav");
~b0.free;
Buffer.freeAll;

~b0.numFrames;
~b0.numChannels;

~b2 = Buffer.readChannel(s, "/Users/nandi/Music/Loops/Gambian Percussion/140_LaminJamin_21_SP.wav", channels: [0]);
~b3 = Buffer.readChannel(s, "/Users/nandi/Music/Loops/Gambian Percussion/140_LaminJamin_21_SP.wav", channels: [1]);

~b2.play;
~b3.play;

s.meter;

~b1.duration;
~b1.bufnum;
~b2.bufnum;

~b1.sampleRate;
s.sampleRate;

~b0.query;

~loops = Array.new;
~folder = "/Users/nandi/Music/Loops";
~loops = ~loops.add(Buffer.read(s, ~folder +/+ "Santoor/70_D_Santoor_01_SP.wav"));
~loops = ~loops.add(Buffer.read(s, ~folder +/+ "Gambian Percussion/140_LaminJamin_21_SP.wav"));
~loops;

~loops[0].play;
~loops[1].play;

(
SynthDef.new(\buftest, {
	arg amp = 1, out = 0, buf, rate = 1, trig = 1, start = 0, loop = 0, doneAction = 2;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, trig, start, loop, doneAction: doneAction);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\buftest, [\buf, ~loops[1], \rate, 0.5]);
~santoor = Synth.new(\buftest, [\buf, ~loops[0], \loop, 1, \rate]);
~santoor = Synth.new(\buftest, [\buf, ~loops[0], \loop, 1, \rate, 7.midiratio]);
~perc = Synth.new(\buftest, [\buf, ~loops[1], \loop, 1, \rate, -1]);
~perc.set(\amp, 2);
~perc.set(\rate, -0.5);

s.plotTree;

(
SynthDef.new(\bufrdtest, {
	arg amp = 1, out = 0, buf, start, end, rate = 1, freq = 1;
	var sig, ptr;
	// ptr = Line.ar(start, end, BufDur.kr(buf), doneAction: 2);
	// ptr = Phasor.ar(0, BufRateScale.kr(buf) * rate, start, end);
	ptr = SinOsc.ar(freq, 3pi / 2).range(start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

// usable!
~santoor1 = Synth.new(\bufrdtest, [\buf, ~loops[0], \start, 0, \end, ~loops[0].numFrames - 1, \freq, 0.03]);
~santoor2 = Synth.new(\bufrdtest, [\buf, ~loops[0], \start, 0, \end, ~loops[0].numFrames - 1, \freq, 0.05]);

~santoor = Synth.new(\bufrdtest, [\buf, ~loops[0], \end, 0, \start, ~loops[0].numFrames, \rate, 0.5]);

(
SynthDef.new(\bufrdnoisetest, {
	arg amp = 1, out = 0, buf, start, end, rate = 1, freq = 1;
	var sig, ptr;
	ptr = LFDNoise1.ar(freq).range(start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

~santoor1 = Synth.new(\bufrdnoisetest, [\buf, ~loops[0], \end, 0, \start, ~loops[0].numFrames, \rate, 0.4]);
~santoor2 = Synth.new(\bufrdnoisetest, [\buf, ~loops[0], \end, 0, \start, ~loops[0].numFrames, \rate, 0.5]);
