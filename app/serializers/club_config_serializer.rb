class ClubConfigSerializer < ActiveModel::Serializer
  attributes :id, :name, :entry_fees, :winner_amount, :rule_id, :active, :winner_xp, :looser_xp
end
