require_relative 'questions_database'
require 'sqlite3'
require_relative 'user'
require_relative 'reply'
require_relative 'question'

class QuestionFollow

  def self.all
      data = QuestionsDatabase.instance.execute('SELECT * FROM questions_follows')
      data.map {|question_follow| QuestionFollow.new(question_follow)}
  end

  def self.followers_for_question_id(question_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        users
      WHERE
        id IN (SELECT
                follower_id
              FROM
                questions_follows
              WHERE
                question_id = ?) --AS follow_ids
    SQL
    data.map {|user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        questions_follows
      JOIN
        questions
        ON questions.id = questions_follows.question_id
      WHERE
        questions_follows.follower_id = ?
    SQL
    data.map {|question| Question.new(question)}
  end

  def self.most_followed_questions(n)
    data = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        questions
      JOIN
        questions_follows
        ON questions.id = questions_follows.question_id
      GROUP BY
        question_id
      ORDER BY
        COUNT(*) DESC
      SQL
      data.map {|question| Question.new(question)}.take(n)
  end


  def initialize(options)
    @question_id = options['question_id']
    @follower_id = options['follower_id']
  end

end
