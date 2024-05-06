
module TestResultService
  class DetermineBadgeLevel
    # Define the badge levels based on score ranges
    BADGE_LEVELS = {
      'bronze' => 0..59,
      'silver' => 60..79,
      'gold' => 80..89,
      'platinum' => 90..100
    }.freeze

    attr_reader :score

    def initialize(score)
      @score = score
    end

    def call
      # Find the badge level that matches the score range
      BADGE_LEVELS.find { |_level, range| range.include?(score) }&.first
    end
  end
end
