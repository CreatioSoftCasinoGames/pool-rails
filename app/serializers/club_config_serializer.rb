class ClubConfigSerializer < ActiveModel::Serializer
  attributes :id, 
             :name, 
             :entry_fees, 
             :winner_amount,
             :bonus_amount,
             :guideline_status, 
             :rule_id, 
             :active, 
             :winner_xp, 
             :looser_xp, 
             :club_type
end
