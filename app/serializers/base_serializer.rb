class BaseSerializer < ActiveModel::Serializer
  def resolve_reference attribute_object
    customized_object = {}

    unless attribute_object.nil?
      resource = ActiveModelSerializers::SerializableResource.new(attribute_object)
      customized_object = resource.as_json
    end

    return customized_object unless customized_object.empty?
    nil
  end
end
