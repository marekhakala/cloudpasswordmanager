//= require application_base

function elementHasProperty(property, object) {
	return (property in object && object[property] != null);
}

$(document).ready(function() {
  var default_value = parseInt($('.spinner input').default_value, 10);

  $('.spinner .btn:first-of-type').click(function() {
    if(parseInt($('.spinner input').val(), 10) > 1) {
      $('.spinner input').val(parseInt($('.spinner input').val(), 10) + 1);
    } else {
      $('.spinner input').val(default_value);
    }
  });

  $('.spinner .btn:last-of-type').click(function() {
    if(parseInt($('.spinner input').val(), 10) > 1) {
      $('.spinner input').val(parseInt($('.spinner input').val(), 10) - 1);
    } else {
      $('.spinner input').val(default_value);
    }
  });

  $('#password_form_random_password_length').val(8);
  $('#password_form_generate_password').click(function() {
    var password_length = $('#password_form_random_password_length').val();
    var json_url = Routes.api_v1_randompassword_path({ length: password_length });

    $.getJSON(json_url, function(data) {
      if(elementHasProperty('password', data)) {
        $('#password_form_password').val(data['password']);
      }
    });
  });
});
