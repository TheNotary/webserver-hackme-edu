

function correctText_onClick() {
  var text = $('#uncorrected_text').val();

  requestTextCorrection(text);
}

function requestTextCorrection(text) {
  var url = "/text_corrections/correct";
  var data = { text: text };

  $.ajax({
    type: "POST",
    url: url,
    data: data,
    success: reportCorrection,
  });
}


function reportCorrection(jqxr){
  $('#corrected_text').val(jqxr.body);
  $('#diff_display').html(jqxr.diff);
}
