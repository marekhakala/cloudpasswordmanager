function loadPasswordShow(directory_id, password_id) {
	var json_url = Routes.api_v1_directory_entry_password_entry_path(directory_id, password_id);

	$.getJSON(json_url, function(data) {
		var password_entry = data['result'];
		var password_entry_label = "";
		var password_entry_description = "";
		var password_entry_account = "";
		var password_entry_password = "";
		var password_entry_email = "";
		var password_entry_url = "";

		if(password_entry !== typeof undefined && password_entry != null) {
			password_entry_label = (elementHasProperty('label', password_entry)) ? password_entry['label'] : "";
			password_entry_description = (elementHasProperty('description', password_entry)) ? password_entry['description'] : "";
			password_entry_account = (elementHasProperty('account', password_entry)) ? password_entry['account'] : "";


			password_entry_password = (elementHasProperty('password', password_entry)) ? password_entry['password'] : "";
			password_entry_email = (elementHasProperty('email', password_entry)) ? password_entry['email'] : "";
			password_entry_url = (elementHasProperty('url', password_entry)) ? "<a href=\"" + password_entry['url'] + "\" target=\"_blank\">" + password_entry['url'] + "</a>" : "";
		}

		$('#password_show_label').html(password_entry_label);
		$('#password_show_description_value').html(password_entry_description);

		$('#password_show_account_buttons')
		.html(showCreateCopyButton("password_show_account_copy_button", I18n.t('copy_account_title'), "account_value", password_entry_account));
		$('#password_show_account_value').html(password_entry_account);

		$('#password_show_password_buttons')
		.html(showCreateCopyButton("password_show_password_copy_button", I18n.t('copy_password_title'), "password_value", password_entry_password));
		$('#password_show_password_value').html(createPasswordField(password_entry_password));
		loadPasswordShowSetupShowHideButton($('#password_show_show_hide_button'));

		$('#password_show_email_buttons')
		.html(showCreateCopyButton("password_show_email_copy_button", I18n.t('copy_email_title'), "email_value", password_entry_email));
		$('#password_show_email_value').html(password_entry_email);

		$('#password_show_url_buttons')
		.html(showCreateCopyButton("password_show_url_copy_button", I18n.t('copy_url_title'), "url_value", password_entry['url']));
		$('#password_show_url_value').html(password_entry_url);

		var passwordShowAccountCopyButtonZeroClipboard = new ZeroClipboard($("#password_show_account_copy_button"));
		var passwordShowPasswordCopyButtonZeroClipboard = new ZeroClipboard($("#password_show_password_copy_button"));
		var passwordShowEmailCopyButtonZeroClipboard = new ZeroClipboard($("#password_show_email_copy_button"));
		var passwordShowUrlCopyButtonZeroClipboard = new ZeroClipboard($("#password_show_url_copy_button"));
		$('#password_show_modal').modal();
	});
}

function createPasswordField(password_value) {
	var password_value_asterisk = "";

	for(var i = 0; i < 10; i++)
		password_value_asterisk += "*";

	outputHtml = "<button id=\"password_show_show_hide_button\" title=\"" + I18n.t('show_title') + " " + I18n.t('hide_title') + "\" class=\"btn btn-xs btn-default\" data-password-show-password-view-state=\"hide\"><i class=\"fa fa-eye\"></i> " + I18n.t('show_title') + "</button>";
	outputHtml += "&nbsp;<span id=\"password_show_show_hide_password_value_asterisk\">" + password_value_asterisk + "</span>";
	outputHtml += "<span id=\"password_show_show_hide_password_value_plain\" class=\"block-hidden\">" + password_value + "</span>";
	return outputHtml;
}

function loadPasswordShowSetupShowHideButton(object) {
	object.click(function() {
		var outputHtml = "";
		var viewState = "";

		var spanValueAsterisk = $('#password_show_show_hide_password_value_asterisk');
		var spanValuePlain = $('#password_show_show_hide_password_value_plain');
		var state = $('#password_show_show_hide_button').attr("data-password-show-password-view-state");

		if(state === "hide") {
			if(spanValuePlain.hasClass('block-hidden'))
				spanValuePlain.removeClass('block-hidden');

			if(!spanValueAsterisk.hasClass('block-hidden'))
				spanValueAsterisk.addClass('block-hidden');

			outputHtml = "<i class=\"fa fa-eye\"></i> " + I18n.t('hide_title');
			viewState = "show";
		} else {
			if(spanValueAsterisk.hasClass('block-hidden'))
				spanValueAsterisk.removeClass('block-hidden');

			if(!spanValuePlain.hasClass('block-hidden'))
				spanValuePlain.addClass('block-hidden');

			outputHtml = "<i class=\"fa fa-eye\"></i> " + I18n.t('show_title');
			viewState = "hide";
		}

		object.html(outputHtml);
		object.attr("data-password-show-password-view-state", viewState);
	});
}

