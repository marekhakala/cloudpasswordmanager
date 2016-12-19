// Directory list - Clickable buttons
function reloadDirectoryPathFunctions() {
	$('.btn-dir-list-item').click(function() {
		var directory_id = $(this).attr('data-directory-id');
		setCurrentDirectory(directory_id);
	});
}

// Directory list - Loader
function reloadDirectoryTreeFunctions() {
	reloadDirectoryPathFunctions();

	// Directory list - Toggleable directory tree
	$('label.tree-toggler').click(function() {
		var directory_right = $(this).find('#directory_right')[0];
		var directory_down = $(this).find('#directory_down')[0];

		if ($(directory_right).hasClass("block-hidden")) {
			$(directory_right).removeClass("block-hidden");
			$(directory_down).addClass("block-hidden");
		} else {
			$(directory_down).removeClass("block-hidden");
			$(directory_right).addClass("block-hidden");
		}

		$(this).parent().children('ul.tree').toggle(300);
	});

	// Directory list - Context menu
	$(function() {
		$("label").contextmenu({
			target: '#directory_list_context_menu',
			onItem: function(e, item) {
				var current_directory_id = e.context.getAttribute("data-current-directory-id");
				var directory_id = e.context.getAttribute("data-directory-id");
				var directory_parent_id = e.context.getAttribute("data-directory-parent-id");
				var directory_label = e.context.getAttribute("data-directory-label");
				var action_name = item.target.getAttribute("data-action-name");

				var url_options = {};
				url_options['new_directory'] = { url: Routes.api_v1_directory_entries_path() };
				url_options['edit_directory'] = { url: Routes.api_v1_directory_entry_path(directory_id) };
				url_options['delete_directory'] = { url: Routes.api_v1_directory_entry_path(directory_id) };

				if (action_name == 'new_directory') {
					loadDirectoryNew(directory_id);
				} else if (action_name == 'edit_directory' && directory_parent_id !== "null") {
					loadDirectoryEdit(directory_id);
				} else if (action_name == 'delete_directory' && directory_parent_id !== "null") {
					loadDirectoryDelete(directory_id, directory_label);
				}
			}
		});

		// Directory list - New directory
		$('#directory_list_button_new_directory').click(function() {
			var directory_id = $('#directory_list_path').attr('data-current-directory-id');
			loadDirectoryNew(directory_id);
		});

		// Directory list - New password entry
		$('#directory_list_button_new_password_entry').click(function() {
			var directory_id = $('#directory_list_path').attr('data-current-directory-id');
			loadPasswordNew(directory_id);
		});

		// Directory list - Edit directory
		$('#directory_list_button_edit_directory').click(function() {
			var directory_id = $('#directory_list_path').attr('data-current-directory-id');
			var parent_directory_id = $('#directory_list_path').attr('data-parent-directory-id');

			if(parent_directory_id != null) {
				loadDirectoryEdit(directory_id);
			}
		});

		// Directory list - Delete directory
		$('#directory_list_button_delete_directory').click(function() {
			var directory_id = $('#directory_list_path').attr('data-current-directory-id');
			var parent_directory_id = $('#directory_list_path').attr('data-parent-directory-id');

			if(parent_directory_id != null) {
				var json_url = Routes.info_api_v1_directory_entry_path(directory_id);

				$.getJSON(json_url, function(data) {
					if(elementHasProperty('status', data) && data['status'] !== "failed") {
						var directory_label = data['directory_entry']['label'];
						loadDirectoryDelete(directory_id, directory_label);
					}
				});
			}
		});
	});
}

function fillDirectoryTreePath(data, classes) {
	var html = "";

	for(var i = 0; i < data.length; i++) {
		var url = "<a class=\"" + classes + " btn-dir-list-item\" data-directory-id=\"" + data[i]['id'] + "\">" + data[i]['label'] + "</a>";
		html += " / " + url;
	}

	return html;
}

