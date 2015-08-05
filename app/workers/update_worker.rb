class UpdateWorker
	include Sidekiq::Worker

	sidekiq_options retry: false

	def perform(data)
		profile_data = JSON.parse(data)
		k = profile_data["id"]
		user = User.fetch_by_login_token(profile_data["id"])

		total_ball_potted = user.ball_potted
		total_strike_count = user.strike_count
		if profile_data["data"]["ball_potted"]
			total_ball_potted = user.ball_potted + profile_data["data"]["ball_potted"]
			total_strike_count = user.strike_count + profile_data["data"]["strike_count"]
			user.update_attributes(ball_potted: total_ball_potted)
		end
		if profile_data["data"]["strike_count"]
			total_strike_count = user.strike_count + profile_data["data"]["strike_count"]
			user.update_attributes(strike_count: total_strike_count)
		end
		accuracy = (total_ball_potted.to_f/total_strike_count.to_f)*100
		user.update_attributes(accuracy: accuracy)
		if profile_data["data"]["xp"]
			total_xp = user.xp + profile_data["data"]["xp"]
			user.update_attributes(xp: profile_data["data"]["xp"])
		end
		if profile_data["data"]["win_streak"]
			total_win_streak = user.win_streak + profile_data["data"]["win_streak"]
			user.update_attributes(win_streak: profile_data["data"]["win_streak"])
		end
		if profile_data["data"]["award"]
			total_coin = user.total_coins_won + profile_data["data"]["award"].to_i
			current_coin = user.current_coins_balance + profile_data["data"]["award"].to_i
			user.update_attributes(total_coins_won: total_coin, current_coins_balance: current_coin)
		end
		total_win = user.won_count
		total_play = user.total_games_played
		if profile_data["data"]["win"]
			total_win = user.won_count + profile_data["data"]["win"]
			user.update_attributes(won_count: total_win)
		end
		if profile_data["data"]["game_played"]
			total_play = user.total_games_played + profile_data["data"]["game_played"]
			user.update_attributes(total_games_played: total_play)
		end
		if total_play.to_f > 0
			user.update_attributes(win_percentage: (total_win.to_f/total_play.to_f)*100)
		else
			user.update_attributes(win_percentage: 0)
		end

		if profile_data["data"]["deduce_amount"]
			current_coin = user.current_coins_balance - profile_data["data"]["deduce_amount"]
			user.update_attributes(current_coins_balance: current_coin)
		end
		
	end

end

