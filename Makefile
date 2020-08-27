#@author Erik Edwards
#@date 2018-present
#@license BSD 3-clause

#aud is my own library of functions for audio processing in C and C++.
#This is the makefile for the C++ command-line tools.

#This is meant primarily to support work in speech,
#so not every possible audio function is included.
#However, all of these are usable for general-purpose audio, including music, etc.
#Higher-level functions meant only for speech are in a separate repo (speech).

SHELL=/bin/bash
ss=../util/bin/srci2src
CC=clang++

ifeq ($(CC),clang++)
	STD=-std=c++11
	WFLAG=-Weverything -Wno-c++98-compat -Wno-old-style-cast -Wno-gnu-imaginary-constant
else
	STD=-std=gnu++14
	WFLAG=-Wall -Wextra
endif

INCLS=-Ic -I../util
CFLAGS=$(WFLAG) $(STD) -O2 -ffast-math -march=native $(INCLS)


All: all
all: Dirs Pre Freqs Spectrogram CCs Deltas LSF_LAR Clean
	rm -f 7 obj/*.o

Dirs:
	mkdir -pm 777 bin obj


Pre: preemph rms_scale dither
preemph: srci/preemph.cpp c/preemph.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2
rms_scale: srci/rms_scale.cpp c/rms_scale.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lm
dither: srci/dither.cpp c/dither.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lm


Freqs: convert_freqs get_cfs get_stft_freqs get_cfs_T #get_cns
convert_freqs: srci/convert_freqs.cpp c/convert_freqs.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lm
get_cfs: srci/get_cfs.cpp c/get_cfs.c c/convert_freqs.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lm
get_stft_freqs: srci/get_stft_freqs.cpp c/get_stft_freqs.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2
get_cfs_T: srci/get_cfs_T.cpp c/get_cfs_T.c c/convert_freqs.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lm


Spectrogram: get_cns get_spectrogram_T_mat apply_spectrogram_T_mat pow_compress spectrogram
get_cns: srci/get_cns.cpp c/get_cns.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lm
get_spectrogram_T_mat: srci/get_spectrogram_T_mat.cpp c/get_spectrogram_T_mat.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas
apply_spectrogram_T_mat: srci/apply_spectrogram_T_mat.cpp c/apply_spectrogram_T_mat.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas
pow_compress: srci/pow_compress.cpp c/pow_compress.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lm
spectrogram: srci/spectrogram.cpp c/spectrogram.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lfftw3f -lfftw3 -lm


CCs: dct dct_inplace lifter get_ccs mfccs
dct: srci/dct.cpp c/dct.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lfftw3f -lfftw3 -lm
dct_inplace: srci/dct_inplace.cpp c/dct_inplace.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lfftw3f -lfftw3 -lm
lifter: srci/lifter.cpp c/lifter.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lm
get_ccs: srci/get_ccs.cpp c/get_ccs.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lfftw3f -lfftw3 -lm
mfccs: srci/mfccs.cpp c/mfccs.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas -lfftw3f -lfftw3 -lm


Deltas: get_deltas get_delta_deltas add_deltas add_delta_deltas
get_deltas: srci/get_deltas.cpp c/get_deltas.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas
get_delta_deltas: srci/get_delta_deltas.cpp c/get_delta_deltas.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas
add_deltas: srci/add_deltas.cpp c/add_deltas.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas
add_delta_deltas: srci/add_delta_deltas.cpp c/add_delta_deltas.c
	$(ss) -vd srci/$@.cpp > src/$@.cpp; $(CC) -c src/$@.cpp -oobj/$@.o $(CFLAGS); $(CC) obj/$@.o -obin/$@ -largtable2 -lopenblas


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


#Functionals: moments #cumulants prctiles lcrs
#moments: moments.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
#cumulants: cumulants.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
#prctiles: prctiles.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)
#lcrs: lcrs.c; $(CC) -c $@.c -o obj/$@.o $(CFLAGS)


#make clean
Clean: clean
clean:
	find ./obj -type f -name *.o | xargs rm -f
	rm -f 7 X* Y* x* y*
