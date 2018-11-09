# CHANGES

## 0.2.1

* java script in `echo_filenames_to_file.cwl` uses ES5 syntax, and it now produces a file in JSON format, the output file name is also renamed to `rg_manifest.json`.
* removed format specifications for workflows input


## 0.2.0

* fixed output file name extensions, so that input fastq file extensions will be correctly replaced with ".fq.gz" in the output;
* added an output file which has the interleaved output file names.

## 0.1.0

Initial base release.