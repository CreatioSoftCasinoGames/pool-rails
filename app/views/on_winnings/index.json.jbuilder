json.array!(@on_winnings) do |on_winning|
  json.extract! on_winning, :id, :1ball, :2ball, :3ball, :4ball, :5ball, :6ball, :7ball
  json.url on_winning_url(on_winning, format: :json)
end
