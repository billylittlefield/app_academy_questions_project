# require './aa_questions.rb'

class User < DatabaseItem
  def self.all
    super(User, 'users')
  end

  def self.find_by_id(id)
    User.find_by_any_id(User, 'id', id, 'users').first
  end

  def self.find_by_name(fname, lname)
    user_data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname).first
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL
    user_data.nil? ? nil : User.new(user_data)
  end

  attr_accessor :id, :fname, :lname

  def initialize(options = {})
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(id)
  end

  def authored_replies
    Reply.find_by_user_id(id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(id)
  end

  def average_karma
    karma = QuestionsDatabase.instance.execute(<<-SQL).first
      SELECT
        COUNT(question_likes.id) /
        CAST(COUNT(DISTINCT(questions.id)) AS FLOAT) AS karma
      FROM
        questions
      OUTER LEFT JOIN
        question_likes ON questions.id = question_likes.question_id
      WHERE
        questions.user_id = 2
      SQL
      karma['karma']
  end

  def save
    if id.nil? #not saved yet
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
      SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
    else
      #need to update
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
      SQL
    end
  end
end
