class ClubSerializer < ActiveModel::Serializer
  attributes :id, :name, :entry_fees, :winner_amount
end
