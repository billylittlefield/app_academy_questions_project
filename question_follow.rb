# require './aa_questions.rb'

class QuestionFollow < DatabaseItem
  def self.all
    super(QuestionFollow, 'question_follows')
  end

  def self.find_by_id(id)
    QuestionFollow.find_by_any_id(QuestionFollow, 'id',
                                  id, 'question_follows').first
  end

  def self.find_by_question_id(question_id)
    QuestionFollow.find_by_any_id(QuestionFollow, 'question_id',
                                  question_id, 'question_follows')
  end

  def self.find_by_user_id(user_id)
    QuestionFollow.find_by_any_id(QuestionFollow, 'user_id',
                                  user_id, 'question_follows')
  end

  def self.most_followed_questions(n)
    most_followed_questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.id
    FROM
      question_follows
    JOIN
      questions ON questions.id = question_follows.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(questions.id)
    LIMIT ?
    SQL
    most_followed_questions.map{ |question| Question.find_by_id(question["id"])}
  end

  def self.followers_for_question_id(question_id)
    question_follows = QuestionFollow.find_by_question_id(question_id)
    question_follows.map { |question_follow|
                            User.find_by_id(question_follow.user_id) }
  end

  def self.followed_questions_for_user_id(user_id)
    question_follows = QuestionFollow.find_by_user_id(user_id)
    question_follows.map { |question_follow|
                            Question.find_by_id(question_follow.question_id) }
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
