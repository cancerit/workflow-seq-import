#!/usr/bin/env cwl-runner

class: Workflow

id: "chksum-seqval-workflow"

label: "CGP checksum and interleave fastq generation workflow"

cwlVersion: v1.0

requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:
  fastq_in:
    type:
      type: array
      items: File
    format: edam:format_1930
    doc: "Fastq files to import, can be gzipped."

  post_address:
    type:
      type: array
      items: ["null", string]
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
      type: array
      items: ["null", File]
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
  rename:
    in:
      srcfile:
        source: fastq_in
      newname:
        source: fastq_in
        valueFrom: $(self.nameroot).fq.gz
    scatter: [srcfile, newname]
    scatterMethod: dotproduct
    out: [outfile]
    run: rename.cwl

  chksum:
    in:
      in_file:
        source: rename/outfile
      post_address:
        source: post_address
    out: [chksum_json, post_server_response]
    scatter: [in_file, post_address]
    scatterMethod: dotproduct
    run: cgp-chksum.cwl

  interleave:
    in:
      fastqs_in:
        source: rename/outfile
    out: [report_json, ifastq_out]
    run: cgp-seqval-qc_pairs_1.cwl

doc: |
  A workflow to generate checksums of FastQ files and a interleaved FastQ from them. See the [workflow-seq-import](https://github.com/cancerit/workflow-seq-import) website for more information.

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html
  - http://edamontology.org/EDAM_1.18.owl

$namespaces:
  s: http://schema.org/
  edam: http://edamontology.org/

s:codeRepository: https://github.com/cancerit/workflow-seq-import
s:license: https://spdx.org/licenses/AGPL-3.0

s:author:
  - class: s:Person
    s:email: mailto:yyaobo@gmail.com
    s:name: Yaobo Xu

dct:creator:
  foaf:name: Yaobo Xu
  foaf:mbox: "yyaobo@gmail.com"
