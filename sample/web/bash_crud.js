
function deleteAction(id) {
  $.ajax({
    url: '/cgi-bin/bash_crud/notes/' + id,
    type: 'DELETE',
    success: function(result) {
      location.reload();
    }
  });
}
