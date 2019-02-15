#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.srcfile)

inputs:
  srcfile:
    type: File
    inputBinding:
      position: 1
  newname:
    type: string
    inputBinding:
      position: 2
outputs:
  outfile:
    type: File
    outputBinding:
      glob: $(inputs.newname)

baseCommand: ["bash", "-c", "set -x; in=$0; out=$1; bz2_pattern=\"*.bz2\"; if [[ $in == $bz2_pattern ]]; then echo 'converting bz2 file to gzip file..'; bzip2 -cd $in | gzip -c > $out; elif [[ $(basename $in) != $out ]]; then echo 'only need to rename the file'; mv $in $out; fi"]