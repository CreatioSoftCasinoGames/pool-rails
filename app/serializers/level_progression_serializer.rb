class LevelProgressionSerializer < ActiveModel::Serializer
  attributes :id, :level, :xp_required_to_clear, :factor_of_increase, :award, :cue_unlocked, :rank
end