function fillDirectoryTreeItemInfo(tree_level, current_path, data, inner_html, current_directory_id) {
	var showInPath = isInPath(current_path, data['parent_directory_id']);
	var html = "<ul class=\"nav tree\"" + ((showInPath) ? ">" : " style=\"display: none;\">");
	html += "<li" + ((current_directory_id == data['id']) ? " class=\"directory-active\">" : ">");

	for(var i = 0; i < tree_level; i++)
		html += "<span class=\"indent\"></span>";

	html += "<label class=\"directory-label tree-toggler nav-header\" data-current-directory-id=\"" + current_directory_id + "\"";
	html += " data-directory-parent-id=\"" + data['parent_directory_id'] + "\" data-directory-id=\"" + data['id'] + "\"";
	html += " data-directory-label=\"" + data['label'] + "\" data-toggle=\"context\""
	html += " data-target=\"#directory_list_context_menu\" title=\"" + data['description'] + "\">";

	if(data['number_directories'] > 0) {
		var is_opened = ((isInPath(current_path, data['id'])) ? true : false);
		html += "<span id=\"directory_right\"" + ((is_opened) ? ">" : " class=\"block-hidden\">");
		html += "<i class=\"fa fa-chevron-down\"></i></span>";
		html += "<span id=\"directory_down\"" + ((is_opened) ? " class=\"block-hidden\">" : ">");
		html += "<i class=\"fa fa-chevron-right\"></i></span>";
	} else {
		html += "<span class=\"indent_leaf\"></span>";
	}

	var url = "<a class=\"btn btn-info btn-xs btn-dir-list-item\" data-directory-id=\"" + data['id'] + "\">" + data['label'] + "</a>";

	html += "&nbsp;<i class=\"fa fa-folder-o\"></i> " + url + " <small>(" + data['number_passwords'] + ")</small>";
	html += "</label>";
	html += inner_html;
	html += "</li></ul>";

	return html;
}

function fillDirectoryTree(tree_level, current_path, data, current_directory_id) {
	var directory_entry = data['directory_entry'];
	var directories = directory_entry['directories'];
	var html = "";

	if(directories && directories.length > 0)
		for(var i = 0; i < directories.length; i++)
			html += fillDirectoryTree(tree_level+1, current_path, directories[i], current_directory_id);
	return fillDirectoryTreeItemInfo(tree_level, current_path, data['directory_entry'], html, current_directory_id);
}

function loadDirectoryListInner(url) {
	// Directory list - Loading
	loadingInfo($('#directory_list_content'));
	// Current path panel - Loading
	loadingInfo($('#directory_list_path'));

	// Api data - Loading
	$.getJSON(url, function(data) {
		 if (data.hasOwnProperty('status') && data['status'] == 'failed') {
			 loadDirectoryListDefault();
			 return;
		 }

		 $('#directory_list_path').attr('data-current-directory-id', data['current_directory_id']);
		 $('#directory_list_path').attr('data-parent-directory-id', data['parent_directory_id']);

		 var path_panel = $('#directory_list_path');
		 path_panel.removeClass('content_loading');
		 path_panel.html(fillDirectoryTreePath(data['current_directory_path'], 'btn btn-default btn-xs'));

		 var directory_entries = data['directory_entries'];
		 var current_directory_id = data['current_directory_id'];
		 var content_panel = $('#directory_list_content');
		 content_panel.html(fillDirectoryTree(0, data['current_directory_path'], directory_entries, current_directory_id));
		 content_panel.removeClass('content_loading');
		 reloadDirectoryTreeFunctions();

		 loadPasswordList(data['current_directory_id']);
	});
}

function loadDirectoryListDefault() {
	loadDirectoryListInner(Routes.api_v1_directory_entries_path());
}

function loadDirectoryList(id) {
	var json_url = (id != null) ? Routes.api_v1_directory_entry_path(id) : Routes.api_v1_directory_entries_path();
	loadDirectoryListInner(json_url);
}
