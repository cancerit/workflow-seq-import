#!/usr/bin/env cwl-runner

class: Workflow

id: "chksum-seqval-workflow"

label: "A CGP workflow to generate checksum of an interleaved fastq"

cwlVersion: v1.0

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement

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
    outputSource: in_chksum/chksum_json

  chksum_put_server_response:
    type: ["null", File]
    outputSource: in_chksum/server_response

  interleaved_fastq_out:
    type: File
    outputSource: if_input_is_bz2_convert_to_gz_else_just_rename/outfile
  
  results_manifest:
    type: File
    outputSource: manifest_string_to_file/outfile

steps:
  if_input_is_bz2_convert_to_gz_else_just_rename:
    in:
      srcfile:
        source: fastq_in
      newname:
        source: fastq_in
        valueFrom: $(self.basename.replace(/\.f(?:ast)?q(?:\.gz|\.bz2)?$/i, "")).fq.gz
    out: [outfile]
    run: toolkit/if_input_is_bz2_convert_to_gz_else_just_rename.cwl

  in_chksum:
    in:
      in_file:
        source: fastq_in
      put_address:
        source: put_address
      put_headers:
        source: put_headers
      ignore_all_curl_exits:
        valueFrom: $(true)
    out: [chksum_json, server_response]
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-chksum/0.4.1/Dockstore.cwl

  if_input_is_bz2_generate_md5sum_else_return_input_chksum_json:
    in:
      in_1:
        source: fastq_in
        valueFrom: $(self.basename)
      in_2:
        source: if_input_is_bz2_convert_to_gz_else_just_rename/outfile
      in_json:
        source: in_chksum/chksum_json
    out: [chksum_json]
    run: toolkit/if_input_is_bz2_generate_md5sum_else_return_input_chksum_json.cwl

  results_manifest_string:
    in:
      input_files:
        source: [fastq_in]
        linkMerge: merge_flattened
      input_chksum_results:
        source: [in_chksum/chksum_json]
        linkMerge: merge_flattened
      output_files:
        source: [if_input_is_bz2_convert_to_gz_else_just_rename/outfile]
        linkMerge: merge_flattened
      output_chksum_results:
        source: [if_input_is_bz2_generate_md5sum_else_return_input_chksum_json/chksum_json]
        linkMerge: merge_flattened
    out: [out_string]
    run: toolkit/results_manifest.cwl
  
  manifest_string_to_file:
    in:
      in_string:
        source: [results_manifest_string/out_string]
    out: [outfile]
    run: toolkit/string_to_file.cwl

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
  foaf:mbox: "genservhelp@sanger.ac.uk"
