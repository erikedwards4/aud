#@author Erik Edwards
#@date 2017-present
#@license BSD 3-clause

#aud is my own library of C functions for general audio processing.

#This is the Makefile used during development of the C functions.
#Since these are not stand-alone programs (no main functions), the only outputs are object files to obj dir.
#It is not necessary to run this when making the C++ command-line tools.

SHELL=/bin/bash
CC=clang

ifeq ($(CC),$(filter $(CC),clang gcc))
	STD=-std=c11
else
	STD=-std=gnu++14
endif

ifeq ($(CC),clang++)
	STD=-std=c++11
	WFLAG=-Weverything -Wno-c++98-compat -Wno-padded -Wno-gnu-imaginary-constant -Wno-deprecated -Wno-old-style-cast
else
	WFLAG=-Wall -Wextra
endif

CFLAGS=$(WFLAG) $(STD) -O3 -march=native -fPIC


All: all
all: Dirs Pre Freqs Spectrogram CCs Deltas LSF_LAR Clean

Dirs:
	mkdir -pm 777 obj


#Pre: common preprocessing steps
Pre: rms_scale preemph dither
rms_scale: rms_scale.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
preemph: preemph.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
dither: dither.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)


#Freqs: utils for various frequency scales (linear, Mel, etc.)
Freqs: convert_freqs get_cfs get_stft_freqs get_cfs_T #get_cns
convert_freqs: convert_freqs.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
get_cfs: get_cfs.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
get_stft_freqs: get_stft_freqs.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
get_cfs_T: get_cfs_T.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)


#Spectrogram: steps to make spectrograms with various frequency scales
Spectrogram: get_cns get_spectrogram_T_mat apply_spectrogram_T_mat pow_compress spectrogram
get_cns: get_cns.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
abs2: abs2.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
get_spectrogram_T_mat: get_spectrogram_T_mat.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
apply_spectrogram_T_mat: apply_spectrogram_T_mat.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
pow_compress: pow_compress.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
spectrogram: spectrogram.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)


#CCs: steps for CCs (cepstral coefficients) and final MFCC (mel-frequency cepstral coeff) features
CCs: lifter get_ccs mfccs
lifter: lifter.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
get_ccs: get_ccs.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
mfccs: mfccs.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)


#Deltas: get or add deltas or delta-deltas
Deltas: get_deltas add_deltas get_delta_deltas add_delta_deltas
get_deltas: get_deltas.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
add_deltas: add_deltas.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
get_delta_deltas: get_delta_deltas.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
add_delta_deltas: add_delta_deltas.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)


#LSF_LAR: conversions involving LSFs (line spectral frequencies) and LARs (log-area ratios).
LSF_LAR: ar2lsf lsf2ar poly2lsf lsf2poly rc2lar lar2rc
ar2lsf: srci/ar2lsf.cpp c/ar2lsf.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -llapacke -lm
lsf2ar: srci/lsf2ar.cpp c/lsf2ar.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lm
poly2lsf: srci/poly2lsf.cpp c/poly2lsf.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -llapacke -lm
lsf2poly: srci/lsf2poly.cpp c/lsf2poly.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lm
rc2lar: srci/rc2lar.cpp c/rc2lar.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lm
lar2rc: srci/lar2rc.cpp c/lar2rc.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lm



#If want to make a library archive for C++ use, this works with clang++
#ar crs ../lib/libaud.a obj/*.o


#make clean
Clean: clean
clean:
	find ./obj -type f -name *.o | xargs rm -f
	rm -f *.s tmp.*
