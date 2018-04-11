#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "cgp-chksum"

label: "CGP file checksum generator"

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/dockstore-cgp-chksum:0.1.1"

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
      glob: check_sums.json

  post_server_response:
    type: ["null", File]
    outputBinding:
      glob: post_server_response.txt

baseCommand: ["/opt/wtsi-cgp/bin/sums2json.sh"]

doc: |
    ![build_status](https://quay.io/repository/wtsicgp/dockstore-cgp-chksum/status)
    A Docker container for producing file md5sum and sha512sum. See the [dockstore-cgp-chksum](https://github.com/cancerit/dockstore-cgp-chksum) website for more information.

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html

$namespaces:
    s: http://schema.org/

s:codeRepository: https://github.com/cancerit/dockstore-cgp-chksum
s:license: https://spdx.org/licenses/AGPL-3.0

s:author:
  - class: s:Person
    s:email: mailto:yyaobo@gmail.com
    s:name: Yaobo Xu

dct:creator:
  "@id": "yyaobo@gmail.com"
  foaf:name: Yaobo Xu
  foaf:mbox: "yyaobo@gmail.com"
