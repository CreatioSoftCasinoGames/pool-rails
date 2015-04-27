class FriendRequestSerializer < ActiveModel::Serializer
  attributes :id, :requested_to_id, :confirmed
  has_one :user
end
