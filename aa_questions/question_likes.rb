require 'sqlite3'

require_relative 'reply'
require_relative 'question'
require_relative 'user'
require_relative 'question_follows'

class QuestionLike
  def self.likers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id )
      SELECT
        *
      FROM
        users
      JOIN
        question_likes
      ON
        question_likes.user_id = users.id
      WHERE
        question_id = ?
    SQL

    data.map{|user| User.new(user)}
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*)
      FROM
        question_likes
      WHERE
        question_id = ?
      SQL

      data.first.values.first

  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes
        ON questions.id = question_likes.question_id
      WHERE
        question_likes.user_id = ?
      SQL

      data.map{|question| Question.new(question)}
  end



end
