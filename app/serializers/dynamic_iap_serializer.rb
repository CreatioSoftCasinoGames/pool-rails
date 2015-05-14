class DynamicIapSerializer < ActiveModel::Serializer
  attributes :id, :iap_id, :old_coins_value, :new_coins_value, :old_pricing, :new_pricing, :offer, :currency, :country
end
