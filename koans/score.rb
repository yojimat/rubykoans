def score(dice)
  # You need to write this method
  arrayQntd = [0, 0, 0, 0, 0, 0]
  points = 0
  dice.each do |value|
    points += 100 if value == 1
    points += 50 if value == 5
    arrayQntd[value - 1] = 1 + arrayQntd[value - 1]
  end

  arrayQntd.each_with_index do |value, index|
    next unless value >= 3

    case index
    when 0
      points -= 300
      points += 1000
    when 4
      points -= 150
      points += 500
    else
      points += (index + 1) * 100
    end
  end
  points
end

print score([1, 1, 1]) # 300
