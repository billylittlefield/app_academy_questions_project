require 'singleton'
require 'sqlite3'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('aa_questions.db')
    self.results_as_hash = true
    self.type_translation = true
  end
end
e
class DatabaseItem
  def self.find_by_any_id(klass, id_type, any_id, database_name)
    datas = QuestionsDatabase.instance.execute(<<-SQL, any_id)
    SELECT
      *
    FROM
      #{database_name}
    WHERE
      #{id_type} = ?
    SQL
    return nil if datas.nil?
    datas.map { |data| klass.new(data) }
  end

  def self.all(klass, database_name)
    all_data = QuestionDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{database_name}
    SQL
    all_data.map { |data| klass.new(data) }
  end

  def save
    if id.nil? #not saved yet
      QuestionsDatabase.instance.execute(<<-SQL, *vars)
      INSERT INTO
        questions (title, body, user_id)
      VALUES
        (?, ?, ?)
      SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
    else
      #need to update
      QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id, @id)
      UPDATE
        question
      SET
        title = ?, body = ?, user_id = ?
      WHERE
        id = ?
      SQL
    end
  end
end

require_relative 'user'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_like'
require_relative 'reply'
