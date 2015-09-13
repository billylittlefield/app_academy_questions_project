# require './aa_questions.rb'

class QuestionLike < DatabaseItem
  def self.all
    super(QuestionLike, 'question_likes')
  end

  def self.find_by_id(id)
    QuestionLike.find_by_any_id(QuestionLike, 'id', id, 'question_likes').first
  end

  def self.likers_for_question_id(question_id)
    liker_ids = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        user_id
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    liker_ids.map { |liker_id| User.find_by_id(liker_id['user_id']) }
  end

  def self.num_likes_for_question_id(question_id)
    counts = QuestionsDatabase.instance.execute(<<-SQL, question_id).first
      SELECT
        COUNT(question_likes.question_id) AS count
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL
    counts['count']
  end

  def self.liked_questions_for_user_id(user_id)
    question_ids = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        question_id
      FROM
        question_likes
      WHERE
        user_id = ?
    SQL
    question_ids.map { |question_id| Question.find_by_id(question_id['question_id']) }
  end

  def self.most_liked_questions(n)
    most_liked_questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.id
    FROM
      question_likes
    JOIN
      questions ON questions.id = question_likes.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(questions.id)
    LIMIT
      ?
    SQL
    most_liked_questions.map{ |question| Question.find_by_id(question["id"])}
  end

  attr_accessor :id, :user_id, :question_id

  def initialize(options = {})
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
