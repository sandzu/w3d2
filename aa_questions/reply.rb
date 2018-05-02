require 'sqlite3'
require_relative 'questions_database'
require_relative 'user'
require_relative 'question'
require 'byebug'

class Reply
  attr_accessor :id, :question_id, :parent_reply, :author_id, :body
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map{|reply| Reply.new(reply)}
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply = options['parent_reply']
    @author_id = options['author_id']
    @body = options['body']
  end

  def self.find_by_author_id(author_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        author_id = ?
      SQL

    data.map {|reply| Reply.new(reply) }
  end

  def self.find_by_id(id)
    return nil if id.nil?

    data = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
      SQL

    return nil if data.empty?
    Reply.new(data.first)
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
      SQL

    data.map {|reply| Reply.new(reply) }

  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parents
    return nil if @parent_reply.nil?

    Reply.find_by_id(@parent_reply)
  end



  def child_replies
    data = QuestionsDatabase.instance.execute(<<-SQL, @id )
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply = ?
    SQL
    data.map{|reply| Reply.new(reply)}
  end

end
