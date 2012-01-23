class QuestionsController < ApplicationController
  
  before_filter :admin_signed_in
  before_filter :get_question_by_id, :only => [:show, :edit, :update, :destroy]
  
  def index
    unless(params[:text].blank?)
      #### search on question body using ajax ####
      @questions = Question.where("body like ?", '%'+params[:text]+'%').paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => 5
    else
      @questions = Question.paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => 5
    end
  end


  def show
    
  end


  def new
    @question = Question.new(:type => 'MultipleChoice')
    @type = @question.type
  end


  def edit
    @type = @question.type
  end


  def create
    @question = Question.new(params[:question])
    @question.tag_list = params[:as_values_tags]
    
    if @question.save
      redirect_to(@question, :notice => 'Question was successfully created.')
    else
      @type = params[:question][:type] 
      render :action => "new"
    end
  end
    
    
  def update
    @question.tag_list = params[:as_values_tags]
    
    if @question.update_attributes(params[:question])
      redirect_to(@question, :notice => 'Question was successfully updated.') 
    else
      @type = params[:question][:type]
      render :action => "edit" 
    end
  end


  def destroy
    @question.destroy
    redirect_to(questions_url) 
  end
  

  def tags_index
    @questions = Question.tagged_with(params[:name]).paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end
  

  def level_index
    @questions = Question.where("level = ?", params[:id]).paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end
  
  def category_index
    @questions = Question.where("category_id = ?", params[:id]).paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end

  def make_test
    
  end
  

  def show_fetch_ques
    @question = Question.find(params[:id])
    render :partial => "show_fetch_ques"
  end
  
  
  def fetch_questions
    @questions = Question.search(params[:as_values_tags], params[:type], params[:category_id], params[:level])
  end
  
  
  def change_answer_div
    unless params[:id].blank?
      @question = Question.where(:id => params[:id]).includes(:options).first
    else
      @question = Question.new
    end
  end
  

  def ques_tags
    data = Question.question_tags(params[:q])
		respond_to do |format|			
			format.html{}
			format.js{
				render :json => data
			}			
		end
  end
  

  def download
    name = params[:test_name]
    
    unless FileTest.exists?(Rails.root.to_s + ZIP_FILE_PATH + name +'.zip')
      Question.download(name)
      send_file Rails.root.to_s + ZIP_FILE_PATH + name + '.zip', :type => "application/zip"
    else
      send_file Rails.root.to_s + ZIP_FILE_PATH + name+ '.zip', :type => "application/zip"
    end
  end

  private
  
  def get_question_by_id
    @question = Question.where(:id => params[:id]).first
  end
  
end
