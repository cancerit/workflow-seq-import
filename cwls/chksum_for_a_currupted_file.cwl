#!/usr/bin/env cwl-runner

class: Workflow

id: "chksum-corrupted-single-file-workflow"

label: "A CGP workflow to generate checksum and corruption info of a single file"

cwlVersion: v1.0

requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:
  file_in:
    type: File
    doc: "input file"

  put_address:
    type: string?
    doc: "Optional PUT address to send JSON results of checksums"

  put_headers:
    type: string[]?
    doc: "Optional headers to send with JSON results."

  corruption_status:
    type: File
    doc: "A JSON file of file corruption status"

outputs:
  chksum_json:
    type: File
    outputSource: in_chksum/chksum_json

  chksum_put_server_response:
    type: ["null", File]
    outputSource: in_chksum/server_response
  
  results_manifest:
    type: File
    outputSource: manifest_string_to_file/outfile

steps:

  in_chksum:
    in:
      in_file:
        source: file_in
      put_address:
        source: put_address
      put_headers:
        source: put_headers
      ignore_all_curl_exits:
        valueFrom: $(true)
    out: [chksum_json, server_response]
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-chksum/0.4.1/Dockstore.cwl

  results_manifest_string:
    in:
      input_files:
        source: [file_in]
        linkMerge: merge_flattened
      input_chksum_results:
        source: [in_chksum/chksum_json]
        linkMerge: merge_flattened
      corruption_status:
        source: corruption_status
    out: [out_string]
    run: results_manifest_for_corrupted_input.cwl

  manifest_string_to_file:
    in:
      in_string:
        source: [results_manifest_string/out_string]
    out: [outfile]
    run: string_to_file.cwl

doc: |
  A workflow to generate checksums of a file and add info in corruption_status file into a JSON output. See the [workflow-seq-import](https://github.com/cancerit/workflow-seq-import) website for more information.

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
