#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "cgp-chksum"

label: "CGP file checksum generator"

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/dockstore-cgp-chksum:0.1.2"

inputs:
  in_file:
    type: File
    doc: "file to have checksum generated from"
    inputBinding:
      position: 1
      shellQuote: true

  post_address:
    type: ["null", string]
    doc: "Optional POST address to send JSON results"
    inputBinding:
      position: 2
      shellQuote: true

outputs:
  chksum_json:
    type: File
    outputBinding:
      glob: $(inputs.in_file.basename).check_sums.json

  post_server_response:
    type: ["null", File]
    outputBinding:
      glob: $(inputs.in_file.basename).post_server_response.txt

baseCommand: ["/opt/wtsi-cgp/bin/sums2json.sh"]
