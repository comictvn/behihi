
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
      badge_level = BADGE_LEVELS.find { |_level, range| range.include?(score) }&.first
      badge_level || determine_custom_badge_level
    end

    private

    # Define a method to determine custom badge levels for future extensions
    def determine_custom_badge_level
      # Placeholder for custom logic to determine new badge levels
      # This method can be overridden or extended in the future without changing the existing code structure
      nil
    end
  end
end
