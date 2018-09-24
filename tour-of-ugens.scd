{Out.ar(0, Dust.ar(10, 0.4))}.play;
{Out.ar(1, Dust.ar(20, 0.4))}.play;

{FreeVerb.ar(Pan2.ar(Dust.ar(25) * 0.5), 0.5, 15, 0.1)}.play;

(
{
    // play with the room size
    var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    x = Pan2.ar(x, -0.2);
    x = [x[0], DelayC.ar(x[1], 0.01, 0.01)]; // de-correlate
    FreeVerb.ar(x, 0.75, 0.9, 0.4);
}.play;
)

(
{
    // play with the room size
    var x;
    x = Klank.ar(`[[400, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    GVerb.ar(x, 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4) + x;
}.play;
)


















// read sound
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
{
    var trate, dur;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    TGrains.ar(2, Impulse.ar(trate), b, 1, MouseX.kr(0,BufDur.kr(b)), dur, 0, 0.1, 2);
}.play;
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.play;
)

// 4 channels
(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 12 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(4, clk, b, 1, pos, dur, pan, 0.1);
}.play;
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(8,120,1);
    dur = 4 / trate;
    clk = Dust.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.play;
)



(
{
    var trate, dur, clk, pos, pan;
    trate = LinExp.kr(LFTri.kr(MouseY.kr(0.1,2,1)),-1,1,8,120);
    dur = 12 / trate;
    clk = Impulse.ar(trate);
    pos = MouseX.kr(0,BufDur.kr(b));
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.play;
)


(
{
    var trate, dur, clk, pos, pan;
    trate = 12;
    dur = MouseY.kr(0.2,24,1) / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b)) + TRand.kr(0, 0.01, clk);
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.play;
)

(
{
    var trate, dur, clk, pos, pan;
    trate = 100;
    dur = 8 / trate;
    clk = Impulse.kr(trate);
    pos = Integrator.kr(BrownNoise.kr(0.001));
    pan = WhiteNoise.kr(0.6);
    TGrains.ar(2, clk, b, 1, pos, dur, pan, 0.1);
}.play;
)

(
{
    var trate, dur, clk, pos, pan;
    trate = MouseY.kr(1,400,1);
    dur = 8 / trate;
    clk = Impulse.kr(trate);
    pos = MouseX.kr(0,BufDur.kr(b));
    pan = WhiteNoise.kr(0.8);
    TGrains.ar(2, clk, b, 2 ** WhiteNoise.kr(2), pos, dur, pan, 0.1);
}.play;
)

(
{
    var trate, dur;
    trate = MouseY.kr(2,120,1);
    dur = 1.2 / trate;
    TGrains.ar(2, Impulse.ar(trate), b, (1.2 ** WhiteNoise.kr(3).round(1)), MouseX.kr(0,BufDur.kr(b)), dur, WhiteNoise.kr(0.6), 0.1);
}.play;
)

// free sound
b.free;




















{ var x; x = BrownNoise.ar(0.2); [x,x] }.play; // correlated
{ {BrownNoise.ar(0.2)}.dup }.play; // not correlated

// correlated
{ var x; x = LPF.ar(BrownNoise.ar(0.2), MouseX.kr(100,10000)); [x,x] }.play;
// not correlated
{ LPF.ar({BrownNoise.ar(0.2)}.dup, MouseX.kr(100,10000)) }.play;


// correlated
(
{ var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(7e-3));
    [x,x]
}.play)
// not correlated
{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([7e-3,7e-3])) }.play;

// two waves mixed together coming out both speakers
{ var x; x = Mix.ar(VarSaw.ar([100,101], 0, 0.1, 0.2)); [x,x] }.play;
// two waves coming out each speaker independently
{ VarSaw.ar([100,101], 0, 0.1, 0.2 * 1.414) }.play; // * 1.414 to compensate for power

// delays as cues to direction
// mono
{ var x; x = LFTri.ar(1000,0,Decay2.ar(Impulse.ar(4,0,0.2),0.004,0.2)); [x,x]}.play;

(
// inter-speaker delays
{ var x; x = LFTri.ar(1000,0,Decay2.ar(Impulse.ar(4,0,0.2),0.004,0.2));
    [DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0.02, 0))]
}.play;
)

(
// mixing two delays together
// you hear a phasing sound but the sound is still flat.
{ var x; x = BrownNoise.ar(0.2);
    x = Mix.ar([DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0,0.02))]);
    [x,x]
}.play;
)

(
// more spatial sounding. phasing causes you to perceive directionality
{ var x; x = BrownNoise.ar(0.2);
    [DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0.02, 0))]
}.play;
)
















(
{
    // mixing sine oscillators in parallel
    var n = 16; // number of structures to make
    // mix together  parallel structures
    Mix.fill(n,
            // this function creates an oscillator at a random frequency
            { FSinOsc.ar(200 + 1000.0.rand) }
    ) / (2*n)            // scale amplitude
}.play;
)

(
{
    // mixing sine oscillators in parallel
    var n = 16; // number of structures to make
    // mix together  parallel structures
    Mix.fill(n,
            // this function creates an oscillator at a random frequency
            { FSinOsc.ar(200 + 1000.0.rand + [0, 0.5]) }
    ) / (2*n)            // scale amplitude
}.play;
)

(
{
    // mixing sine oscillators in parallel
    var n = 16; // number of structures to make
    // mix together  parallel structures
    Mix.fill(n,
            {
                var amp;
                amp = FSinOsc.kr(exprand(0.1,1),2pi.rand).max(0);
                Pan2.ar(
                    FSinOsc.ar(exprand(100,1000.0), 0, amp),
                    1.0.rand2)
            }
    ) / (2*n)            // scale amplitude
}.play;
)


(
{
    var n;
    n = 8; // number of 'voices'
    Mix.ar( // mix all stereo pairs down.
        Pan2.ar( // pan the voice to a stereo position
            CombL.ar( // a comb filter used as a string resonator
                Dust.ar( // random impulses as an excitation function
                    // an array to cause expansion of Dust to n channels
                    // 1 means one impulse per second on average
                    1.dup(n),
                    0.3 // amplitude
                ),
                0.01, // max delay time in seconds
                // array of different random lengths for each 'string'
                {0.004.rand+0.0003}.dup(n),
                4 // decay time in seconds
            ),
            {1.0.rand2}.dup(n) // give each voice a different pan position
        )
    )
}.play;
)






(
play {
    var sig, chain;

	sig = sum({
		SinOsc.ar(
			freq: rrand(50, 6000),
			phase: 0,
		) * (2 * Decay.ar(
			in: Dust2.ar(1),
			decayTime: 0.1)
		).tanh();
	}.dup(7));

    chain = sig;    // Start with the original signal
    8.do {|i|
        chain = LeakDC.ar(
			in: AllpassL.ar(
				in: LPF.ar(
					in: chain * 0.9,
					freq: 3000
				),
				maxdelaytime: 0.2,
				delaytime: { 0.19.rand + 0.01 }.dup(2),
				decaytime: 3
			)
		);
    };

    Limiter.ar(sig + chain);    // dry + wet
};
);