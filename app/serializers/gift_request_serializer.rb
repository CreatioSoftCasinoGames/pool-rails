class GiftRequestSerializer < ActiveModel::Serializer
	attributes :id, 
	           :user_login_token, 
	           :send_to_token, 
	           :gift_type, 
	           :gift_value, 
	           :is_asked, 
	           :confirmed, 
	           :full_name,
	           :device_avatar_id, 
	           :image_url,
	           :sender_unique_id,
	           :receiver_unique_id
end