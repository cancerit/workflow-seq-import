#!/usr/bin/env cwl-runner

class: CommandLineTool

id: "cgp-seqval"

label: "CGP sequence validator"

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: "quay.io/wtsicgp/dockstore-cgp-seqval:0.1.1"

inputs:
  fastqs_in:
    type:
      type: array
      items: File
    doc: "Fastq files to verify, can be gzipped."
    inputBinding:
      prefix: -i
      position: 1
      separate: true
      shellQuote: true

  output_fq:
    type: string
    doc: "Not to be overridden by users: Output as interleaved FASTQ (ignored for interleaved input)"
    default: interleaved.fq.gz
    inputBinding:
      prefix: -o
      position: 2
      separate: true

outputs:
  report_json:
    type: File
    outputBinding:
      glob: report.json

  ifastq_out:
    type: ["null", File]
    outputBinding:
      glob: interleaved.fq.gz


baseCommand: ["cgpSeqInputVal", "seq-valid", "-r", "report.json", "-q", "1"]
