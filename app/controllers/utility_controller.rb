class UtilityController < ApplicationController
	def show_api_key
		@api_key = ApiKey.where(active: true).first
	end

	def generate_api_key 
		ApiKey.create
		redirect_to show_api_key_url, flash: {success: "New keys created successfully !"}
	end

	def sync_data
		ClubConfig.includes(:clubs).all.each do |club_config|	
		if (club_config.club_type == "OneToOne")
		  REDIS_CLIENT.SADD("onetoone_room_players", "onlinePlayer:#{club_config.id}")
		else
		  REDIS_CLIENT.SADD("tournament_room_players", "onlinePlayer:#{club_config.id}")
		end

		# REDIS_CLIENT.SADD("club_config_players", "club_config_player:#{club_config.id}")
		REDIS_CLIENT.SADD("club_configs", "club_config:#{club_config.id}")
			REDIS_CLIENT.HMSET("club_config:#{club_config.id}", "name", club_config.name, "club_type", club_config.club_type, "winner_amount", club_config.winner_amount, "winner_xp", club_config.winner_xp, "looser_xp", club_config.looser_xp, "entry_fees", club_config.entry_fees);		
			club_config.clubs.each do |club|
			  @club_type =  ClubConfig.where(id: Club.where(id: club.id).pluck(:club_config_id)).pluck(:club_type)
			  @club_type = @club_type[0];
				REDIS_CLIENT.SADD("clubs","club:#{club.id}")
				REDIS_CLIENT.SADD("club_config_clubs:#{club.club_config_id}", "club:#{club.id}")
				REDIS_CLIENT.ZADD("club_config_occupancy:#{club.club_config_id}", 0, "club:#{club.id}")
				REDIS_CLIENT.HMSET("club:#{club.id}", "name", club.name, "club_config_id", club.club_config_id, "entry_fees",  club.entry_fees, "club_type", @club_type, "winner_amount", club.winner_amount)
			end
		end
		User.where(is_dummy: true).each do |bot_player|
			p bot_player
			REDIS_CLIENT.SADD("available_bots", bot_player.login_token)
		end
		REDIS_CLIENT.DEL("busy_bots")
		redirect_to root_path, flash: {success: "Data successfully synced !" }
	end

	def flush_data
		REDIS_CLIENT.FLUSHALL()
		redirect_to root_path, flash: {success: "Data successfully deleted, Please sync !" }
	end
end

