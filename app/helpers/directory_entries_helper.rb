module DirectoryEntriesHelper
  def is_directory_in_path? directory_id, array
    array.each do |directory|
      return true if directory["id"].to_s == directory_id.to_s
    end

    false
  end

  def create_directory_path directory
    @array_of_directories_in_path = Array.new

    unless directory.nil?
      @array_of_directories_in_path << directory.label
      inner_create_directory_path directory
    end

    @array_of_directories_in_path
  end

  def inner_create_directory_path directory
    directory = directory.directory_entry unless directory.nil?
    return if directory.nil?
    @array_of_directories_in_path.unshift directory.label
    inner_create_directory_path directory
  end

  def current_directory_path directory
    @array_of_directories = Array.new

    unless directory.nil?
      parentDirectoryId = nil
      parentDirectoryId = directory.directory_entry.id unless directory.directory_entry.nil?

      item = { "id" => directory.id.to_s, "label" => directory.label, "parent_directory_id" => parentDirectoryId }
      @array_of_directories << item
      inner_current_directory_path directory
    end

    @array_of_directories
  end

  def inner_current_directory_path directory
    directory = directory.directory_entry unless directory.nil?
    return if directory.nil?

    parentDirectoryId = nil
    parentDirectoryId = directory.directory_entry.id unless directory.directory_entry.nil?

    item = { "id" => directory.id.to_s, "label" => directory.label, "parent_directory_id" => parentDirectoryId }
    @array_of_directories.unshift item
    inner_current_directory_path directory
  end
end
