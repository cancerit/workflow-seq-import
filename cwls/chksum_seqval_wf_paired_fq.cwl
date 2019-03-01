#!/usr/bin/env cwl-runner

class: Workflow

id: "chksum-seqval-workflow"

label: "CGP checksum and interleaved fastq generation workflow for a paired fastq"

cwlVersion: v1.0

requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  fastq_in:
    type:
      type: array
      items: File
    doc: "Gzipped fastq files to import."

  put_address:
    type:
      type: array
      items: ["null", string]
    doc: "PUT address to send JSON results of checksums, use list of empty strings if no PUT is required."

  put_headers:
    type: string[]?
    doc: "Optional headers to send with JSON results."

outputs:
  chksum_json:
    type:
      type: array
      items: File
    outputSource: input_chksum/chksum_json

  chksum_put_server_response:
    type:
      type: array
      items: ["null", File]
    outputSource: input_chksum/server_response

  interleaved_fastq_out:
    type: ["null", File]
    outputSource: interleave/ifastq_out
  
  results_manifest:
    type: File
    outputSource: manifest_string_to_file/outfile

steps:

  input_chksum:
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
    scatter: [in_file, put_address]
    scatterMethod: dotproduct
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-chksum/0.4.1/Dockstore.cwl

  interleave:
    in:
      fastqs_in:
        source: fastq_in
      qc_pairs:
        valueFrom: $(1)
    out: [ifastq_out]
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-seqval/1.0.0/Dockstore.cwl

  output_chksum:
    in:
      in_file:
        source: interleave/ifastq_out
    out: [chksum_json]
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-chksum/0.4.1/Dockstore.cwl

  results_manifest_string:
    in:
      input_files:
        source: fastq_in
      input_chksum_results:
        source: input_chksum/chksum_json
      output_files:
        source: [interleave/ifastq_out]
        linkMerge: merge_flattened
      output_chksum_results:
        source: [output_chksum/chksum_json]
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
