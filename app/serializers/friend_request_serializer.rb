class FriendRequestSerializer < ActiveModel::Serializer
	attributes :id,
						 :login_token, 
						 :requested_to_token, 
						 :confirmed,
						 :full_name,
						 :image_url
end