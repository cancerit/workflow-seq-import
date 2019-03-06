cwlVersion: v1.0
class: ExpressionTool

requirements:
  - class: InlineJavascriptRequirement

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
  corruption_status:
    type: File
    inputBinding:
        loadContents: true

outputs:
  out_string:
    type: string

expression: |
  ${
    function name_chksum_and_corruption_status(files, chksum_out_json_files, c_file) {
      var metas = [];
      var corrupt_obj = JSON.parse(c_file.contents);
      for (var i=0; i<files.length; i++) {
        var temp_obj = JSON.parse(chksum_out_json_files[i].contents);
        metas.push({name: files[i].basename, size: files[i].size, md5: temp_obj.md5sum, sha2: temp_obj.sha2sum, corruption_status: corrupt_obj[files[i].basename]});
      }
      return metas;
    }

    var final_meta;
    final_meta = { input: name_chksum_and_corruption_status(inputs.input_files, inputs.input_chksum_results, inputs.corruption_status) };
    return {out_string: JSON.stringify(final_meta)} 
  }
