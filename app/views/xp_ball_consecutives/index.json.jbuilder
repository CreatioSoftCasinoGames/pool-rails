json.array!(@xp_ball_consecutives) do |xp_ball_consecutive|
  json.extract! xp_ball_consecutive, :id, :room_type, :twoball, :threeball, :fourball, :fiveball, :sixball, :sevenball
  json.url xp_ball_consecutive_url(xp_ball_consecutive, format: :json)
end
