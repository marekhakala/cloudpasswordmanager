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
	context.html('<i class="fa fa-refresh fa-spin"></i> Loading...');
}

function emptyDirectoryInfo(context) {
	context.html('<p class="text-center">The directory is empty.</p>');
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
	// Directory list - refresh function
	$('#directory_list_refresh').click(function() {
		refreshUi();
	});

	// Init all from url
	refreshUi();
});
