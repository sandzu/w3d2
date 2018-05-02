CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)

);

CREATE TABLE questions_follows (
  question_id INTEGER NOT NULL,
  follower_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT NOT NULL


);
CREATE TABLE question_likes (
  user TEXT NOT NULL,
  question TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Alfred', 'Alejandrino'),
  ('Andzu', 'Schaefer');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('why is the sky blue?', 'i just dont get it??!?!', (SELECT id FROM users WHERE fname = 'Andzu')),
  ('why is grass green?', 'i wish it was not green.', (SELECT id FROM users WHERE fname = 'Alfred'));


INSERT INTO
  questions_follows( question_id, follower_id)
VALUES
  ((SELECT id FROM questions WHERE title LIKE '%grass%'), (SELECT id FROM users WHERE fname = 'Alfred')),
  ((SELECT id FROM questions WHERE title LIKE '%grass%'), (SELECT id FROM users WHERE fname = 'Andzu')),
  ((SELECT id FROM questions WHERE title lIKE '%sky%'), (SELECT id FROM users WHERE fname = 'Andzu'));

INSERT INTO
  replies(question_id, parent_reply, author_id, body)
VALUES
  ((SELECT id FROM questions WHERE title LIKE '%grass%'), NULL, (SELECT id FROM users WHERE fname = 'Andzu'), 'because of chlorophyll, yo!'),
  ((SELECT id FROM questions WHERE title LIKE '%grass%'), 1, (SELECT id FROM users WHERE fname = 'Andzu'), 'because Biology says so');

INSERT INTO
  question_likes(user, question, user_id, question_id)
VALUES
  ('Alfred', 'why is the sky blue?', (SELECT id FROM users WHERE fname = 'Alfred'), (SELECT id FROM questions WHERE title lIKE '%sky%') );
