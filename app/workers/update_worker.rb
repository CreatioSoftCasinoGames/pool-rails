class UpdateWorker
	include Sidekiq::Worker

	sidekiq_options retry: false

	def perform(data)
		profile_data = JSON.parse(data)
		p profile_data
		k = profile_data["id"]
		user = User.fetch_by_login_token(profile_data["id"])


		if (profile_data["data"]["win_streak"]	&& profile_data["data"]["total_coins_won"] && profile_data["data"]["win_percentage"] && profile_data["data"]["won_count"] && profile_data["data"]["xp"] && profile_data["data"]["current_coins_balance"])
			user.update_attributes(win_streak: profile_data["data"]["win_streak"], total_coins_won: profile_data["data"]["total_coins_won"], win_percentage: profile_data["data"]["win_percentage"], won_count: profile_data["data"]["won_count"], xp: profile_data["data"]["xp"], current_coins_balance: profile_data["data"]["current_coins_balance"])
		
		elsif (profile_data["data"]["ball_potted"] && profile_data["data"]["strike_count"] && profile_data["data"]["accuracy"])
			user.update_attributes(ball_potted: profile_data["data"]["ball_potted"], strike_count: profile_data["data"]["strike_count"], accuracy: profile_data["data"]["accuracy"])
    p profile_data
		elsif (profile_data["data"]["total_coins_won"] && profile_data["data"]["current_coins_balance"])
			user.update_attributes(total_coins_won: profile_data["data"]["total_coins_won"], current_coins_balance: profile_data["data"]["current_coins_balance"])
		
		elsif profile_data["data"]["total_coins_won"]
			user.update_attributes(total_coins_won: profile_data["data"]["total_coins_won"])

		elsif profile_data["data"]["total_games_played"]
			user.update_attributes(total_games_played: profile_data["data"]["total_games_played"])

		elsif profile_data["data"]["current_coins_balance"]
			user.update_attributes(current_coins_balance: profile_data["data"]["current_coins_balance"])

		elsif profile_data["data"]["rank"]
		  user.update_attributes(rank: profile_data["data"]["rank"])

		elsif profile_data["data"]["total_time_in_game"]
			user.update_attributes(total_time_in_game: profile_data["data"]["total_time_in_game"])

		elsif profile_data["data"]["current_level"]
			user.update_attributes(current_level: profile_data["data"]["current_level"])

		elsif profile_data["data"]["flag"]
			user.update_attributes(flag: profile_data["data"]["flag"])

		elsif profile_data["data"]["country"]
			user.update_attributes(country: profile_data["data"]["country"])	

		else profile_data["data"]["device_avtar_id"]
			user.update_attributes(device_avtar_id: profile_data["data"]["device_avtar_id"])		

		end
		
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
