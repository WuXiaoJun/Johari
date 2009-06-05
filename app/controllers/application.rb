# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require "rexml/document"
require 'net/http'
require "cgi"
include REXML

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '155e37e47adc737193d4aeb9984dea26'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  ENABLE_XIAONEI = true
  before_filter :setup
  
  
  protected
  
  def setup
	logger.info "$$$$$$$$$$$$$$$$$$$$$$" + ENABLE_XIAONEI.to_s

	if ENABLE_XIAONEI == true
		session[:xn_sig_user] = params[:xn_sig_user]  if params[:xn_sig_user] != nil
		session[:xn_sig_session_key] = params[:xn_sig_session_key] if params[:xn_sig_session_key] != nil
		#session[:xn_user_friends] = nil
	else
		session[:xn_sig_user] ||= 123
		session[:xn_sig_session_key] ||= 123
	end
	@sig_user = session[:xn_sig_user].to_s
	@sig_session_key = session[:xn_sig_session_key].to_s
	if params[:xn_sig_user] != nil and params[:xn_sig_user] != ""
		session[:xn_user_friends] = getUserFriends()
		logger.error("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
	end
	@friends = session[:xn_user_friends]
	logger.error ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%%%%%%%%%%%%%%")
	logger.error(@friends)
    
  end
  
  def getUserName(user_id)
    logger.info "$$$$$$$$$$$$$$$$$$$$$$" + ENABLE_XIAONEI
    return "no" if ENABLE_XIAONEI == false
    #http://api.xiaonei.com/restserver.do
    url ='api.xiaonei.com'
    action = '/restserver.do'
    params = ['api_key=5c7fdbfc4b1a46d19cd1636223b963f1']
    params << 'method=xiaonei.users.getInfo'
    params << 'v=1.0'
    params << ('session_key='+CGI::escape(@sig_session_key))
    params << ('uids='+user_id)
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
  
  def getUserFriends()
	friends = []
    if  ENABLE_XIAONEI == false
		friends << getUserInfo("111")
	else
		#http://api.xiaonei.com/restserver.do
		url ='api.xiaonei.com'
		action = '/restserver.do'
		params = ['api_key=5c7fdbfc4b1a46d19cd1636223b963f1']
		params << 'method=xiaonei.friends.getAppUsers'
		params << 'v=1.0'
		params << ('session_key='+ CGI::escape(@sig_session_key.to_s))
		logger.error("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
		logger.error(params.join("&"))
		text = ""
		Net::HTTP.start( url , 80 ) {|http|
		  response = http.post( action ,  params.join("&") )
		  text = response.body
		  logger.error(text)
		}
		doc = Document.new text
		doc.elements.each("friends_getAppUsers_response/uid") { |element|
		   logger.error ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		   logger.error(element.text)
		   friends << getUserInfo(element.text)
		}
	end
    return friends  
  end
  
  def getUserInfo(user_id)
	userinfo = {}
	if  ENABLE_XIAONEI == false
		userinfo[:uid] = "test"
		userinfo[:name] = "testname"
		userinfo[:tinyurl] = "/images/icon.jpg"
	else
		#http://api.xiaonei.com/restserver.do
		url ='api.xiaonei.com'
		action = '/restserver.do'
		params = ['api_key=5c7fdbfc4b1a46d19cd1636223b963f1']
		params << 'method=xiaonei.users.getInfo'
		params << 'v=1.0'
		params << ('session_key=' + CGI::escape(@sig_session_key))
		params << ('uids=' + user_id)
		params << ('fields=name,tinyurl')
		#logger.error("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
		#logger.error(params.join("&"))
		text = ""
		Net::HTTP.start( url , 80 ) {|http|
		  response = http.post( action ,  params.join("&") )
		  text = response.body
		  logger.error(text)
		}
		doc = Document.new text
		doc.elements.each("users_getInfo_response/user") { |element|
		   #logger.error ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
		   #logger.error(element.text)
		   userinfo[:uid] = user_id
		   userinfo[:name] = element.elements["name"][0].to_s
		   userinfo[:tinyurl] = element.elements["tinyurl"][0].to_s
		}
	end
    return userinfo
  end
  
  def sendFeedMessage(feedid,titledata, bodydata)
    return if  ENABLE_XIAONEI== false
    logger.error('!!!!!!!!!!!!!创建成功!!!!!!!!!!!!!!!.1')
    params = []
    params << 'method=xiaonei.feed.publishTemplatizedAction'
    params << ('template_id=' + feedid.to_s)
    params << ('title_data=' + CGI::escape(titledata))
    params << ('body_data=' + CGI::escape(bodydata))
    doc = callXiaoNeiAPI(params)
    logger.error('!!!!!!!!!!!!!创建成功!!!!!!!!!!!!!!!.2')
    doc.elements.each("feed_publishTemplatizedAction_response") { |element|
      logger.error("!!!!!!!!!!!!!" + element.text) 
    }
  end
  
  def callXiaoNeiAPI(params)
    return nil if  ENABLE_XIAONEI == false
    logger.error('!!!!!!!!!!!!!创建成功!!!!!!!!!!!!!!!.3')
    params << 'api_key=5c7fdbfc4b1a46d19cd1636223b963f1'
    params << ('session_key='+CGI::escape(@sig_session_key))
    params << 'v=1.0'
    
    url ='api.xiaonei.com'
    action = '/restserver.do'
    text = ""
    Net::HTTP.start( url , 80 ) {|http|
      response = http.post( action ,  params.join("&") )
      text = response.body
      logger.error("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
      logger.error(params.join("&"))
      logger.error(text)
    }
    doc = Document.new text
    logger.error('!!!!!!!!!!!!!创建成功!!!!!!!!!!!!!!!4.')
    return doc
  end
end
