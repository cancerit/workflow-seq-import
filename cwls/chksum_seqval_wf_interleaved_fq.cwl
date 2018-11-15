#!/usr/bin/env cwl-runner

class: Workflow

id: "chksum-seqval-workflow"

label: "CGP checksum and interleave fastq generation workflow"

cwlVersion: v1.0

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  fastq_in:
    type: File
    doc: "The gzipped interleaved fastq file to import."

  put_address:
    type: string?
    doc: "Optional PUT address to send JSON results of checksums"

  put_headers:
    type: string[]?
    doc: "Optional headers to send with JSON results"

outputs:
  chksum_json:
    type: File
    format: edam:format_3464
    outputSource: chksum/chksum_json

  chksum_put_server_response:
    type: ["null", File]
    outputSource: chksum/server_response

  interleave_fastq_out:
    type: File
    format: edam:format_1930
    outputSource: rename/outfile
  
  results_manifest:
    type: File
    outputSource: manifest_string_to_file/outfile

steps:
  rename:
    in:
      srcfile:
        source: fastq_in
      newname:
        source: fastq_in
        valueFrom: $(self.basename.replace(/\.f(?:ast)?q(?:\.gz)?$/i, "")).fq.gz
    out: [outfile]
    run: rename.cwl

  chksum:
    in:
      in_file:
        source: rename/outfile
      put_address:
        source: put_address
      put_headers:
        source: put_headers
      ignore_all_curl_exits:
        valueFrom: $(true)
    out: [chksum_json, server_response]
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-chksum/0.4.0/Dockstore.cwl

  results_manifest_string:
    in:
      input_files:
        source: [fastq_in]
        linkMerge: merge_flattened
      input_chksum_results:
        source: [chksum/chksum_json]
        linkMerge: merge_flattened
      output_files:
        source: [rename/outfile]
        linkMerge: merge_flattened
      output_chksum_results:
        source: [chksum/chksum_json]
        linkMerge: merge_flattened
    out: [out_string]
    run: results_manifest.cwl
  
  manifest_string_to_file:
    in:
      in_string:
        source: [results_manifest_string/out_string]
    out: [outfile]
    run: string_to_file.cwl

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