function loadPasswordNew(directory_id) {
	$('#password_form_alert_container').html("");
	$('#password_form_data').attr("data-directory-id", directory_id);
	$('#password_form_title').html("<i class=\"fa fa-lock\"></i> " + I18n.t('directory_entries.right_side.password_list_new_password'));
	$('#password_form_label').val("");
	$('#password_form_description').val("");
	$('#password_form_account').val("");
	$('#password_form_password').val("");
	$('#password_form_email').val("");
	$('#password_form_url').val("");
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

	var buttonSaveHtml = "<button id=\"password_from_button_save\" type=\"button\" class=\"btn btn-info\">";
	buttonSaveHtml += "<i class=\"fa fa-floppy-o\"></i> " + I18n.t('save_title') + "</button>";
	$('#password_form_actions').html(buttonSaveHtml);
	$('#password_from_button_save').click(function() {
		 checkAndSavePasswordForm(directory_id, null, apiPasswordEntryNew);
	});
	$('#password_form_modal').modal();
}

function loadPasswordEdit(directory_id, password_id) {
	var json_url = Routes.api_v1_directory_entry_password_entry_path(directory_id, password_id);

	$.getJSON(json_url, function(data) {
		var password_entry = data['result'];
		var password_entry_label = "";
		var password_entry_description = "";
		var password_entry_account = "";
		var password_entry_password = "";
		var password_entry_email = "";
		var password_entry_url = "";

		if(password_entry !== typeof undefined && password_entry != null) {
			if(elementHasProperty('label', password_entry))
				password_entry_label = password_entry['label'];

			if(elementHasProperty('description', password_entry))
				password_entry_description = password_entry['description'];

			if(elementHasProperty('account', password_entry))
				password_entry_account = password_entry['account'];

			if(elementHasProperty('password', password_entry))
				password_entry_password = password_entry['password'];

			if(elementHasProperty('email', password_entry))
				password_entry_email = password_entry['email'];

			if(elementHasProperty('url', password_entry))
				password_entry_url = password_entry['url'];
		}

		$('#password_form_alert_container').html("");
		$('#password_form_data').attr('data-directory-id', directory_id);
		$('#password_form_data').attr('data-password-id', password_id);
		$('#password_form_title').html("<i class=\"fa fa-lock\"></i> " + I18n.t('directory_entries.modal_windows.password_form_edit_title'));
		$('#password_form_label').val(password_entry_label);
		$('#password_form_description').val(password_entry_description);
		$('#password_form_account').val(password_entry_account);
		$('#password_form_password').val(password_entry_password);
		$('#password_form_email').val(password_entry_email);
		$('#password_form_url').val(password_entry_url);
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

		var buttonSaveHtml = "<button id=\"password_from_button_save\" type=\"button\" class=\"btn btn-info\">";
		buttonSaveHtml += "<i class=\"fa fa-floppy-o\"></i> " + I18n.t('save_title') + "</button>";

		$('#password_form_actions').html(buttonSaveHtml);
		$('#password_from_button_save').click(function() {
			checkAndSavePasswordForm(directory_id, password_id, apiPasswordEntryUpdate);
		});
		$('#password_form_modal').modal();
	});
}

function loadPasswordDelete(directory_id, password_id, password_label) {
	var buttonDeleteHtml = "<button id=\"password_delete_button_delete\" type=\"button\" class=\"btn btn-danger\">";
	buttonDeleteHtml += "<i class=\"fa fa-check\"></i> " + I18n.t('yes_title') + "</button>";
	var deleteTitleHtml = "<i class=\"fa fa-lock\"></i> " + I18n.t('directory_entries.modal_windows.password_form_delete_title') + ": " + password_label;

	$('#password_delete_title').html(deleteTitleHtml);
	$('#password_delete_actions').html(buttonDeleteHtml);
	$('#password_delete_button_delete').click(function() {
		apiPasswordEntryDelete(directory_id, password_id);
	});
	$('#password_delete_modal').modal();
}

