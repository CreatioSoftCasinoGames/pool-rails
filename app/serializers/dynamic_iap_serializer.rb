class DynamicIapSerializer < ActiveModel::Serializer
  attributes :id, :iap_id, :old_value, :new_value, :offer, :name
end
