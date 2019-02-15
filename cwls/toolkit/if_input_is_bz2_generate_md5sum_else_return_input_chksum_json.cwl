#!/usr/bin/env cwl-runner

class: Workflow

id: "if_input_is_bz2_generate_md5sum_else_returns_input_chksum_json"

label: "If Input file 1 has bz2 extension generate md5sum from input file 2 else returns input chksum json"

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

inputs:
  in_1:
    type: string
  in_2:
    type: File
  in_json:
    type: File

outputs:
  chksum_json:
    type: File
    outputSource: chksum/chksum_json

steps:
  if_file_name_is_bz2_then_return_null_else_return_in_json_to_output:
    in:
      file_name:
        source: in_1
      in_json:
        source: in_json
    out: [out_json]
    run: if_file_name_is_bz2_then_return_null_else_return_in_json_to_output.cwl

  chksum:
    in:
      in_file:
        source: in_2
      in_json:
        source: if_file_name_is_bz2_then_return_null_else_return_in_json_to_output/out_json
    out: [chksum_json]
    run: chksum.cwl
