// Directory list - Counter of selected items
var number_selected_items = 0;

function createDirectoryPath(data) {
	var html = "";

	for(var i in data.current_directory_path) {
		var url = "<a class=\"modal-directory-list-item btn btn-default btn-xs btn-black\" data-directory-id=\"" + data.current_directory_path[i].id;
		url += "\">" + data.current_directory_path[i].label + "</a>";
      html += " / " + url;
	}
	return html;
}

function getCurrentDirectoryId() {
	var hash = window.location.hash;
	var hash_array = hash.substring(1, hash.length).split("/");
	var directory_id = null;

	if(hash_array.length >= 2 & hash_array[0] == "directory")
		directory_id = hash_array[1];
	return directory_id;
}

function loadFromUrlHash() {
	var hash = window.location.hash;
	var hash_array = hash.substring(1, hash.length).split("/");
	var hash_params = {};

	hash_params["directory"] = null;

	if(hash_array.length >= 2 & hash_array[0] == "directory")
		hash_params["directory"] = hash_array[1];

	loadDirectoryList(hash_params["directory"]);
}

function loadingInfo(context) {
	context.addClass('content_loading');
	context.html('<i class="fa fa-refresh fa-spin"></i> ' + I18n.t('directory_entries.loading_info'));
}

function emptyDirectoryInfo(context) {
	context.html('<p class="text-center">' + I18n.t('directory_entries.right_side.password_list_is_empty') + '</p>');
}

function setCurrentUrlHashFromParams(params) {
	var hash_params = "#";

	if("directory" in params) {
		hash_params += "directory/" + params["directory"];
	}

	if(hash_params != "#")
		window.location.hash = hash_params;
}

function refreshUi() {
	loadFromUrlHash();
	number_selected_items = 0;
	updateControlPanel();
}

function setCurrentDirectory(id) {
	setCurrentUrlHashFromParams({ directory: id });
	refreshUi();
}

function reloadDirectoryListFunctions() {
	$(document).ready(function() {
		$('.modal-directory-list-item').click(function() {
			var directory_id = $(this).attr('data-directory-id');
			getDirectoryList(null, null, directory_id);
		});
	});
}

// Password list - Selection of items
function updateControlPanel() {
	var panel = $('#password_list_panel');

	if(number_selected_items > 0) {
		if(panel.hasClass('block-hidden'))
			panel.removeClass('block-hidden');
	} else {
		if(!panel.hasClass('block-hidden'))
			panel.addClass('block-hidden');
	}
	$('#password_list_selected_items').text(number_selected_items);
}

function getListSelectedItems() {
	var list_of_selected_items = [];
	var list = $('.item-key-checkbox').not('.block-hidden');

	for (i = 0; i < list.length; i++) {
		var value = $(list[i]).children('.item-key-id')[0];
		list_of_selected_items.push($(value).html());
	}
	return list_of_selected_items;
}

function isDirectoryInPath(directory_id, array) {
	for(var i = 0; i < array.length; i++)
		if(array[i]['id'] == directory_id)
			return true;
	return false;
}

function isInPath(current_path, parent_directory_id) {
	if(parent_directory_id == null)
		return true;

	for(var i = 0; i < current_path.length; i++)
		if(current_path[i]['id'] === JSON.stringify(parent_directory_id))
			return true;
	return false;
}

function objectIsEmpty(object) {
	return (typeof object == typeof undefined || object == false || object.trim().length == 0);
}

function elementIsNotNull(attr) {
	return (typeof attr !== typeof undefined && attr !== false);
}

function elementHasProperty(property, object) {
	return (property in object && object[property] != null);
}

$(document).ready(function() {
	// Directory list - Table - Select all items
	$('#checkbox_all').click(function() {
		var list_keys = $('#password_list_items');

		var list_unselected_items = list_keys.find('.item-key-checkbox.block-hidden');
		var list_key_items = list_keys.find('.item-key-id');
		var unselect_all = true;

		if(list_unselected_items.size() == list_key_items.size())
			unselect_all = false;

		$.each(list_key_items, function(index, value) {
			var parent_object = $(this).parent();
			var tr_object = parent_object.parent().parent();

			if(unselect_all) {
				if(!parent_object.hasClass('block-hidden'))
					parent_object.addClass('block-hidden');

				if(tr_object.hasClass('tableview-active-item'))
					tr_object.removeClass('tableview-active-item');

				number_selected_items = 0;
			} else {
				if(parent_object.hasClass('block-hidden'))
					parent_object.removeClass('block-hidden');

				if(!tr_object.hasClass('tableview-active-item'))
					tr_object.addClass('tableview-active-item');

				number_selected_items = list_key_items.size();
			}
			updateControlPanel();
		});
	});

	// Directory list - Table - Copy to
	$('#directory-list-modal-copy-to-button').click(function() {
		var directory_id = $('#directory_list_path').attr('data-current-directory-id');
		var ids = getListSelectedItems();

		apiPasswordSelectedLabels(directory_id, ids, function(data) {
			loadPasswordCopyTo(directory_id, data['check_password_labels']);
		});
	});

	// Directory list - Table - Move to
	$('#directory-list-modal-move-to-button').click(function() {
		var directory_id = $('#directory_list_path').attr('data-current-directory-id');
		var ids = getListSelectedItems();

		apiPasswordSelectedLabels(directory_id, ids, function(data) {
			loadPasswordMoveTo(directory_id, data['check_password_labels']);
		});
	});

	// Directory list - Table - Delete all
	$('#directory-list-modal-delete-button').click(function() {
		var directory_id = $('#directory_list_path').attr('data-current-directory-id');
		var ids = getListSelectedItems();

		apiPasswordDeleteAllNames(directory_id, ids, function(data) {
			loadPasswordDeleteAll(directory_id, data['password_entries_infos']);
		});
	});

	// Password entry - new / edit view component - spinner
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

	// Directory list - refresh function
	$('#directory_list_refresh').click(function() {
		refreshUi();
	});

	// Init all from url
	refreshUi();
});
