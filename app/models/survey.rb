class Survey < ActiveRecord::Base
  
  belongs_to :user
  
  def content_str
    character_ids = content
    logger.info @content
    logger.info CHARACTER_MAP
    
    return "" if character_ids == nil
    charecters = character_ids.split(",")
    character_strs = []
    charecters.each do |c|
      character_strs << CHARACTER_MAP[c.to_i]
    end
    character_strs.join(", ")
  end
  
  CHARACTER_MAP = {
    1=>"有才干的",
    2=>"随和",
    3=>"适应性强",
    4=>"大胆",
    5=>"勇敢",
    6=>"平和",
    7=>"有同情心",
    8=>"积极",
    9=>"机灵",
    10=>"复杂",
    11=>"自信",
    12=>"可靠的",
    13=>"令人尊敬",
    14=>"精力充沛",
    15=>"外向",
    16=>"友好的",
    17=>"慷慨",
    18=>"愉快的",
    19=>"乐于助人",
    20=>"理想化的",
    21=>"独立自主",
    22=>"足智多谋",
    23=>"深思熟虑",
    24=>"内向",
    25=>"善良",
    26=>"博学",
    27=>"理智",
    28=>"有爱心",
    29=>"成熟",
    30=>"谦虚",
    31=>"焦虑不安",
    32=>"敏锐",
    33=>"有条理",
    34=>"耐心",
    35=>"强权",
    36=>"骄傲",
    37=>"安静",
    38=>"深沉",
    39=>"无拘无束",
    40=>"虔诚",
    41=>"反应迅速",
    42=>"有洞察力",
    43=>"自作主张",
    44=>"有自我意识",
    45=>"敏感",
    46=>"感情脆弱",
    47=>"害羞",
    48=>"愚笨",
    49=>"冲动",
    50=>"有同情心",
    51=>"神经紧张",
    52=>"可信赖",
    53=>"待人温和",
    54=>"聪明",
    55=>"诙谐"
  }
end