function loadPasswordCopyTo(directory_id, password_entries) {
	var buttonMoveToHtml = "<button id=\"password_copy_to_move_to_button\" type=\"button\" class=\"btn btn-danger\">";
	buttonMoveToHtml += "<i class=\"fa fa-check\"></i> " + I18n.t('yes_title') + "</button>";

	$('#password_copy_to_move_to_alert_container').html("");
	$('#password_copy_to_move_to_title').html("<i class=\"fa fa-files-o\"></i> " + I18n.t('directory_entries.right_side.copy_to_label'));
	$('#password_copy_to_move_to_actions').html(buttonMoveToHtml);

	$.getJSON(Routes.api_v1_user_directories_path(), function(data) {
		 if (elementHasProperty('status', data) && data['status'] !== 'failed') {
			 var htmlOutput = "";
			 var directories = data['directories'];

			 for(var i = 0; i < directories.length; i++) {
				 var dataItem = directories[i];
				 htmlOutput += "<option value=\"" + dataItem['id'] + "\"" + ((dataItem['parent_directory_id'] == null) ? " selected>" : ">");
				 htmlOutput += dataItem['directory_path'] + "</option>";
			 }

			 $('#password_copy_to_move_to_directory').html(htmlOutput);
			 var items = {};
			 var idItems = [];
			 var labelItems = [];
			 var liItemHtml = "";

			 for(var i = 0; i < password_entries.length; i++) {
				 var item = password_entries[i];
				 idItems[idItems.length] = item['id'];
				 labelItems[labelItems.length] = item['label'];
				 liItemHtml += "<li>" + item['label'] + "</li>";
			 }

			 items['ids'] = idItems;
			 items['labels'] = labelItems;
			 $('#password_copy_to_move_to_passwords_list').html(liItemHtml);
			 $('#password_copy_to_move_to_button').click(function() {
				 checkAndMoveOrCopyPasswordForm(directory_id, items, apiPasswordCopyTo);
			 });
			 $('#password_copy_to_move_to_modal').modal();
	 	}
	});
}

function loadPasswordMoveTo(directory_id, password_entries) {
	var buttonMoveToHtml = "<button id=\"password_copy_to_move_to_button\" type=\"button\" class=\"btn btn-danger\">";
	buttonMoveToHtml += "<i class=\"fa fa-check\"></i> " + I18n.t('yes_title') + "</button>";

	$('#password_copy_to_move_to_alert_container').html("");
	$('#password_copy_to_move_to_title').html("<i class=\"fa fa-share\"></i> " + I18n.t('directory_entries.right_side.move_to_label'));
	$('#password_copy_to_move_to_actions').html(buttonMoveToHtml);

	$.getJSON(Routes.api_v1_user_directories_path(), function(data) {
		 if (elementHasProperty('status', data) && data['status'] !== 'failed') {
			 var htmlOutput = "";
			 var directories = data['directories'];

			 for(var i = 0; i < directories.length; i++) {
				 var dataItem = directories[i];
				 htmlOutput += "<option value=\"" + dataItem['id'] + "\"" + ((dataItem['parent_directory_id'] == null) ? " selected>" : ">");
				 htmlOutput += dataItem['directory_path'] + "</option>";
			 }
			 $('#password_copy_to_move_to_directory').html(htmlOutput);
			 var items = {};
			 var idItems = [];
			 var labelItems = [];
			 var liItemHtml = "";

			 for(var i = 0; i < password_entries.length; i++) {
			 	var item = password_entries[i];
			 	idItems[idItems.length] = item['id'];
			 	labelItems[labelItems.length] = item['label'];
			 	liItemHtml += "<li>" + item['label'] + "</li>";
			 }

			 items['ids'] = idItems;
			 items['labels'] = labelItems;
			 $('#password_copy_to_move_to_passwords_list').html(liItemHtml);
			 $('#password_copy_to_move_to_button').click(function() {
				 checkAndMoveOrCopyPasswordForm(directory_id, items, apiPasswordMoveTo);
			 });
			 $('#password_copy_to_move_to_modal').modal();
	 	}
	});
}

function loadPasswordDeleteAll(directory_id, password_entries) {
	var buttonDeleteHtml = "<button id=\"password_delete_all_button_delete\" type=\"button\" class=\"btn btn-danger\">";
	buttonDeleteHtml += "<i class=\"fa fa-check\"></i> " + I18n.t('yes_title') + "</button>";

	var deleteTitleHtml = "<i class=\"fa fa-lock\"></i> " + I18n.t('directory_entries.modal_windows.password_form_delete_all_text');
	$('#password_delete_all_title').html(deleteTitleHtml);
	$('#password_delete_all_actions').html(buttonDeleteHtml);

	var items = [];
	var liItemHtml = "";
	for(var i = 0; i < password_entries.length; i++) {
		var item = password_entries[i];

		if(elementHasProperty('available', item) && item['available']) {
			items[items.length] = item['id'];
			liItemHtml += "<li>" + item['label'] + "</li>";
		}
	}

	$('#password_delete_all_passwords_list').html(liItemHtml);
	$('#password_delete_all_button_delete').click(function() {
		apiPasswordDeleteAll(directory_id, items, function(data) {
			if (elementHasProperty('status', data) && data['status'] !== 'failed') {
				$('#password_delete_all_modal').modal('toggle');
				refreshUi();
			}
		});
	 });
	$('#password_delete_all_modal').modal();
}

