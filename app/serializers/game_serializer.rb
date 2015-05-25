class GameSerializer < ActiveModel::Serializer
	attributes :login_token,
	           :full_name,
	           :device_avatar_id,
	           :image_url

	           
end