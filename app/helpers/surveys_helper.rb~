module SurveysHelper
  
  def charaters_format(characters)
    tempArray = []
    sortCharacters = characters.sort_by {|u| u.character}
    sortCharacters.each() do |character|
      tempArray << character_str(character.character) 
    end
    tempArray.join(",")
  end
  
  def character_str(character_id)
    Survey::CHARACTER_MAP[character_id] || character_id.to_s
  end
  
  def charater_count(charaHash, character_id)
    charaHash[character_id].length
  end
  
  def character_submits(charaHash, character_id)
    votes = []
    charaHash[character_id].each() do |vote|
      votes << (vote.votername || "匿名用户")
    end
    votes.join(",")
  end
  
  def character_pesent(charaHash, character_id)
    votesnum = @votes.length
    (charaHash[character_id].length/votesnum)*100
  end
  
  def characters_select_box()
    htmlText = ""
    (1..55).each do |character_id|
      htmlText = htmlText + "<tr>" if character_id%5 == 1
        htmlText = htmlText + "<td onClick=\"javascript:boxclick(this,#{character_id.to_s})\">#{Survey::CHARACTER_MAP[character_id]}</td>"
      htmlText = htmlText + "</tr>" if character_id%5 == 0
    end
    htmlText
  end
  
   
end
