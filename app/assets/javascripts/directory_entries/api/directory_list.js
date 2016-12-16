function apiDirectoryEntryNew(directory_id) {
	var json_url = Routes.api_v1_directory_entries_path();
	var directory_entry_label = $('#directory_form_label').val();
	var directory_entry_description = $('#directory_form_description').val();
	var directory_entry_directory = $('#directory_form_directory').val();

	$.ajax({
		type: "POST",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "directory_entry": { "label": directory_entry_label,
			"description": directory_entry_description, "directory_entry_id": directory_entry_directory }}),
		complete: function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				$('#directory_form_modal').modal('toggle');
				refreshUi();
			} else {
				var error_content_html = "<div class=\"form-group\">";
				error_content_html += "<div id=\"directory_form_alert_message\" class=\"alert alert-danger\">";
				error_content_html += "<h2>Error</h2></div></div>";
				$('#directory_form_alert_container').html(error_content_html);
			}
		}
	});
}

function apiDirectoryEntryUpdate(directory_id) {
	var json_url = Routes.api_v1_directory_entry_path(directory_id);
	var directory_entry_label = $('#directory_form_label').val();
	var directory_entry_description = $('#directory_form_description').val();
	var directory_entry_directory = $('#directory_form_directory').val();

	$.ajax({
		type: "PUT",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "directory_entry": { "label": directory_entry_label,
			"description": directory_entry_description, "directory_entry_id": directory_entry_directory }}),
		complete: function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				$('#directory_form_modal').modal('toggle');
				refreshUi();
			} else {
				var error_content_html = "<div class=\"form-group\">";
				error_content_html += "<div id=\"directory_form_alert_message\" class=\"alert alert-danger\">";
				error_content_html += "<h2>Error</h2></div></div>";
				$('#directory_form_alert_container').html(error_content_html);
			}
		}
	});
}

function apiDirectoryEntryDelete(directory_id) {
	var json_url = Routes.api_v1_directory_entry_path(directory_id);

	$.ajax({
		type: "DELETE",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		complete: function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				$('#directory_delete_modal').modal('toggle');
				refreshUi();
			} else {
				var error_content_html = "<div class=\"form-group\">";
				error_content_html += "<div id=\"directory_form_alert_message\" class=\"alert alert-danger\">";
				error_content_html += "<h2>Error</h2></div></div>";
				$('#directory_form_alert_container').html(error_content_html);
			}
		}
	});
}
