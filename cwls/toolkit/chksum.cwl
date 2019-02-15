#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "cgp-chksum"

label: "CGP file checksum generator"

cwlVersion: v1.0

doc: |
    ![build_status](https://quay.io/repository/wtsicgp/dockstore-cgp-chksum/status)
    A Docker container for producing file md5sum and sha512sum. See the [dockstore-cgp-chksum](https://github.com/cancerit/dockstore-cgp-chksum) website for more information.

dct:creator:
  "@id": "yaobo.xu@sanger.ac.uk"
  foaf:name: Yaobo Xu
  foaf:mbox: "yx2@sanger.ac.uk"

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/dockstore-cgp-chksum:0.4.1"

inputs:
  in_file:
    type: File
    doc: "file to have checksum generated from"
    inputBinding:
      position: 1
      prefix: -i
      separate: true
      shellQuote: true

  in_json:
    type: ["null", File]
    doc: "use as chksum output instead of generating a new one."
    inputBinding:
      position: 2
      prefix: -j
      separate: true
      shellQuote: true

  put_address:
    type: ["null", string]
    doc: "Optional PUT address to send JSON results"
    inputBinding:
      position: 3
      prefix: -p
      separate: true
      shellQuote: true

  put_headers:
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: -H
          separate: true
          shellQuote: true
    doc: "Optional headers to send with JSON results"
    inputBinding:
      position: 4

  ignore_curl_exits:
    type:
      - "null"
      - type: array
        items: int
        inputBinding:
          prefix: -E
          separate: true
          shellQuote: true
    doc: "Optional curl exit codes to suppress"
    inputBinding:
      position: 5
  
  ignore_all_curl_exits:
    type: boolean?
    inputBinding:
      prefix: -A
      position: 6
    doc: "Flag to suppress all curl exit status" 

outputs:
  chksum_json:
    type: File
    outputBinding:
      glob: $(inputs.in_file.basename).check_sums.json

  server_response:
    type: ["null", File]
    outputBinding:
      glob: $(inputs.in_file.basename).server_response.txt

baseCommand: ["/opt/wtsi-cgp/bin/sums2json.sh"]