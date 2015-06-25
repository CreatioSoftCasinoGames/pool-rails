class FriendshipSerializer < ActiveModel::Serializer
	attributes :friend_token,
	           :full_name, 
	           :device_avtar_id,
	           :image_url,
	           :login_token, 
	           :online
end