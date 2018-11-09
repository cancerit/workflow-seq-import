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
      valueFrom: |
        ${
          var arr = self.map(function (f) {return '"' + f.basename + '"'});
          return '[' + arr.join(', ') + ']'
        }
outputs:
  outfile:
    type: File
    outputBinding:
      glob: rg_manifest.json
baseCommand: ["echo"]
stdout: rg_manifest.json