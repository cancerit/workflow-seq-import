#!/usr/bin/env cwl-runner

class: Workflow

id: "chksum-seqval-workflow"

label: "CGP checksum and interleave fastq generation workflow"

cwlVersion: v1.0

requirements:
  - class: ScatterFeatureRequirement

inputs:
  fastqs_in:
    type:
      type: array
      items: File
    format: edam:format_1930
    doc: "Fastq files to import, can be gzipped."

  post_address:
    type: ["null", string]
    doc: "Optional POST address to send JSON results of checksums"

outputs:
  chksum_json:
    type:
      type: array
      items: File
    format: edam:format_3464
    outputSource: chksum/chksum_json

  chksum_post_server_response:
    type:
      - "null"
      - type: array
        items: File
    outputSource: chksum/post_server_response

  interleave_report_json:
    type: File
    format: edam:format_3464
    outputSource: interleave/report_json

  interleave_ifastq_out:
    type: ["null", File]
    format: edam:format_1930
    outputSource: interleave/ifastq_out

steps:
  chksum:
    in:
      in_file:
        source: fastqs_in
    out: [chksum_json, post_server_response]
    scatter: [in_file]
    run: cgp-chksum.cwl

  interleave:
    in:
      fastqs_in:
        source: fastqs_in
    out: [report_json, ifastq_out]
    run: cgp-seqval-qc_pairs_1.cwl

doc: |
    A workflow to generate checksums of FastQ files and a interleaved FastQ from them. See the [workflow-seq-import](https://github.com/cancerit/workflow-seq-import) website for more information.

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
  foaf:mbox: "yyaobo@gmail.com"
