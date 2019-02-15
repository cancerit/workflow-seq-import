#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

inputs:
  file_name:
    type: string
    inputBinding:
      position: 1
  in_json:
    type: File
    inputBinding:
      position: 2
outputs:
  out_json:
    type: ["null", File]
    outputBinding:
      glob: $(inputs.in_json.basename)

baseCommand: ["bash", "-c", "set -x; in=$0; json=$1; bz2_pattern=\"*.bz2\"; if [[ $in == $bz2_pattern ]]; then echo 'file_name is bz2, I will have no output'; else echo 'file_name is not bz2, I will output the input json file'; cp $json $(basename $json); fi"]