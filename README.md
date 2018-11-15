# workflow-seq-import

Dockstore workflows to import sequencing files.

[![Build Status](https://travis-ci.org/cancerit/workflow-seq-import.svg?branch=master)](https://travis-ci.org/cancerit/workflow-seq-import) : master
[![Build Status](https://travis-ci.org/cancerit/workflow-seq-import.svg?branch=develop)](https://travis-ci.org/cancerit/workflow-seq-import) : develop

## Workflows

These workflows were built based on existing tools below:

* [dockstore-cgp-seqval](https://github.com/cancerit/dockstore-cgp-seqval)

  [![Build Status](https://travis-ci.org/cancerit/dockstore-cgp-seqval.svg?branch=master)](https://travis-ci.org/cancerit/dockstore-cgp-seqval) : master
  [![Build Status](https://travis-ci.org/cancerit/dockstore-cgp-seqval.svg?branch=develop)](https://travis-ci.org/cancerit/dockstore-cgp-seqval) : develop
* [dockstore-cgp-chksum](https://github.com/cancerit/dockstore-cgp-chksum)

  [![Build Status](https://travis-ci.org/cancerit/dockstore-cgp-chksum.svg?branch=master)](https://travis-ci.org/cancerit/dockstore-cgp-chksum) : master
  [![Build Status](https://travis-ci.org/cancerit/dockstore-cgp-chksum.svg?branch=develop)](https://travis-ci.org/cancerit/dockstore-cgp-chksum) : develop

### chksum_seqval_wf_interleaved_fq.cwl

#### Inputs

* `fastq_in` - A gzipped interleaved FastQ file.
* `put_address` - An URL to send checksum results to via PUT. Optional.
* `put_headers` - A list of headers to send with the checksum results to via PUT. Optional.

#### Outputs

* `chksum_json` - A file with MD5 and SHA256 checksums of `fastq_in` in JSON format.
* `chksum_server_response` - PUT server response in a text file. Optional, if no `put_address` is given.
* `interleave_report_json`- A json report evaluating the analysis of the `fastq_in`.
* `interleave_ifastq_out` - Interleaved gzipped FastQ output file.
* `results_manefest` - A JSON file in the schema below:

    ```json
    {
        "input": [
            {"name": "tiny_1.fq.gz", "size": 382, "md5": "...", "sha2": "..."}
        ],
        "output": [
            {"name": "interleaved.fq.gz", "size": 614, "md5": "...", "sha2": "..."}
        ]
    }
    ```

    **NOTE:** File names can be wrong if run by Dockstore.

### chksum_seqval_wf_paired_fq.cwl

#### Inputs

* `fastq_in` - A **list** of two paired gzipped FastQ files.
* `put_address` - A **list** of two URLs to send checksum results of corresponding FasetQ to via PUT. It's required and **NOT** optional, but two empty strings can be used if no PUT is required.
* `put_headers` - A list of headers to send with the checksum results to via PUT. Optional.

#### Outputs

* `chksum_json` - A list of two files with MD5 and SHA256 checksums of `fastq_in` in JSON format.
* `chksum_server_response` - A list of two text files. Each has PUT server response of one of the `fastq_in`. Optional if empty `putt_address` was used.
* `interleave_report_json`- A json report evaluating the analysis of the `fastq_in`.
* `interleave_ifastq_out` - Interleaved gzipped FastQ output file.
* `results_manefest` - A JSON file in the schema below:

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

    **NOTE:** File names can be wrong if run by Dockstore.

## Examples

Examples included in this repository.

1. `examples/chksum_seqval_wf_interleaved_fq.json`
  * A single interleaved gzipped fastq is presented and a PUT server URL as input.

1. `examples/chksum_seqval_wf_interleaved_fq_with_headers.json`
  * A list of headers is in the input.
  * PUT the results with headers.

1. `examples/chksum_seqval_wf_interleaved_fq_no_put.json`
  * Only a single interleaved gzipped fastq is presented.
  * `put_address` is not presented nor the `chksum_server_response`.

1. `examples/chksum_seqval_wf_paired_fq.json`
  * A pair if read 1/2 gzipped fastq files are presented as input.
  * Two PUT server URLs are presented as input.

1. `examples/chksum_seqval_wf_paired_fq_with_headers.json`
  * A list of headers is in the input.
  * All headers will be used in every PUT request.

1. `examples/chksum_seqval_wf_paired_fq_no_put.json`
  * A pair if read 1/2 gzipped fastq files are presented as input.
  * Two empty strings are presented as input PUT server URLs.
  * `chksum_server_response` is not presented.

## Development environment

This project uses git pre-commit hooks.  As these will execute on your system you need to activate them.  Failure to adhere to these may result in rejection of your work.

You will need to install:

```
gem install --user-install mdl
```

The following command will activate the checks to execute before a commit is processed:

```
git config core.hooksPath git-hooks
```

A failure will block a commit, this includes style for terraform.

You can run the same checks manually without a commit by executing the following in the base of the clone:

```bash
./run_checks.sh
```

----

LICENCE

Copyright (c) 2018 Genome Research Ltd.

Author: Cancer Genome Project <cgpit@sanger.ac.uk>

This file is part of workflow-seq-import.

workflow-seq-import is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

1. The usage of a range of years within a copyright statement contained within this distribution should be interpreted as being equivalent to a list of years including the first and last year specified and all consecutive years between them. For example, a copyright statement that reads ‘Copyright (c) 2005, 2007-2009, 2011-2012’ should be interpreted as being identical to a statement that reads ‘Copyright (c) 2005, 2007, 2008, 2009, 2011, 2012’ and a copyright statement that reads ‘Copyright (c) 2005-2012’ should be interpreted as being identical to a statement that reads ‘Copyright (c) 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012’."
