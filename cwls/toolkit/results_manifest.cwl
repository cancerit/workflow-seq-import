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
  output_rg_info_file:
    type: File?
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

    function name_and_checksum_and_rg(files, chksum_out_json_files, rg_info_file){
      var metas = [];
      var rg_obj = JSON.parse(rg_info_file.contents);
      var rg_dict = {};
      for(var j=0; j<rg_obj.length; j++){ 
        rg_dict[rg_obj[j]["ID"]] = rg_obj[j];   
      }
      for (var i=0; i<files.length; i++) {
        //Use file basename e.g. rg_split_10659_i.fq.gz to get RG ID
        var rg_id = (files[i].basename).slice(9,-8);
        var temp_obj = JSON.parse(chksum_out_json_files[i].contents);
        metas.push({name: files[i].basename, size: files[i].size, md5: temp_obj.md5sum, sha2: temp_obj.sha2sum, rg_info: rg_dict[rg_id]});
      }
      return metas;
    }

    var final_meta;
    if (inputs.output_rg_info_file) {
        final_meta = { input: name_and_chksum(inputs.input_files, inputs.input_chksum_results), output: name_and_checksum_and_rg(inputs.output_files, inputs.output_chksum_results, inputs.output_rg_info_file) };
    } else {
        final_meta = { input: name_and_chksum(inputs.input_files, inputs.input_chksum_results), output: name_and_chksum(inputs.output_files, inputs.output_chksum_results) };
    }
    return {out_string: JSON.stringify(final_meta)} 
  }