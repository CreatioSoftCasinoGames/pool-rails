json.array!(@dynamic_iaps) do |dynamic_iap|
  json.extract! dynamic_iap, :id, :iap_id, :old_coins_value, :new_coins_value, :old_pricing, :new_pricing, :offer, :currency, :country
  json.url dynamic_iap_url(dynamic_iap, format: :json)
end
