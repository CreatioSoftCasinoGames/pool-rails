class GameSerializer < ActiveModel::Serializer
	attributes :winner_id,
	           :looser_id,
	           :club_config_id,
	           :full_name,
	           :device_avatar_id
	           
end