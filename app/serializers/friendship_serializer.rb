class FriendshipSerializer < ActiveModel::Serializer
	attributes :friend_token,
	           :full_name, 
	           :device_avtar_id, 
	           :online
end