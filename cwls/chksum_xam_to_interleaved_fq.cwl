#!/usr/bin/env cwl-runner

class: Workflow

id: "chksum-xam-to-interleaved-fq-workflow"

label: "A CGP workflow to generate checksum and interleaved fastq from a [Cr|B]am file"

cwlVersion: v1.0

requirements:
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  xam_in:
    type: File
    doc: "The [B|Cr]am file to import."

  put_address:
    type: string?
    doc: "Optional PUT address to send JSON results of checksums"

  put_headers:
    type: string[]?
    doc: "Optional headers to send with JSON results"

  cram_ref_url:
    type: string
    doc: "URL path to use as cram reference e.g. 'https://www.ebi.ac.uk/ena/cram/md5/%s'"
    default: "https://www.ebi.ac.uk/ena/cram/md5/%s"

outputs:
  chksum_json:
    type: File
    outputSource: chksum/chksum_json

  chksum_put_server_response:
    type: ["null", File]
    outputSource: chksum/server_response

  interleaved_fastq_out:
    type:
        type: array
        items: File
    doc: "Array of gzipped interleaved fastq files, one per read group in xam_in"
    outputSource: xam_to_interleaved_fq/ifastqs_out
  
  results_manifest:
    type: File
    outputSource: manifest_string_to_file/outfile

steps:
  rename:
    in:
      srcfile:
        source: xam_in
      newname:
        source: xam_in
        valueFrom: $(self.basename)
    out: [outfile]
    run: rename.cwl

  chksum:
    in:
      in_file:
        source: rename/outfile
      put_address:
        source: put_address
      put_headers:
        source: put_headers
      ignore_all_curl_exits:
        valueFrom: $(true)
    out: [chksum_json, server_response]
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-chksum/0.4.0/Dockstore.cwl

  xam_to_interleaved_fq:
    in:
      xam_in:
        source: xam_in
      ref_path:
        source: cram_ref_path
    out: [ifastqs_out, rg_info_json]
    run: https://raw.githubusercontent.com/cancerit/dockstore-samtools-biobambam2/0.0.1/cwls/xam_to_interleaved_by_rg.cwl

  out_chksum:
    in: 
      in_file: 
        source: xam_to_interleaved_fq/ifastqs_out
    scatter: [in_file]
    scatterMethod: dotproduct
    out: [chksum_json] #An array of chksums directly relating to the input array of interleaved fastq files
    run: https://raw.githubusercontent.com/cancerit/dockstore-cgp-chksum/0.4.0/Dockstore.cwl

  results_manifest_string:
    in:
      input_files:
        source: [xam_in]
        linkMerge: merge_flattened
      input_chksum_results:
        source: [chksum/chksum_json]
        linkMerge: merge_flattened
      output_files:
        source: xam_to_interleaved_fq/ifastqs_out
      output_chksum_results:
        source: out_chksum/chksum_json
      output_rg_info_file:
        source: xam_to_interleaved_fq/rg_info_json
    out: [out_string]
    run: results_manifest.cwl
  
  manifest_string_to_file:
    in:
      in_string:
        source: [results_manifest_string/out_string]
    out: [outfile]
    run: string_to_file.cwl

doc: |
  A workflow to generate checksums of [B|Cr]am files and interleaved FastQs derived from them. See the [workflow-seq-import](https://github.com/cancerit/workflow-seq-import) website for more information.

$schemas:
  - http://schema.org/docs/schema_org_rdfa.html

$namespaces:
  s: http://schema.org/

s:codeRepository: https://github.com/cancerit/workflow-seq-import
s:license: https://spdx.org/licenses/AGPL-3.0

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-0407-0386
    s:email: mailto:drj@sanger.ac.uk
    s:name: David Jones

dct:creator:
  foaf:name: David Jones
  foaf:mbox: "genservhelp@sanger.ac.uk"
