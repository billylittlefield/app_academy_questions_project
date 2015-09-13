# require './aa_questions.rb'

class Reply < DatabaseItem
  def self.all
    super(Reply, 'replies')
  end

  def self.find_by_id(id)
    Reply.find_by_any_id(Reply, 'id', id, 'replies').first
  end

  def self.find_by_user_id(user_id)
    Reply.find_by_any_id(Reply, 'user_id', user_id, 'replies')
  end

  def self.find_by_question_id(question_id)
    Reply.find_by_any_id(Reply, 'question_id', question_id, 'replies')
  end

  def self.find_by_parent_reply_id(parent_reply_id)
    Reply.find_by_any_id(Reply, 'parent_reply_id', parent_reply_id, 'replies')
  end

  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def initialize(options = {})
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_reply_id)
  end

  def child_replies
    Reply.find_by_parent_reply_id(@id)
  end

  def save
    if id.nil? #not saved yet
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_reply_id, @user_id, @body)
      INSERT INTO
        replies (question_id, parent_reply_id, user_id, body)
      VALUES
        (?, ?, ?, ?)
      SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
    else
      #need to update
      QuestionsDatabase.instance.execute(<<-SQL, @question_id, @parent_reply_id, @user_id, @body, @id)
      UPDATE
        replies
      SET
        question_id = ?, parent_reply_id = ?, user_id = ?, body = ?
      WHERE
        id = ?
      SQL
    end
  end
end
