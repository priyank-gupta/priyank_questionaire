class QuestionsController < ApplicationController
  

  before_filter :find_question, :only => [:show, :edit, :update, :destroy]
  
  before_filter :admin_signed_in
  
  ## Thinking sphinx on body??
  def index
    if(params[:text].present?)
      #### search on question body using ajax ####
      @questions = Question.where("body like ?", '%'+params[:text]+'%').paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => PER_PAGE
    elsif(params[:type])
      @questions = params[:type].constantize.paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => PER_PAGE
    else
      @questions = Question.paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => PER_PAGE
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
    @questions = Question.tagged_with(params[:tag_name]).paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => PER_PAGE
  end
  
  def level_index
    flash[:notice] = "No Question found for this level!" and redirect_to :root unless LEVEL.any? {|l| l[1] == params[:level_id].to_i }
    @questions = Question.where("level = ?", params[:level_id]).paginate :include => :category, :page => params[:page], :order => 'updated_at DESC', :per_page => PER_PAGE
  end
  
  def category_index
    @category = Category.where(:id => params[:category_id]).first
    unless @category
      flash[:notice] = "No Question found for this category!" 
      return redirect_to :root 
    end  
    @questions = @category.questions.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => PER_PAGE
  end


  def make_test
    
  end
  

  def show_fetch_ques
    @question = Question.where(:id => params[:id]).first
    render :partial => "fetch_ques"
  end
  
  
  def fetch_questions
    @questions = Question.search_query(params[:as_values_tags], params[:type], params[:category_id], params[:level])
  end
  
  
  def change_answer_div
    params[:id].blank? ? @question = Question.new : @question = Question.where(:id => params[:id]).includes(:options).first
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
    end
    
    send_file Rails.root.to_s + ZIP_FILE_PATH + name + '.zip', :type => "application/zip"
  end

  private
  
  def find_question
    flash[:notice] = "Question not found." and redirect_to :root unless @question = Question.where(:id => params[:id]).first
  end
  
end
