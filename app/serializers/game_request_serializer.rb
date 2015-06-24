class GameRequestSerializer < ActiveModel::Serializer
	attributes :id,
						 :user_login_token,
	           :requested_token,
	           :invitation_type,
	           :accepted,
	           :full_name,
	           :image_url
	           	           
end