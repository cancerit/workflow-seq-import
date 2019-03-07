#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

inputs:
  fastq_in:
    type:
      type: array
      items: File
    inputBinding:
      position: 1
outputs:
  corruption_status:
    type: File
    outputBinding:
      glob: corruption_status.json
  corruption_flag_file:
    type: ["null", File]
    outputBinding:
      glob: corruption_flag.txt

baseCommand: ["bash", "-c", "set -x; to_flag=0; expected=\"ASCII text*\"; gz_compressed=\"*\\(gzip compressed data,*\\)\"; bz2_compressed=\"*\\(bzip2 compressed data,*\\)\"; echo '{' > corruption_status.json; for ((i=0;i<=$#;i++)); do file=\"${!i}\"; file_type=$(file -Lbz $file); is_compressed=\"yes\"; is_ascii=\"yes\"; if [[ $file_type != $expected ]]; then is_ascii=\"no\"; to_flag=1; fi; if [[ $file_type != $gz_compressed && $file_type != $bz2_compressed ]]; then is_compressed=\"no\"; to_flag=1; fi; echo -e \"\\\"$(basename $file)\\\":{\\\"is_compressed\\\": \\\"$is_compressed\\\", \\\"is_ascii\\\": \\\"$is_ascii\\\"}\" >> corruption_status.json; echo ',' >> corruption_status.json; done; sed -i '$ d' corruption_status.json; echo '}' >> corruption_status.json; if [ $to_flag == 1 ]; then touch corruption_flag.txt; fi"]
