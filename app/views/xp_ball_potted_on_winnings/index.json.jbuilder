json.array!(@xp_ball_potted_on_winnings) do |xp_ball_potted_on_winning|
  json.extract! xp_ball_potted_on_winning, :id, :room_type, :oneball, :twoball, :threeball, :fourball, :fiveball, :sixball, :sevenball
  json.url xp_ball_potted_on_winning_url(xp_ball_potted_on_winning, format: :json)
end
