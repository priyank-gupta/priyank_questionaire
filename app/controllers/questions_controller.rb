class QuestionsController < ApplicationController
  
  before_filter :admin_signed_in
  before_filter :get_question_by_id, :only => [:show, :edit, :update, :destroy]
  
  def index
    ## use .blank?
    unless(params[:text].nil? || params[:text].empty? )
      @questions = Question.where("body like '%#{params[:text]}%'").paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
    else
      @questions = Question.paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
    end
  end

  def show
    
  end


  def new
    @question = Question.new
    @type = @question.ques_type
  end


  def edit
    @type = @question.ques_type
  end


  def create
    ## Cannot assign in params
    params[:question][:options_attributes] = Question.map_answer(params[:question])
    
    @question = Question.new(params[:question])
    ## Send hidden field from form
    @question.admin_id = session[:admin_id]
    @question.tag_list = params[:as_values_tags]
    
    if @question.save
      redirect_to(@question, :notice => 'Question was successfully created.')
    else
      @type = params[:question][:ques_type] 
      render :action => "new"
    end
  end
    
    
  def update
    
    @question.admin_id = session[:admin_id]
    
    ## Send hidden field from form
    @question.tag_list = params[:as_values_tags]
        
    params[:question][:options_attributes] = Question.map_answer(params[:question])

    unless (@question.atleast_two_options?(params[:question]))
     flash[:option_error] = 'Atleast two and atmost four options are valid'
    end

    unless (@question.valid_answer?(params[:question]))
     flash[:answer_error] = ' not valid'
    end

    if flash[:option_error].blank? && flash[:answer_error].blank? && @question.update_attributes(params[:question])
      redirect_to(@question, :notice => 'Question was successfully updated.') 
    else
      @type = params['question']['ques_type']
      render :action => "edit" 
    end
  end


  def destroy
    @question.destroy
    redirect_to(questions_url) 
  end
  

  def tags_index
    @questions = Question.tagged_with(params[:name]).paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end
  

  def level_index
    @questions = Question.where("level = ?",params[:id]).paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end
  
  def category_index
    @questions = Question.where("category_id = ?",params[:id]).paginate :page => params[:page], :order => 'updated_at DESC', :per_page => 5
  end

  def make_test
    
  end
  

  def show_fetch_ques
    @question = Question.find(params[:id])
    render :partial => "show_fetch_ques"
  end
  
  
  def fetch_questions
    ques = Question.get_ques_by_tags(params[:as_values_tags])
    @questions = Question.search(ques, params[:type], params[:category_id], params[:level])
  end
  

  def change_answer_div
    @question = Question.where(" id = (?)", params[:id]).first unless params[:id].blank?
    if params['type'] == "Multiple Choice"
      @ajax_data = "multiple_choice"
    elsif params['type'] == "Multiple Choice/Answer"
      @ajax_data = "multiple_choice_answer"
    elsif params['type'] == "Subjective"
      @ajax_data = "subjective"
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

    unless FileTest.exists?("#{RAILS_ROOT}/public/temp_test/"+name+'.zip')
      Question.download(name)
      send_file "#{RAILS_ROOT}/public/temp_test/" + name + '.zip', :type => "application/zip"
    else
      send_file "#{RAILS_ROOT}/public/temp_test/" + name+ '.zip', :type => "application/zip"
    end
  end

  private
  
  def get_question_by_id
    @question = Question.where("id = (?)",params[:id]).first
  end
  
end
