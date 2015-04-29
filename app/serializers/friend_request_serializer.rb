class FriendRequestSerializer < ActiveModel::Serializer
  attributes :user_login_token, :requested_to_token, :confirmed
end
