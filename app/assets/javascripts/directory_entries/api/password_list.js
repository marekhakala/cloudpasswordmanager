function apiPasswordEntryNew(directory_id, password_id) {
	var json_url = Routes.api_v1_directory_entry_password_entries_path(directory_id);
	var password_entry_label = $('#password_form_label').val();
	var password_entry_description = $('#password_form_description').val();
	var password_entry_account = $('#password_form_account').val();
	var password_entry_password = $('#password_form_password').val();
	var password_entry_email = $('#password_form_email').val();
	var password_entry_url = $('#password_form_url').val();

	$.ajax({
		type: "POST",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "password_entry": { "label": password_entry_label,
			"description": password_entry_description, "account": password_entry_account,
			"password": password_entry_password, "email": password_entry_email,
			"url": password_entry_url }}),
		complete: function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				$('#password_form_modal').modal('toggle');
				refreshUi();
			} else {
				var error_content_html = "<div class=\"form-group\">";
				error_content_html += "<div id=\"password_form_alert_message\" class=\"alert alert-danger\">";
				error_content_html += "<h2>Error</h2></div></div>";
				$('#password_form_alert_container').html(error_content_html);
			}
		}
	});
}

function apiPasswordEntryUpdate(directory_id, password_id) {
	var json_url = Routes.api_v1_directory_entry_password_entry_path(directory_id, password_id);
	var password_entry_label = $('#password_form_label').val();
	var password_entry_description = $('#password_form_description').val();
	var password_entry_account = $('#password_form_account').val();
	var password_entry_password = $('#password_form_password').val();
	var password_entry_email = $('#password_form_email').val();
	var password_entry_url = $('#password_form_url').val();

	$.ajax({
		type: "PUT",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "password_entry": { "label": password_entry_label,
			"description": password_entry_description, "account": password_entry_account,
			"password": password_entry_password, "email": password_entry_email,
			"url": password_entry_url }}),
		complete: function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				$('#password_form_modal').modal('toggle');
				refreshUi();
			} else {
				var error_content_html = "<div class=\"form-group\">";
				error_content_html += "<div id=\"password_form_alert_message\" class=\"alert alert-danger\">";
				error_content_html += "<h2>Error</h2></div></div>";
				$('#password_form_alert_container').html(error_content_html);
			}
		}
	});
}

function apiPasswordEntryDelete(directory_id, password_id) {
	var json_url = Routes.api_v1_directory_entry_password_entry_path(directory_id, password_id);

	$.ajax({
		type: "DELETE",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		complete: function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				$('#password_delete_modal').modal('toggle');
				refreshUi();
			} else {
				var error_content_html = "<div class=\"form-group\">";
				error_content_html += "<div id=\"password_form_alert_message\" class=\"alert alert-danger\">";
				error_content_html += "<h2>Error</h2></div></div>";
				$('#password_form_alert_container').html(error_content_html);
			}
		}
	});
}

function apiPasswordSelectedLabels(directory_id, items, api_callback) {
	var json_url = Routes.check_password_labels_api_v1_directory_entry_path(directory_id);

	$.ajax({
		type: "POST",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "labels": items['labels'] }),
		success: function(data) {
			api_callback(data);
		},
		failure: function(errMsg) {
			api_callback(errorMessage);
		}
	});
}

function apiPasswordDeleteAllNames(directory_id, items, api_callback) {
	var json_url = Routes.infos_api_v1_directory_entry_password_entries_path(directory_id);

	$.ajax({
		type: "POST",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "password_entries_infos": { "ids": items['ids'] }}),
		success: function(data) {
			api_callback(data);
		},
		failure: function(errMsg) {
			api_callback(errorMessage);
		}
	});
}

function apiPasswordCopyTo(orig_directory_id, directory_id, items, api_callback) {
	var json_url = Routes.copy_to_api_v1_directory_entry_path(orig_directory_id);

	$.ajax({
		type: "POST",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "copy_to_directory": { "into": directory_id, "ids": items['ids'] }}),
		success: function(data) {
			api_callback(data);
		},
		failure: function(errMsg) {
			api_callback(errorMessage);
		}
	});
}

function apiPasswordMoveTo(orig_directory_id, directory_id, items, api_callback) {
	var json_url = Routes.move_to_api_v1_directory_entry_path(orig_directory_id);

	$.ajax({
		type: "POST",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "move_to_directory": { "into": directory_id, "ids": items['ids'] }}),
		success: function(data) {
			api_callback(data);
		},
		failure: function(errMsg) {
			api_callback(errorMessage);
		}
	});
}

function apiPasswordDeleteAll(directory_id, ids, api_callback) {
	var json_url = Routes.delete_all_api_v1_directory_entry_path(directory_id);

	$.ajax({
		type: "POST",
		dataType: "json",
		url: json_url,
		contentType: "application/json",
		data: JSON.stringify({ "delete_all_directories": { "ids": ids }}),
		success: function(data) {
			api_callback(data);
		},
		failure: function(errMsg) {
			api_callback(errorMessage);
		}
	});
}
