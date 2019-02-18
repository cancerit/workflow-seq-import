#!/usr/bin/env cwl-runner

class: Workflow

id: "move-and-validate-a-interleaved-fastq"

label: "A CGP workflow to move and validate an interleaved fastq"

cwlVersion: v1.0

requirements:
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  fastq_in:
    type: File
    doc: "A gzipped interleaved fastq file."

outputs:
  report:
    type: File
    outputSource: validate/report_json

steps:
  validate:
    in:
      fastqs_in:
        source: [fastq_in]
        linkMerge: merge_flattened
    out: [report_json]
    run: toolkit/cgp-seqval-qc_pairs.cwl

doc: |
  A workflow to copy the input interleaved fastq file to a new place and validate the file format and base quality score range. See the [workflow-seq-import](https://github.com/cancerit/workflow-seq-import) website for more information.

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html

$namespaces:
  s: http://schema.org/

s:codeRepository: https://github.com/cancerit/workflow-seq-import
s:license: https://spdx.org/licenses/AGPL-3.0

s:author:
  - class: s:Person
    s:email: mailto:yyaobo@gmail.com
    s:name: Yaobo Xu

dct:creator:
  foaf:name: Yaobo Xu
  foaf:mbox: "genservhelp@sanger.ac.uk"
