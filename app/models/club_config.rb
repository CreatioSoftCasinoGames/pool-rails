class ClubConfig < ActiveRecord::Base
	has_many :clubs

	validates :name, :entry_fees, :winner_amount, :club_type, :rule_id , :winner_xp, :looser_xp, :presence => true
	validates_format_of :name, with:  /\A[a-zA-Z 0-9]+\z/ , on: :create
	validates :entry_fees, :winner_amount, :rule_id, :winner_xp, :looser_xp, numericality: true

end
