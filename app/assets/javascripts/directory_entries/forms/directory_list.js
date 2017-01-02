function loadDirectoryNew(directory_id) {
	$('#directory_form_data').html("");
	$('#directory_form_label').val("");
	$('#directory_form_description').val("");
	$('#directory_form_title').html("<i class=\"fa fa-folder\"></i> " + I18n.t('directory_entries.left_side.new_directory'));
	$('#directory_form_alert_container').html("");

	$.getJSON(Routes.api_v1_user_directories_path(), function(data) {
		 if (elementHasProperty('status', data) && data['status'] !== 'failed') {
			 var htmlOutput = "";
			 var directories = data['directories'];

			 for(var i = 0; i < directories.length; i++) {
				 var dataItem = directories[i];
				 htmlOutput += "<option value=\"" + dataItem['id'] + "\"" + ((directory_id == dataItem['id']) ? " selected>" : ">");
				 htmlOutput += dataItem['directory_path'] + "</option>";
			 }

			 $('#directory_form_directory').html(htmlOutput);
			 var buttonSaveHtml = "<button id=\"directory_form_button_save\" type=\"button\" class=\"btn btn-info\">";
			 buttonSaveHtml += "<i class=\"fa fa-floppy-o\"></i> " + I18n.t('save_title') + "</button>";
			 $('#directory_form_actions').html(buttonSaveHtml);

			 $('#directory_form_button_save').click(function() {
				 checkAndSaveDirectoryForm(directory_id, null, apiDirectoryEntryNew);
			 });

			 $('#directory_form_modal').modal();
	 	}
	});
}

function loadDirectoryEdit(directory_id) {
	var json_url = Routes.info_api_v1_directory_entry_path(directory_id);

	$.getJSON(json_url, function(data) {
		var directory_entry = data['directory_entry'];
		var directory_entry_label = "";
		var directory_entry_description = "";
		var directory_entry_directory = "";

		if(directory_entry !== typeof undefined && directory_entry != null) {
			if(elementHasProperty('label', directory_entry))
				directory_entry_label = directory_entry['label'];

			if(elementHasProperty('description', directory_entry))
				directory_entry_description = directory_entry['description'];

			if(elementHasProperty('directory_entry_id', directory_entry))
				directory_entry_directory = directory_entry['directory_entry_id'];
		}

		$('#directory_form_alert_container').html("");
		$('#directory_form_data').attr("data-directory-id", directory_id);
		$('#directory_form_title').html("<i class=\"fa fa-folder\"></i> " + I18n.t('directory_entries.left_side.edit_directory'));
		$('#directory_form_label').val(directory_entry_label);
		$('#directory_form_description').val(directory_entry_description);

		$.getJSON(Routes.api_v1_user_directories_path(), function(data) {
			 if (elementHasProperty('status', data) && data['status'] !== 'failed') {
				 var htmlOutput = "";
				 var directories = data['directories'];

				 for(var i=0; i < directories.length; i++) {
					 var dataItem = directories[i];
					 htmlOutput += "<option value=\"" + dataItem['id'] + "\"" + ((directory_entry['parent_directory_id'] == dataItem['id']) ? " selected>" : ">");
					 htmlOutput += dataItem['label'] + "</option>";
				 }

				 $('#directory_form_directory').html(htmlOutput);
				 var buttonSaveHtml = "<button id=\"directory_form_button_save\" type=\"button\" class=\"btn btn-info\">";
				 buttonSaveHtml += "<i class=\"fa fa-floppy-o\"></i> " + I18n.t('save_title') + "</button>";
				 $('#directory_form_actions').html(buttonSaveHtml);
				 $('#directory_form_button_save').click(function() {
					 checkAndSaveDirectoryForm(directory_entry['parent_directory_id'], directory_id, apiDirectoryEntryUpdate);
				 });

				 $('#directory_form_modal').modal();
		 	}
		});
	});
}

function loadDirectoryDelete(directory_id, directory_label) {
  var buttonDeleteHtml = "<button id=\"directory_delete_button_delete\" type=\"button\" class=\"btn btn-danger\">";
	buttonDeleteHtml += "<i class=\"fa fa-check\"></i> " + I18n.t('yes_title') + "</button>";

	var deleteTitleHtml = "<i class=\"fa fa-folder\"></i> " + I18n.t('directory_entries.left_side.delete_directory_title') + ": " + directory_label;
	$('#directory_delete_title').html(deleteTitleHtml);

	$('#directory_delete_actions').html(buttonDeleteHtml);
	$('#directory_delete_button_delete').click(function() { apiDirectoryEntryDelete(directory_id); });
	$('#directory_delete_modal').modal();
}

function checkAndSaveDirectoryFormErrorMessage(directory_form_array) {
	if (directory_form_array.length > 0) {
		var error_title = directory_form_array.length + " " + I18n.t('directory_entries.modal_windows.directory_form_errors') + ":";
		var error_content_html = "<div class=\"form-group\">";
		error_content_html += "<div id=\"directory_form_alert_message\" class=\"alert alert-danger\">";
		error_content_html += "<h2>" + error_title + "</h2>";
		error_content_html += "<ul>";

		for(var i = 0; i < directory_form_array.length; i++)
			error_content_html += "<li>" + directory_form_array[i] + "</li>";
		error_content_html += "</ul></div></div>";

		$('#directory_form_alert_container').html(error_content_html);
		return true;
	}
	return false;
}

function checkAndSaveDirectoryForm(parent_directory_id, directory_id, api_callback) {
	var directory_form_array = [];
	var directory_form_label_value = $('#directory_form_label').val();
	var directory_form_directory_value = $('#directory_form_directory').val();

	if (objectIsEmpty(directory_form_label_value))
		directory_form_array[directory_form_array.length] = I18n.t('directory_entries.modal_windows.directory_form_label_cant_be_blank');

	if (objectIsEmpty(directory_form_directory_value))
		directory_form_array[directory_form_array.length] = I18n.t('directory_entries.modal_windows.directory_form_directory_cant_be_blank');

	if(!checkAndSaveDirectoryFormErrorMessage(directory_form_array)) {
		var json_url = Routes.check_directory_label_api_v1_directory_entry_path(parent_directory_id, { directory_label: directory_form_label_value });

		$.getJSON(json_url, function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				if(data['check_directory_label']['unique']
				|| directory_id === JSON.stringify(data['check_directory_label']['id'])) {
					$('#directory_form_alert_container').html("");
					api_callback(directory_id);
				} else {
					directory_form_array[directory_form_array.length] = I18n.t('directory_entries.modal_windows.directory_form_error_label_exist');
					checkAndSaveDirectoryFormErrorMessage(directory_form_array);
				}
			} else {
				directory_form_array[directory_form_array.length] = I18n.t('directory_entries.forms_api_error');
				checkAndSaveDirectoryFormErrorMessage(directory_form_array);
			}
		});
	}
}
