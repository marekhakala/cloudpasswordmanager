function fillPasswordRow(data, index) {
	if(data['label'] == null)
		data['label'] = "";

	if(data['description'] == null)
		data['description'] = "";

	var html = "<tr class=\"table-list-row\">";
	html += "<td class=\"item-key-checkbox-td center\">";
	html += "<span class=\"item-key-checkbox block-hidden\">";
	html += "<span class=\"item-key-id block-hidden\">" + data['id'] + "</span>";
	html += "<i class=\"fa fa-check\" title=\"Selected\"></i>";
	html += "</span>";
	html += "</td>";
	html += "<td class=\"center\">" + index + "</td>";
	html += "<td class=\"center\">";
	html += "<span style=\"color: black;\" title=\"" + data['label'] + "\"><b>";
	html += (data['label'].length <= 22) ? data['label'] : data['label'].substring(0, 22) + "...";
	html += "</b></span></td>";
	html += "<td>";
	html += "<span title=\"" + data['description'] + "\">";
	html += (data['description'] <= 42) ? data['description'] : data['description'].substring(0, 42) + "...";
	html += "</span></td>";
	html += "<td class=\"center\">";
	html += "<div class=\"btn-group\">";
	html += "<span id=\"list_password_value_" + index + "\" class=\"block-hidden\">" + data['password'] + "</span>";
	html += "<button class=\"btn btn-xs btn-default copy-item-action\" tittle=\" " + I18n.t('copy_password_title') + "\"";
	html += "data-clipboard-target=\"password_value\" data-clipboard-text=\"" + data['password'] + "\">";
	html += "<i class=\"fa fa-clipboard\"></i></button>";
	html += "<button class=\"btn btn-default btn-xs show-item-action\" title=\"" + I18n.t('view_title') + "\" data-directory-id=\"" + data['directory_id'] + "\" data-password-id=\"" + data['id'] + "\">";
	html += "<i class=\"fa fa-eye\"></i>";
	html += "</button>";
	html += "<button class=\"btn btn-default btn-xs edit-item-action\" title=\"" + I18n.t('edit_title') + "\" data-directory-id=\"" + data['directory_id'] + "\" data-password-id=\"" + data['id'] + "\">";
	html += "<i class=\"fa fa-pencil-square-o\"></i>";
	html += "</button>";
	html += "<button class=\"btn btn-default btn-xs delete-item-action\" title=\"" + I18n.t('delete_title') + "\" data-directory-id=\"" + data['directory_id'] + "\" data-password-id=\"" + data['id'] + "\"  data-password-label=\"" + data['label'] + "\">";
	html += "<i class=\"fa fa-times\"></i>";
	html += "</button>";
	html += "</div></td></tr>";

	return html;
}

function fillPasswordList(data) {
	var html = "";

	if(data.length == 0)
		emptyDirectoryInfo($('#password_list_info'));

	for(var i=0; i < data.length; i++)
		html += fillPasswordRow(data[i], i+1);

	return html;
}

function loadPasswordList(id) {
	var json_url = Routes.api_v1_directory_entry_password_entries_path(id);

	loadingInfo($('#password_list_info'));
	var obj = $($('table#password_list_items').children('tbody'));
	obj.html("");

	$.getJSON(json_url, function(data) {
		var obj = $($('table#password_list_items').children('tbody'));

		$('#password_list_info').html("");
		$('#password_list_info').removeClass('content_loading');
		obj.html(fillPasswordList(data['password_entries']));
		reloadPasswordListFunctions();
	});
}

function showCreateCopyButton(button_id, button_title, button_copy_target, copy_value) {
	var copy_button = "<button id=\"" + button_id + "\" class=\"btn btn-xs btn-default\" title=\"" + button_title + "\" ";
	copy_button += "data-clipboard-target=\"" + button_copy_target + "\" data-clipboard-text=\"" + copy_value + "\">";
	copy_button += "<i class=\"fa fa-clipboard\"></i> " + I18n.t('directory_entries.right_side.copy_label') + "</button>";

	if(objectIsEmpty(copy_value))
		return "";
	return copy_button;
}

function reloadPasswordListFunctions() {
	$(document).ready(function() {
		// Directory list - Table - Select function for row item
		$('.item-key-checkbox-td').click(function() {
			var item_key_checkbox = $(this).find('.item-key-checkbox');

			if($(this).hasClass('tableview-active-item')) {
				$(this).removeClass('tableview-active-item');
				item_key_checkbox.addClass('block-hidden');
				number_selected_items--;
			} else {
				$(this).addClass('tableview-active-item');
				item_key_checkbox.removeClass('block-hidden');
				number_selected_items++;
			}
			updateControlPanel();
		});

		// Directory list - Table - hover copy button
		$('.table-row-view').hover(function() {
		  var buttonSpanElement = $(this).find('.table-view-copy-button')[0];
		  buttonSpanElement.setAttribute("class", "table-view-copy-button");
		}, function () {
		  var buttonSpanElement = $(this).find('.table-view-copy-button')[0];
		  buttonSpanElement.setAttribute("class", "table-view-copy-button block-hidden");
		});

		// Directory list - Table - Copy function
		var copyItemAction = new ZeroClipboard($(".copy-item-action"))

		// Directory list - Table - Show function
		$('.show-item-action').click(function() {
			var directory_id = $(this).attr('data-directory-id');
			var password_id = $(this).attr('data-password-id');

			if(elementIsNotNull(directory_id) && elementIsNotNull(password_id))
				loadPasswordShow(directory_id, password_id);
		});

		// Directory list - Table - Edit function
		$('.edit-item-action').click(function() {
			var directory_id = $(this).attr('data-directory-id');
			var password_id = $(this).attr('data-password-id');

			if(elementIsNotNull(directory_id) && elementIsNotNull(password_id))
				loadPasswordEdit(directory_id, password_id);
		});

		// Directory list - Table - Delete function
		$('.delete-item-action').click(function() {
			var directory_id = $(this).attr('data-directory-id');
			var password_id = $(this).attr('data-password-id');
			var password_label = $(this).attr('data-password-label');

			if(elementIsNotNull(directory_id) && elementIsNotNull(password_id))
				loadPasswordDelete(directory_id, password_id, password_label);
		});
	});
}
