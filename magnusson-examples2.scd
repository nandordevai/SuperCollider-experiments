StageLimiter.activate

{Klang.ar(`[ [430, 810, 1050, 1220], [0.23, 0.13, 0.23, 0.13], [pi,pi,pi, pi]], 1, 0)}.play

(
SynthDef(\saklangbell, {arg freq=400, amp=0.4, dur=2, pan=0.0; // we add a new argument
    var signal, env;
    env = EnvGen.ar(Env.perc(0.01, dur), doneAction:2); // doneAction gets rid of the synth
    signal = Klang.ar(`[freq * [1.2,2.1,3.0,4.3], [0.25, 0.25, 0.25, 0.25], nil]) * env;
    signal = Pan2.ar(signal, pan);
    Out.ar(0, signal);
}).add
)

Synth(\saklangbell, [\freq, 100])

(
{
    DynKlang.ar(`[
        [800, 1000, 1200] + SinOsc.kr([2, 3, 0.2], 0, [130, 240, 1200]),
        [0.6, 0.4, 0.3],
        [pi,pi,pi]
    ]) * 0.1
}.play;
)

// amplitude modulation
(
{
    DynKlang.ar(`[
        [800, 1600, 2400, 3200],
        [0.1, 0.1, 0.1, 0.1] + SinOsc.kr([0.1, 0.3, 0.8, 0.05], 0, [1, 0.8, 0.8, 0.6]),
        [pi,pi,pi]
    ]
) * 0.1
}.play;
)

{
    var modulator, carrier;
    modulator = SinOsc.ar(MouseX.kr(2, 2000, 1), mul:0.5, add:1);
    carrier = Saw.ar(533, modulator);
    carrier ! 2 // the output
}.play

(
{
    var modulator, carrier;
    modulator = SinOsc.ar(MouseX.kr(2, 20000, 1)).abs;
    carrier = SinOsc.ar(MouseY.kr(200,2000), 0, modulator);
    carrier!2 // the output
}.play
)

(
// the same as above - with explanations:
{
SinOsc.ar(2000     // the carrier and the carrier frequency
    + SinOsc.ar(MouseX.kr(2,2000,1),  // the modulator and the modulator frequency
        0,                       // the phase of the modulator
        MouseY.kr(1,1000)           // the modulation depth (index)
        ),
0,        // the carrier phase
0.5)    // the carrier amplitude
}.play
)

{ PMOsc.ar(MouseX.kr(500,2000), 600, 3, 0, 0.1) }.play; // modulate carfreq
{ PMOsc.ar(2000, MouseX.kr(200,1500), 3, 0, 0.1) }.play; // modulate modfreq
{ PMOsc.ar(2000, 500, MouseX.kr(0,10), 0, 0.1) }.play; // modulate index

(
e = Env.linen(2, 5, 2);
fork{
    inf.do({
        { LinPan2.ar(EnvGen.ar(e)
            *
            PMOsc.ar(2000.0.rand,800.0.rand, Line.kr(0, 12.0.rand,9),0,0.1),
            1.0.rand2)
            }.play;
        2.wait;
    })
}
)

(
{ var freq, ratio, modulator, carrier;
    freq = LFNoise0.kr(4, 20, 60).round(1).midicps;
    ratio = MouseX.kr(1,4);
    modulator = SinOsc.ar(freq * ratio, 0, MouseY.kr(0.1,10));
    carrier = SinOsc.ar(freq, modulator, 0.5);
    carrier
}.play
)

(
var carrier, carFreq, carAmp, modulator, modFreq, modAmp;
carFreq = 2000;
carAmp = 0.2;
modFreq = 327;
modAmp = 0.2;
{
    modAmp = MouseX.kr(0, 1);     // choose normalized range for modulation
    modFreq = MouseY.kr(10, 1000, 'exponential');
    modulator = SinOsc.ar( modFreq, 0, modAmp);
    carrier = SinOsc.ar( carFreq + (modulator * carFreq), 0, carAmp);
    [ carrier, carrier, modulator ]
}.play
)

(
SynthDef(\fmsynth, {arg outbus = 0, freq=440, carPartial=1, modPartial=1, index=3, mul=0.2, ts=1;
    var mod, car, env;
    // modulator frequency
    mod = SinOsc.ar(freq * modPartial, 0, freq * index );
    // carrier frequency
    car = SinOsc.ar((freq * carPartial) + mod, 0, mul );
    // envelope
    env = EnvGen.ar( Env.perc(0.01, 1), doneAction: 2, timeScale: ts);
    Out.ar( outbus, car * env)
}).add;
)

Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \ts, 1]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 2.5, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 3.5, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 4.0, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 300.0, \carPartial, 1.5, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 0.5, \ts, 2]);

Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 300.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 400.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 800.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);

Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1.1, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 600.0, \carPartial, 1.5, \modPartial, 1.15, \ts, 2]);
Synth(\fmsynth, [ \outbus, 0, \freq, 40.0, \carPartial, 4.75, \modPartial, 1, \ts, 2]);

(
SynthDef(\fmsynthenv, {arg outbus = 0, freq=440, carPartial=1, modPartial=1, index=3, mul=0.2, ts=1;
    var mod, car, env;
    var modfreqenv, modindexenv;
    modfreqenv = EnvGen.kr(Env.perc(0.1, ts/10, 0.125))+1; // add 1 so we're not starting from zero
    modindexenv = EnvGen.kr(Env.sine(ts, 1))+1;
    mod = SinOsc.ar(freq * modPartial * modfreqenv, 0, freq * index * modindexenv);
    car = SinOsc.ar((freq * carPartial) + mod, 0, mul );
    env = EnvGen.ar( Env.perc(0.01, 0.3), doneAction: 2, timeScale: ts);
    Out.ar( outbus, Pan2.ar(car * env))
}).add;
)

Synth(\fmsynthenv, [ \freq, 440.0, \ts, 4]);
Synth(\fmsynthenv, [ \freq, 440.0, \ts, 1]);
Synth(\fmsynthenv, [ \freq, 36, \ts, 0.75]);
Synth(\fmsynthenv, [ \freq, 42, \ts, 0.75]);
Synth(\fmsynthenv, [ \freq, 50, \ts, 0.75]);

