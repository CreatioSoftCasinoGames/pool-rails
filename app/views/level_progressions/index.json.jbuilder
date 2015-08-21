json.array!(@level_progressions) do |level_progression|
  json.extract! level_progression, :id, :level, :xp_required_to_clear, :factor_of_increase, :award, :cue_unlocked, :rank
  json.url level_progression_url(level_progression, format: :json)
end
