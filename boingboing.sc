(
Ndef(\verb, {
	var input, output, delrd, sig, deltimes;

	delrd = LocalIn.ar(4);
	output = input + delrd[[0,1]];
	sig = output ++ delrd[[2,3]];
	sig = ([ [1, 1, 1, 1],
	 [1, -1, 1, -1],
	 [1, 1, -1, -1],
	 [1, -1, -1, 1]] * sig).sum;
	sig = sig * [0.4, 0.37, 0.333, 0.3];
	deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;
	LocalOut.ar(DelayC.ar(sig, deltimes, deltimes));
	output
}).play
)
