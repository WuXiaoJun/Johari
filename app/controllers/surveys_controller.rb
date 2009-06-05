class SurveysController < ApplicationController
  before_filter :get_user 
  skip_filter :get_user, :only=>[:latestsurvey]
  

  # GET /surveys
  # GET /surveys.xml
  def index
    @surveys = Survey.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  # GET /surveys/1
  # GET /surveys/1.xml
  def show
    @survey = Survey.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/new
  # GET /surveys/new.xml
  def new
    @survey = Survey.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @survey = Survey.find(params[:id])
  end

  # POST /surveys
  # POST /surveys.xml
  def create
    @survey = @user.surveys.build(params[:survey])
    @survey.content = params[:content]
    
    if params[:self_flag] == "T"
      @user.count_survey_self(params[:content])
    else
      @user.count_survey(params[:content])
    end
    respond_to do |format|
      if @survey.save and @user.save
        flash[:notice] = 'Survey was successfully created.'
        format.html { redirect_to @user }
        format.xml  { render :xml => @survey, :status => :created, :location => @survey }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.xml
  def update
    @survey = Survey.find(params[:id])

    respond_to do |format|
      if @survey.update_attributes(params[:survey])
        flash[:notice] = 'Survey was successfully updated.'
        format.html { redirect_to(@survey) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to(surveys_url) }
      format.xml  { head :ok }
    end
  end
  
  def latestsurvey
	@survey = Survey.find(:last)
	render(:layout => false)
  end
  
  private

  def get_user
    @user = User.find(params[:user_id] || params[:id])
  end
  

  
end
