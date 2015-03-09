json.array!(@clubs) do |club|
  json.extract! club, :id, :name, :entry_fees, :winner_amount
  json.url club_url(club, format: :json)
end
