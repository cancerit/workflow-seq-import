cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

inputs:
  files:
    type:
      type: array
      items: File
    inputBinding:
      valueFrom: $(self.map(f => f.basename))
      itemSeparator: '\n'
outputs:
  outfile:
    type: File
    outputBinding:
      glob: rg_file_names.txt
baseCommand: ["echo", "-e"]
stdout: rg_file_names.txt