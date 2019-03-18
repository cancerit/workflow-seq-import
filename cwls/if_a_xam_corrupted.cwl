#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

inputs:
  xam_in:
    type: File
    doc: "The [B|Cr]am file to import."
    inputBinding:
      position: 1
      shellQuote: true
outputs:
  corruption_status:
    type: File
    outputBinding:
      glob: corruption_status.json
  corruption_flag_file:
    type: ["null", File]
    outputBinding:
      glob: corruption_flag.txt

baseCommand: ["bash", "-c", "set -ex; to_flag=0; bam_pattern=\"*.bam\"; cram_pattern=\"*.cram\"; bam_expected=\"SAMtools BAM \\(Binary Sequence Alignment/Map\\)*\\(gzip compressed data, extra field\\)\"; cram_expected=\"CRAM version*\"; echo '{' > corruption_status.json; for ((i=0;i<=$#;i++)); do file=\"${!i}\"; file_type=$(file -Lbz $file); expected_type=\"true\"; if [[ $file == $bam_pattern ]]; then expected=$bam_expected; elif [[ $file == $cram_pattern ]]; then expected=$cram_expected; else echo 'unexpected file extension'; rm corruption_status.json; exit 1; fi; if [[ $file_type != $expected ]]; then expected_type=\"false\"; to_flag=1; fi; echo -e \"\\\"$(basename $file)\\\":{\\\"expected_type\\\": $expected_type}\" >> corruption_status.json; echo ',' >> corruption_status.json; done; sed -i '$ d' corruption_status.json; echo '}' >> corruption_status.json; if [ $to_flag == 1 ]; then touch corruption_flag.txt; fi"]
