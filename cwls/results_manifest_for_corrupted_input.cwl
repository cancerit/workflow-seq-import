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
        var chksum_obj = JSON.parse(chksum_out_json_files[i].contents);
        var temp_obj = {name: files[i].basename, size: files[i].size, md5: chksum_obj.md5sum, sha2: chksum_obj.sha2sum, corruption_status: 'file name not found in corruption_status file'}
        if (files[i].basename in corrupt_obj) {
          temp_obj['corruption_status'] = corrupt_obj[files[i].basename]
        }
        metas.push(temp_obj);
      }
      return metas;
    }

    var final_meta;
    final_meta = { input: name_chksum_and_corruption_status(inputs.input_files, inputs.input_chksum_results, inputs.corruption_status) };
    return {out_string: JSON.stringify(final_meta)} 
  }
