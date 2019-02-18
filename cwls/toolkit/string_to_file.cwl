cwlVersion: v1.0
class: CommandLineTool

inputs:
  in_string:
    type: string
    inputBinding:
      position: 1
outputs:
  outfile:
    type: File
    outputBinding:
      glob: results_manifest.json
baseCommand: ["echo"]
stdout: results_manifest.json
