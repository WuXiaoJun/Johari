# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	ENABLE_XIAONEI = true
	def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
		from_time = from_time.to_time if from_time.respond_to?(:to_time)
		to_time = to_time.to_time if to_time.respond_to?(:to_time)
		distance_in_minutes = (((to_time - from_time).abs)/60).round
		distance_in_seconds = ((to_time - from_time).abs).round

		case distance_in_minutes
			when 0..1
				return (distance_in_minutes == 0) ? '不到 1 分钟' : '1 分钟' unless include_seconds
			case distance_in_seconds
				when 0..4   then '5 秒'
				when 5..9   then '10 秒'
				when 10..19 then '20 秒'
				when 20..39 then '半分钟'
				when 40..59 then '1 分钟'
				else             '1 分钟'
			end
			
			when 2..44           then "#{distance_in_minutes} 分钟"
			when 45..89          then '1 小时'
			when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round} 小时"
			when 1440..2879      then '1 天'
			when 2880..43199     then "#{(distance_in_minutes / 1440).round} 天"
			when 43200..86399    then '1 个月'
			when 86400..525599   then "#{(distance_in_minutes / 43200).round} 个月"
			when 525600..1051199 then '1 年'
		else                      "#{(distance_in_minutes / 525600).round} 年"
	   end
	end

	def xn_user_name(uid)
		return "no" if ENABLE_XIAONEI == false
		#http://api.xiaonei.com/restserver.do
		url ='api.xiaonei.com'
		action = '/restserver.do'
		params = ['api_key=5c7fdbfc4b1a46d19cd1636223b963f1']
		params << 'method=xiaonei.users.getInfo'
		params << 'v=1.0'
		params << ('session_key='+CGI::escape(@sig_session_key))
		params << ('uids='+uid.to_s)
		params << ('fields=name')
		#logger.error("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
		#logger.error(params.join("&"))
		text = ""
		Net::HTTP.start( url , 80 ) {|http|
		  response = http.post( action ,  params.join("&") )
		  text = response.body
		  logger.error(text)
		}
		doc = Document.new text
		username = ""
		doc.elements.each("users_getInfo_response/user/name") { |element|
		   #logger.error ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		   #logger.error(element.text)
		   username = element.text
		}
		return username
	end
end
