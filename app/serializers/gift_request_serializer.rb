class GiftRequestSerializer < ActiveModel::Serializer
	attributes :id, 
	           :user_login_token, 
	           :send_to_token, 
	           :gift_type, 
	           :gift_value, 
	           :is_asked, 
	           :confirmed, 
	           :full_name, 
	           :image_url
end