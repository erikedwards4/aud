# aud

aud: functions for audio processing  

================================================

This is a set of C functions, and associated command-line tools in C++,  
that implement many typical audio and associated support functions.  
The purpose is to support speech and neural work.  
This does not, therefore, have every possible audio function.  
In particular, input/output, conversion and resampling are well performed  
by existing command-line tools such as sox, ffmpeg, etc. (also in C/C++).  

The command-line programs are written in C++ with a consistent style and interface.  
The low-level functions themselves are written in C for fastest performance (e.g., openBLAS).  

The C functions are meant for the developer; the C++ command-line tools are meant for the end-user.  
The interface to each C function is BLAS-like, meaning that one specifies the input and/or output dimensions,  
the matrix order as row-major or column-major, and so on.  

The C++ command-line programs are written in a consistent style that was developed for command-line tools in general.  
All of these command-line tools use argtable2 (http://argtable.sourceforge.net/) for parsing  
inputs and option flags. All of them allow -h (--help) as a flag to give description and usage info.  

Input/output is supported for NumPy tensors (https://numpy.org/)  
and several C++ tensor formats: Armadillo (http://arma.sourceforge.net/),  
ArrayFire (https://arrayfire.com/), and a minimal format for Eigen (http://eigen.tuxfamily.org/).  


## Dependencies
Requires argtable2, openBLAS, LAPACKE, FFTW.  
For Ubuntu, these are available by apt-get:  
```
sudo apt-get install libargtable2-0 libblas3 libopenblas-base liblapack3 liblapacke fftw3  
```

You must first install the util library:  
https://github.com/erikedwards4/util  
And install aud into the same parent directory as util.  
Preferably: /opt/codee/util and /opt/codee/aud  
For full examples and support functions, also install math and dsp:  
https://github.com/erikedwards4/math  
https://github.com/erikedwards4/dsp  



## Installation
```
cd /opt/codee  
git clone https://github.com/erikedwards4/aud  
cd /opt/codee/dsp  
make  
```

Each C function can also be compiled separately; see c subdirectory Makefile for details.  
To make an archive library:  
```
cd /opt/codee/dsp/c  
make libaud.a CC=clang  
```
This creates /opt/codee/aud/lib/libaud.a with all of the C object files.  
This could be useful if trying to use the C functions in other applications.  
Change clang to clang++ to compile for use with C++ applications.  


## Usage
See each resulting command-line tool for help (use -h or --help option).  
For example:  
```
/opt/codee/dsp/bin/fir --help  
```


## List of functions
All: Pre Freqs Spectrogram CCs Deltas LSF_LAR
Pre: rms_scale preemph dither  
Freqs: convert_freqs get_cfs get_stft_freqs get_cfs_T  
Spectrogram: get_cns get_spectrogram_T_mat apply_spectrogram_T_mat pow_compress spectrogram  
CCs: lifter get_ccs mfccs  
Deltas: get_deltas add_deltas get_delta_deltas add_delta_deltas  
LSF_LAR: ar2lsf lsf2ar poly2lsf lsf2poly rc2lar lar2rc  


## Contributing
This is currently only to view the project in progress.


## License
[BSD 3-Clause](https://choosealicense.com/licenses/bsd-3-clause/)

