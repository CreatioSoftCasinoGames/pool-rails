json.array!(@club_configs) do |club_config|
  json.extract! club_config, :id, :name, :room_type, :entry_fees, :winner_amount
  json.url club_config_url(club_config, format: :json)
end
