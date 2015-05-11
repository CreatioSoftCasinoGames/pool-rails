class FriendRequestSerializer < ActiveModel::Serializer
	attributes :id, :requested_to_id, :confirmed
	attributes :user_login_token, :requested_to_token, :confirmed

end


