class GameRequestSerializer < ActiveModel::Serializer
	attributes :requested_from,
	           :requested_to,
	           :invitation_type,
	           :accepted
	           	           
end