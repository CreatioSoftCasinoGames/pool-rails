class FriendRequestSerializer < ActiveModel::Serializer
	attributes :id,
	           :user_login_token,
	           :requested_to_token,
             :confirmed,
             :image_url

end