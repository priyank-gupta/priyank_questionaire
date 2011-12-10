class Question < ActiveRecord::Base

  LEVEL = [["Beginner", 0], ["Intermediate", 1], ["Master", 2]]
  
  belongs_to :category
  has_many :options, :dependent => :destroy
  has_many :answers, :dependent => :destroy
  belongs_to :admin
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
  validates :body, :presence => true
  validates :ques_type, :presence => true
  ### Should be commented
  #validates :answers, :presence => true
  validates :category_id, :presence => true
  validates :level, :presence => true
  
  #validate :atleast_two_options
  ### Should be commented
  #validate :valid_answer
  
  accepts_nested_attributes_for :answers, :allow_destroy => true 
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => lambda { |c| c['body'].blank? }
  
  attr_accessor :tag
  
  def self.question_tags(str)
		taggings = tag_counts_on(:tags).collect{|t| [t.id, t.name]}
		question_tags = taggings.select{|tag| tag[1].downcase.match("#{ str }".downcase)}.uniq
    data = Array.new
    question_tags.each do |tag|
     json = Hash.new
     json['name']  = tag[1] #name
     json['value'] = tag[1] #id
     data << json
    end
    return data
  end
		
  private
  
  def self.valid_answer?(answer, option)
    if options?(option)
      if answers?(answer)
        c = 0
        ans_temp = []
        answer_temp = []
        answer.each do |ans_i, ans|
          if ans[:body]
            answer_temp << ans
          end
          option.each do |opt_i, opt|
            if( !opt['body'].blank? && ans['body'] == opt['body'] )
              ans_temp << opt
              break;
            end
          end
        end
        return true if answer_temp.length == ans_temp.length
      else
        return false
      end
    else
      return true unless answer['1']['body'].blank?
    end
  end
  
  def self.atleast_two_options?(option)
    if options?(option)
      c = 0
      option.each do |index, opt|
        unless opt['body'].blank?
          c += 1
        end
      end
      return true if c >= 2 && c <= 4
    else
      return true
    end 
  end
  
  def self.options?(options)
    if options
      options.each do |opt_i, opt|
        if opt['body']
          return true
        end
      end
      return false
    else
      return false
    end
  end
  
  def self.answers?(answers)
    if answers
      answers.each do |ans_i, ans|
        if ans['body']
          return true
        end
      end
      return false
    else
      return false
    end
  end
  
end
