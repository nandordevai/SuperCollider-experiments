StageLimiter.activate;

p= ProxySpace.push(s.boot)

~signal.play;
~signal.fadeTime_(2) // fading in and out in 2 secs
~signal= {SinOsc.ar(400, 0, 1)!2}
~signal= {SinOsc.ar([400, 404], 0, LFNoise0.kr(4))}
~signal= {Saw.ar([400, 404],  LFNoise0.kr(4))}
~signal= {Saw.ar([400, 404],  Pulse.ar(2))}
~signal= {Saw.ar([400, 404],  Pulse.ar(Line.kr(1, 30, 20)))}
~signal= {LFSaw.ar([400, 404],  LFNoise0.kr(4))}
~signal= {Pulse.ar([400, 404],  LFNoise0.kr(4))}
~signal= {Blip.ar([400, 404],  12, Pulse.ar(2))}
~signal= {Blip.ar([400, 404],  24, LFNoise0.kr(4))}
~signal= {Blip.ar([400, 404],  4, LFNoise0.kr(4))}
~signal= {Blip.ar([400, 404],  MouseX.kr(4, 40), LFNoise0.kr(4))}
~signal= {Blip.ar([200, 204],  5, Pulse.ar(1))}

// now let's try to add some effects

~signal[1] = \filter -> {arg sig; (sig*0.6)+FreeVerb.ar(sig, 0.85, 0.86, 0.3)}; // reverb
~signal[2] = \filter -> {arg sig; sig + AllpassC.ar(sig, 1, 0.15, 1.3 )}; // delay
~signal[3] = \filter -> {arg sig; (sig * SinOsc.ar(2.1, 0, 5.44, 0))*0.5}; // tremolo
~signal[4] = \filter -> {arg sig; PitchShift.ar(sig, 0.008, SinOsc.ar(2.1, 0, 0.11, 1))}; // pitchshift
~signal[5] = \filter -> {arg sig; (3111.33*sig.distort/(1+(2231.23*sig.abs))).distort*0.2}; // distort
~signal[1] = nil;
~signal[2] = nil;
~signal[3] = nil;
~signal[4] = nil;
~signal[5] = nil;


~blipper = { |freq=20, nHarm=30, amp=0.1| Blip.ar(freq, nHarm, amp)!2 };
~blipper.play;
~lfo = { MouseX.kr(10, 100, 1) };
~blipper.map(\freq, ~lfo);
~blipper.set(\nHarm, 50)
~lfn = { LFDNoise3.kr(15, 30, 40) };
~blipper.map(\nHarm, ~lfn);
~lfn = 30;
~blipper.set(\nHarm, 50);

(
SynthDef(\ch3synth1, {arg freq=333, amp=0.4, pan=0.0, dur=0.41; // the arguments
    var signal, env;
    env = EnvGen.ar(Env.perc(0.001, dur), doneAction:2); // doneAction kills the synth
    signal = LFTri.ar(freq, 0, amp) * env; // the envelope multiplies the signal
    signal = Pan2.ar(signal, pan);
    Out.ar(0, signal);
}).add;
)

(
m = ([ 0, 1, 5, 6, 10, 12 ]+48).midicps;
m = m.scramble; // try to re-evaluate only this line
t = Task({
    inf.do({arg i;
        Synth(\ch3synth1, [\freq, m.wrapAt(i)]);
        0.25.wait;
    })
});
t.play;
)

(
SynthDef(\patsynth1, { arg out=0, freq=440, amp=0.1,  pan=0, cutoff=1000, gate = 1;
    var signal = MoogFF.ar( Saw.ar(freq, amp), cutoff, 3);
    var env = EnvGen.kr(Env.adsr(), gate, doneAction: 2);
    Out.ar(out, Pan2.ar(signal, pan, env) );
}).add;
)

// we play our 'patsynth1' instrument, and control the cutoff parameter
Pbind(\instrument, \patsynth1, \freq, 100, \cutoff, 300, \amp, 0.6).play;
// try this as well:
Pbind(\instrument, \patsynth1, \freq, 100, \cutoff, 3000, \amp, 0.6).play;
Pbind(\instrument, \patsynth1, \freq, 100, \amp, 0.6, \dur, 0.5).play;
Pbind(\instrument, \patsynth1, \freq, 100, \amp, 0.6, \dur, 0.5, \sustain, 0.1).play;

(
Pbind(
    \instrument, \patsynth1,
    \freq, Pseq([100, 200, 120, 180], inf), // sequencing frequency
    \amp, 0.6,
    \dur, 0.5
).play;
)

(
Pbind(
    \instrument, \patsynth1,
    \freq, Prand([100, 200, 120, 180], inf),
    \amp, Pseq([0.3, 0.6], inf),
    \dur, Pseq([0.125, 0.25, 0.5, 0.25], inf),
).play;
)

(
Pbind(
    \instrument, \patsynth1,
    \freq, Pseq([100, 200, 120, 180], inf),
    \cutoff, Pseq([1000, 2000, 3000], inf), // only 3 items in the list - it loops
    \amp, Pseq([0.3, 0.6], inf),
    \dur, Pseq([0.125, 0.25, 0.5, 0.25], inf),
).play;
)

(
a = Pdef.new(\example1,
        Pbind(\instrument, \patsynth1, // using our sine synthdef
            \freq, Pseq([220, 440, 660, 880], inf), // freq arg
            \dur, Pseq([0.25, 0.5, 0.25, 0.5], inf);  // dur arg
        )
);
)

a.play;
a.pause;
a.resume;

(
Pdef(\example2,
    Pbind(\instrument, \patsynth1, // using our sine synthdef
        \freq, Pseq.new([720, 770, 990, 880], inf), // freq arg
        \dur, Pseq.new([0.25, 0.5, 0.25, 0.5], inf);  // dur arg
    )
);
)

Pdef(\example2).play;
Pdef(\example2).pause;
Pdef(\example2).resume;

(
Pdef(\example1).quant_([2, 0, 0]);
Pdef(\example2).quant_([2, 0.5, 1]); // offset by half a beat
Pdef(\example1).play;
Pdef(\example2).play;
)

(
Pdef(\example1,
    Pbind(\instrument, \patsynth1, // using our sine synthdef
        \freq, Pseq.new([
            Pseq.new([220, 440, 660, 880], 4),
            Pseq.new([220, 440, 660, 880], 4) * 1.5], // transpose the melody
            inf),
        \dur, Pseq.new([0.25, 0.125, 0.125, 0.25, 0.5], inf);  // dur arg
    )
);
)

(
SynthDef(\clocksynth, { arg out=0, freq=440, amp=0.5,  pan=0, cutoff=1000, gate = 1;
    var signal = MoogFF.ar( Saw.ar(freq, amp), cutoff, 3);
    var env = EnvGen.kr(Env.perc(), gate, doneAction: 2);
    Out.ar(out, Pan2.ar(signal, pan, env) );
}).add;
// the clock
t = TempoClock.new;
t.tempo = 2;
t.schedAbs(0, { arg beat, sec;
    Synth(\clocksynth, [\freq, 440]);
    if(beat%4==0, { Synth(\clocksynth, [\freq, 440/4, \amp, 1]); });
    if(beat%2==0, { Synth(\clocksynth, [\freq, 440*4, \amp, 1]); });
1});
)