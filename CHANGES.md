# CHANGES

## next

* added workflows to generate chksums for files with corruption information added to the final manifest output.

## 0.4.1

* bumped into [Dockstore bug](https://github.com/ga4gh/dockstore/issues/2154), so moved all cwl files into one directory.

## 0.4.0

* started to use remote dockstore-cgp-seqval 1.0.0 for its Casava 1.8 support.

## 0.3.2

* `chksum_seqval_wf_paired_fq`, `chksum_xam_to_interleaved_fq` and `validate_interleaved_fq` workflows can now process bz2 compressed FastQ files.

## 0.3.1

* updated version of dockstore-samtools-biobambam2 to avoid CWL hated characters in file names in the middle of the workflow.

## 0.3.0

* added workflow `chksum_xam_to_interleaved_fq`, which can split reads in a [B|Cr]am file into gzipped fastq files by read groups and preserved some RG tags in a json file.
* removed all EDAM related lines from cwl files as the website sometime has very slow reponse;
* removed `rename` step in `chksum_seqval_wf_paired_fq` and `chksum_xam_to_interleaved_fq` workflows.
* started to use dockstore-cgp-seqval:0.1.2, so that `cgpSeqInputVal validator` will have consistent reponses on FastQ file name extensions with `cgpSeqInputVal man-valid`.

## 0.2.3

* renamed workflow `move_and_validate_interleaved_fq.cwl` to `validate_interleaved_fq.cwl`, removed its `interleaved_fastq_out` output, updated its example json.

## 0.2.2

* updated cwl file version for `chksum` step in workflows to `0.4.0`, some input and output parameter names were changed to reflect the HTTP method was changed to `PUT` from `POST` in the new version;
* suppressed all curl exit codes when putting results.
* output `rg_file_manifest` name is changed to `results_manifest`, schema is changed to:

    ```json
    {
        "input": [
            {"name": "tiny_1.fq.gz", "size": 382, "md5": "...", "sha2": "..."},
            {"name": "tiny_2.fq.gz", "size": 391, "md5": "...", "sha2": "..."}
        ],
        "output": [
            {"name": "interleaved.fq.gz", "size": 614, "md5": "...", "sha2": "..."}
        ]
    }
    ```

* renames some workflow input and output parameter names;
* removed interleaved_report_json output from interleave and paired fastq workflows;
* added a workflow to make a copy of an interleaved fastq and validate its format and base quality score range.

## 0.2.1

* java script in `echo_filenames_to_file.cwl` uses ES5 syntax, and it now produces a file in JSON format, the output file name is also renamed to `rg_manifest.json`.
* removed format specifications for workflows input

## 0.2.0

* fixed output file name extensions, so that input fastq file extensions will be correctly replaced with ".fq.gz" in the output;
* added an output file which has the interleaved output file names.

## 0.1.0

Initial base release.