function checkAndMoveOrCopyPasswordForm(directory_id, items, api_callback) {
	var password_copy_to_move_to_array = [];
	var password_copy_to_move_to_directory_value = $('#password_copy_to_move_to_directory').val();

	apiPasswordSelectedLabels(password_copy_to_move_to_directory_value, items, function(data) {
		if(elementHasProperty('status', data) && data['status'] !== "failed" && data['check_password_labels'] != null) {
			var labels = data['check_password_labels'];

			for(var i = 0; i < labels.length; i++) {
				var label_item = labels[i];

				if(!label_item['unique'])
					password_copy_to_move_to_array[password_copy_to_move_to_array.length] = label_item['label'] + " - " + I18n.t('directory_entries.modal_windows.password_form_label_exists');
			}

			if(!checkAndMoveOrCopyPasswordFormErrorMessage(password_copy_to_move_to_array)) {
				$('#password_copy_to_move_to_alert_container').html("");
				api_callback(directory_id, password_copy_to_move_to_directory_value, items, function(data) {
					if(elementHasProperty('status', data) && data['status'] !== "failed") {
						$('#password_copy_to_move_to_modal').modal('toggle');
						refreshUi();
					} else {
						var results = data['results'];

						for(var i = 0; i < results.length; i++) {
							var resultItem = results[i];

							if(resultItem['status'] == "failed")
								password_copy_to_move_to_array[password_copy_to_move_to_array.length] = resultItem['error'];
						}
						checkAndMoveOrCopyPasswordFormErrorMessage(password_copy_to_move_to_array);
					}
				});
			}
		} else {
			password_copy_to_move_to_array[password_copy_to_move_to_array.length] = I18n.t('directory_entries.forms_api_error');
			checkAndMoveOrCopyPasswordFormErrorMessage(password_copy_to_move_to_array);
		}
	});
}

function checkAndMoveOrCopyPasswordFormErrorMessage(password_copy_to_move_to_array) {
	if (password_copy_to_move_to_array.length > 0) {
		var error_title = password_copy_to_move_to_array.length + " " + I18n.t('directory_entries.modal_windows.password_form_passwords_errors') + ":";
		var error_content_html = "<div class=\"form-group\">";
		error_content_html += "<div id=\"password_copy_to_move_to_alert_message\" class=\"alert alert-danger\">";
		error_content_html += "<h2>" + error_title + "</h2>";
		error_content_html += "<ul>";

		for(var i = 0; i < password_copy_to_move_to_array.length; i++)
			error_content_html += "<li>" + password_copy_to_move_to_array[i] + "</li>";
		error_content_html += "</ul></div></div>";

		$('#password_copy_to_move_to_alert_container').html(error_content_html);
		return true;
	}
	return false;
}

function checkAndSavePasswordFormErrorMessage(password_form_array) {
	if (password_form_array.length > 0) {
		var error_title = password_form_array.length + " " + I18n.t('directory_entries.modal_windows.password_form_password_errors') + ":";
		var error_content_html = "<div class=\"form-group\">";
		error_content_html += "<div id=\"password_form_alert_message\" class=\"alert alert-danger\">";
		error_content_html += "<h2>" + error_title + "</h2>";
		error_content_html += "<ul>";

		for(var i = 0; i < password_form_array.length; i++)
			error_content_html += "<li>" + password_form_array[i] + "</li>";
		error_content_html += "</ul></div></div>";

		$('#password_form_alert_container').html(error_content_html);
		return true;
	}
	return false;
}

function checkAndSavePasswordForm(directory_id, password_id, api_callback) {
	var password_form_array = [];
	var password_form_label_value = $('#password_form_label').val();
	var password_form_password_value = $('#password_form_password').val();

	if (objectIsEmpty(password_form_label_value))
		password_form_array[password_form_array.length] = I18n.t('directory_entries.modal_windows.password_form_label_cant_be_blank');

	if (objectIsEmpty(password_form_password_value))
		password_form_array[password_form_array.length] = I18n.t('directory_entries.modal_windows.password_form_password_cant_be_blank');

	if (!checkAndSavePasswordFormErrorMessage(password_form_array)) {
		var json_url = Routes.check_password_label_api_v1_directory_entry_path(directory_id, { password_label: password_form_label_value });

		$.getJSON(json_url, function(data) {
			if(elementHasProperty('status', data) && data['status'] !== "failed") {
				if(data['check_password_label']['unique']
				|| password_id === JSON.stringify(data['check_password_label']['id'])) {
					$('#password_form_alert_container').html("");
					api_callback(directory_id, password_id);
				} else {
					password_form_array[password_form_array.length] = I18n.t('directory_entries.modal_windows.password_form_label_exists');
					checkAndSavePasswordFormErrorMessage(password_form_array);
				}
			} else {
				password_form_array[password_form_array.length] = I18n.t('directory_entries.forms_api_error');
				checkAndSavePasswordFormErrorMessage(password_form_array);
			}
		});
	}
}
