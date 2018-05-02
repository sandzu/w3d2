require_relative 'questions_database'
require 'sqlite3'

class Question
  attr_accessor :id, :title, :body, :author_id

  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map {|question| Question.new(question)}
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    return nil if data.empty?
    Question.new(data.first)
  end

  def self.find_by_id(id)
    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil if data.empty?
    Question.new(data.first)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options ['body']
    @author_id = options['author_id']
  end

  def author
    return nil if author_id.nil?

    User.find_by_id(@author_id)

  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)

  end

end
