module ApplicationHelper
  def a_or_an(word)
    return "" if word.blank?

    word = word.to_s.downcase
    vowels = %w[a e i o u]

    # Special cases where "h" is silent
    silent_h_words = %w[hour honest honor heir]

    if silent_h_words.include?(word) || vowels.include?(word[0])
      "an"
    else
      "a"
    end
  end
end
