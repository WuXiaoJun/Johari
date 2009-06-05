class User < ActiveRecord::Base
   SURVEY_RESULT_INIT_VALUE = "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0" 
  
  has_many :surveys
  
  def initialise(params = nil)  super 
    self.survey_result ||= User::SURVEY_RESULT_INIT_VALUE
    self.survey_result_self ||= User::SURVEY_RESULT_INIT_VALUE
  end 
  
  def count_survey(survey_content)
    #init survey_result_array
    survey_result_array = []
    if self.survey_result == nil
      (1..55).each do |i|
        survey_result_array << "0"
      end
    else 
      survey_result_array = survey_result.split(",")
    end
    
    #reset the survey_result
    self.survey_result = count_survey_array(survey_result_array, survey_content).join(",")
    
  end
  
  def count_survey_self(survey_content)
    #init survey_result_array
    survey_result_array = []
    
	(1..55).each do |i|
		survey_result_array << "0"
	end
    
    #reset the survey_result
    self.survey_result_self = count_survey_array(survey_result_array, survey_content).join(",")
    
  end
  
  def isInit
	return self.survey_result_self != SURVEY_RESULT_INIT_VALUE 
  end
  
  private
  
  def count_survey_array(survey_result_array, survey_content)
    
    #add survey_conent to survey_result_array
    survey_content.split(",").each do |item|
      index = item.to_i
      survey_result_array[index] = (survey_result_array[index].to_i + 1).to_s
    end
    survey_result_array
  end
  

  
end
