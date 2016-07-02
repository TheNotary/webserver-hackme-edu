
function deleteAction(id) {
  $.ajax({
    url: '/cgi-bin/bash_crud/notes/' + id,
    type: 'DELETE',
    success: function(result) {
      location.reload();
    }
  });
}

function putAction(id) {
  $.ajax({
    url: '/cgi-bin/bash_crud/notes/' + id,
    data: { title: $('#title').val(), body: $('#body').val(), subject: "submit" },
    type: 'PUT',
    success: function(result) {
      // location.reload();
      window.location.href = '../'+id;
    }
  });
}
