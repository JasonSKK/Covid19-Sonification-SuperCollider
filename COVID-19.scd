~csv = CSVFileReader.read(/*YOUR PATH TO -->> */ "2020-02-02-14-00.csv");

~xs = Array.fill(64,{|i| i + 1});
~xs[0] = 0;

/*//TESTERS
~xs.choose;
~csv[0][3]=0
~csv[~xs.choose][3];//WORKING
~csv[(0..63).choose][3]; // WORKING AS WELL
*/

(~csv[0][1] = 0;
~csv[0][2] = 0;
~csv[0][3] = 0;
);
(
~ff = {
    50.do{
        SynthDef("covid", {
            |amp = 0.5|
            var env, sig, sig1, sig2, out, freq, freq1, freq2, sum;
            sum = 0;
            freq = ~csv[(0..63).choose][3].asFloat;
            freq1 = ~csv[(0..63).choose][2].asFloat;
            freq2 = ~csv[(0..63).choose][1].asFloat;
            if ((freq<90) && (freq >2), {freq = freq * 100.rand;
                ["num",freq].postln;
            });
            if (freq == 0, {freq =  1000.rand;
                ["equal0",freq].postln;
            });
            if (freq > 3000, {freq =  freq * 0.5.rand;
                ["highFQ",freq].postln;
            });
            10.do{
                sig = SinOsc.ar(freq, LFNoise1.kr(10),
                    Saw.kr(Rand(1, 40), LFNoise1.kr(Rand(4, 10))));
                sig1 =  SinOsc.ar((freq)*(LPF.kr(SyncSaw.kr(4,mul:1),freq)),(SinOsc.ar(20,mul:9)),mul:0.1888);
                sig2 = LFTri.ar(freq* LFNoise1.kr(3).range(0.8, 1.2), Rand(0.0, 1.0) )* 0.666;
                sum = (sig1 + sig + sig2 +  sum) * 0.5;
            };
            out = sum * amp * 0.2;
            out = out +  BPF.ar(3*Dust.ar(0.266), 3000+ freq+ freq1 + freq2, 0.2,2);
            out = (FreeVerb.ar(out, 1.0, 1.0, 1.0)*2) + out ;
            env = Env.perc(4.1, 2.1).kr(doneAction:2);
            out = out * 0.5 * env;
            Out.ar(0,Pan2.ar(out, LFNoise1.kr(0.2).range(-1,1)))
        }).play;
        2.0.rand.wait;
}}
.fork;
);

//s.record
//s.stopRecording