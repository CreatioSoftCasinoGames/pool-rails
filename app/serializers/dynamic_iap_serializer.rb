class DynamicIapSerializer < ActiveModel::Serializer
  attributes :id, :iap_id, :old_value, :new_value, :offer, :name, :currency, :country, 
    :created_at, :updated_at, :iap_type, :is_active, :old_pricing, :new_pricing, 
    :deal_value, :more, :end_time  
end
