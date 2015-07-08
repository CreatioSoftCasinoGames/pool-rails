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
		win_percentage = (total_win.to_f/total_play.to_f)*100
		user.update_attributes(win_percentage: win_percentage)
		if profile_data["data"]["deduce_amount"]
			current_coin = user.current_coins_balance - profile_data["data"]["deduce_amount"]
			user.update_attributes(current_coins_balance: current_coin)
		end
		# if profile_data["data"]["accuracy"]
			


		
		# if profile_data["data"]["current_coins_balance"] && profile_data["data"]["total_games_played"]
		# 	user.update_attributes(current_coins_balance: profile_data["data"]["current_coins_balance"], total_games_played: profile_data["data"]["total_games_played"])
		# elsif profile_data["data"]["ball_potted"] && profile_data["data"]["strike_count"] && profile_data["data"]["accuracy"] 
		# 	user.update_attributes(ball_potted: profile_data["data"]["ball_potted"], strike_count: profile_data["data"]["strike_count"], accuracy: profile_data["data"]["accuracy"])
		# elsif profile_data["data"]["win_streak"]	&& profile_data["data"]["total_coins_won"] && profile_data["data"]["win_percentage"] && profile_data["data"]["won_count"] && profile_data["data"]["xp"] && profile_data["data"]["current_coins_balance"]
		# 	user.update_attributes(win_streak: profile_data["data"]["win_streak"], total_coins_won: profile_data["data"]["total_coins_won"], win_percentage: profile_data["data"]["win_percentage"], won_count: profile_data["data"]["won_count"], xp: profile_data["data"]["xp"], current_coins_balance: profile_data["data"]["current_coins_balance"])
		# elsif profile_data["data"]["ball_potted"] && profile_data["data"]["strike_count"] && profile_data["data"]["accuracy"]
		# 	user.update_attributes(ball_potted: profile_data["data"]["ball_potted"], strike_count: profile_data["data"]["strike_count"], accuracy: profile_data["data"]["accuracy"])
		# elsif profile_data["data"]["total_coins_won"] && profile_data["data"]["current_coins_balance"]
		# 	user.update_attributes(total_coins_won: profile_data["data"]["total_coins_won"], current_coins_balance: profile_data["data"]["current_coins_balance"])
		
		# elsif profile_data["data"]["total_coins_won"]
		# 	user.update_attributes(total_coins_won: profile_data["data"]["total_coins_won"])

		# elsif profile_data["data"]["device_avatar_id"]
		# 	user.update_attributes(device_avatar_id: profile_data["data"]["device_avatar_id"])		

		# elsif profile_data["data"]["total_games_played"]
		# 	user.update_attributes(total_games_played: profile_data["data"]["total_games_played"])

		# elsif profile_data["data"]["current_coins_balance"]
		# 	user.update_attributes(current_coins_balance: profile_data["data"]["current_coins_balance"])

		# elsif profile_data["data"]["rank"]
		#   user.update_attributes(rank: profile_data["data"]["rank"])

		# elsif profile_data["data"]["total_time_in_game"]
		# 	user.update_attributes(total_time_in_game: profile_data["data"]["total_time_in_game"])

		# elsif profile_data["data"]["current_level"]
		# 	user.update_attributes(current_level: profile_data["data"]["current_level"])

		# elsif profile_data["data"]["flag"]
		# 	user.update_attributes(flag: profile_data["data"]["flag"])
		# elsif profile_data["data"]["country"]
		# 	user.update_attributes(country: profile_data["data"]["country"])	
		# end
		
	end

end




		# if profile_data["data"]["ball_potted"]
		# 	user.update_attributes(ball_potted: profile_data["data"]["ball_potted"])

		# elsif profile_data["data"]["total_coins_won"]
		# 	user.update_attributes(total_coins_won: profile_data["data"]["total_coins_won"])

		# elsif profile_data["data"]["accuracy"]
		# 	user.update_attributes(accuracy:profile_data["data"]["accuracy"])

		# elsif profile_data["data"]["win_percentage"]
		# 	user.update_attributes(win_percentage: profile_data["data"]["win_percentage"])
    
		# elsif profile_data["data"]["won_count"]
		# 	user.update_attributes(won_count: profile_data["data"]["won_count"])

		# elsif profile_data["data"]["xp"]
		# 	user.update_attributes(xp: profile_data["data"]["xp"])


		# elsif profile_data["data"]["win_streak"]
		# 	user.update_attributes(win_streak: profile_data["data"]["win_streak"])
