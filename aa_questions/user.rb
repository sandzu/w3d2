require_relative 'questions_database'
require 'sqlite3'

class User
  attr_accessor :id, :fname, :lname

  def self.all
    data= QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map {|user| User.new(user)}
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def self.find_by_name (fname, lname)
    data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ?
    SQL
    return nil if data.empty?
    User.new(data.first)
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil if data.empty?
    User.new(data.first)
  end

  def authored_questions
    return nil if id.nil?
    Question.find_by_author_id(@id)

  end

  def authored_replies
    return nil if id.nil?
    Reply.find_by_author_id(@id)
  end

  def followed_questions
    return nil if id.nil?

    QuestionFollow.followed_questions_for_user_id(@id)
  end

end
