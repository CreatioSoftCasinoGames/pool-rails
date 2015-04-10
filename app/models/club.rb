class Club < ActiveRecord::Base
	belongs_to :club_config
	before_save :set_name

	private

	def set_name
		count = (club_config.clubs.last.name.split(" ").last.to_i rescue 0)
		self.name = "#{club_config.try(:name)} #{count+1}"
		self.entry_fees = club_config.entry_fees
		self.winner_amount = club_config.winner_amount
	end

end
