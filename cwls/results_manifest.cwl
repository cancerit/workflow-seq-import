cwlVersion: v1.0
class: ExpressionTool

requirements:
  InlineJavascriptRequirement: {}

inputs:
  input_files:
    type:
      type: array
      items: File
  input_chksum_results:
    type:
      type: array
      items: File
      inputBinding:
        loadContents: true
  output_files:
    type:
      type: array
      items: File
  output_chksum_results:
    type:
      type: array
      items: File
      inputBinding:
        loadContents: true

outputs:
  out_string:
    type: string

expression: |
  ${
    function name_and_chksum(files, chksum_out_json_files) {
      var metas = [];
      for (var i=0; i<files.length; i++) {
        var temp_obj = JSON.parse(chksum_out_json_files[i].contents);
        metas.push({name: files[i].basename, size: files[i].size, md5: temp_obj.md5sum, sha2: temp_obj.sha2sum});
      }
      return metas;
    }
    var final_meta = { input: name_and_chksum(inputs.input_files, inputs.input_chksum_results), output: name_and_chksum(inputs.output_files, inputs.output_chksum_results) };
    return {out_string: JSON.stringify(final_meta)} 
  }