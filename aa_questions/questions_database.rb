require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true

  end


end
#
# class User
#   attr_accessor :id, :fname, :lname
#
#   def self.all
#     data= QuestionsDatabase.instance.execute("SELECT * FROM users")
#     data.map {|user| User.new(user)}
#   end
#
#   def initialize(options)
#     @id = options['id']
#     @fname = options['fname']
#     @lname = options['lname']
#   end
#
#   def self.find_by_name (fname, lname)
#     data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         fname = ? AND lname = ?
#     SQL
#     return nil if data.empty?
#     User.new(data.first)
#   end
#
#   def self.find_by_id(id)
#     data = QuestionsDatabase.instance.execute(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         users
#       WHERE
#         id = ?
#     SQL
#     return nil if data.empty?
#     User.new(data.first)
#   end
#
#
# end
#
# class Question
#   attr_accessor :id, :title, :body, :author_id
#
#
#   def self.all
#     data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
#     data.map {|question| Question.new(question)}
#   end
#
#   def self.find_by_id(id)
#     data = QuestionsDatabase.instance.executre(<<-SQL, id)
#       SELECT
#         *
#       FROM
#         questions
#       WHERE
#         id = ?
#     SQL
#     return nil if data.empty?
#     Question.new(data.first)
#   end
#
#   def initialize(options)
#     @id = options['id']
#     @title = options['title']
#     @body = options ['body']
#     @author_id = options['author_id']
#   end
# end
