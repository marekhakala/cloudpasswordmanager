class DirectoryEntrySerializer < BaseSerializer
  attributes :id, :label, :number_directories, :number_passwords, :parent_directory_id, :description, :directories, :created_at

   def user
     resolve_reference object.user
   end

   def number_directories
     return object.directory_entries.length unless object.directory_entries.nil?
     0
   end

   def number_passwords
     return object.password_entries.length unless object.password_entries.nil?
     0
   end

   def parent_directory_id
     return object.directory_entry.id if not object.nil? and not object.directory_entry.nil?
     nil
   end

   def directories
     output = []

     object.directory_entries.each do |item|
         output << resolve_reference(item)
     end

     return nil if output.empty?
     return output
   end
end
