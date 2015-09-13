DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL
);

DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) NOT NULL,
  question_id INTEGER REFERENCES questions(id) NOT NULL
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_reply_id INTEGER REFERENCES replies(id),
  user_id INTEGER REFERENCES users(id) NOT NULL,
  body TEXT NOT NULL
);

DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) NOT NULL,
  question_id INTEGER REFERENCES questions(id) NOT NULL
);


INSERT INTO
  users(fname, lname)
VALUES
  ('Bob', 'Smith'), ('Ned', 'Stark'), ('George', 'Washington'), ('John', 'Lennon');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('Greeting', 'How are you?', 1), ('SQL', 'How do I use this?', 2), ('Jobs', 'When will I get one?', 3), ('Murder', 'Who killed me?', 4),
  ('Yum', 'I like food?', 1);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1, 1), (2, 2), (3, 3), (1, 4), (2, 3), (4, 1);

INSERT INTO
  replies(question_id, parent_reply_id, user_id, body)
VALUES
  (1, NULL, 2, 'I''m doing well!'), (3, NULL, 4, 'Never!'), (1, 1, 3, 'Glad to hear it.'), (1, 3, 2, 'Cool!');

INSERT INTO
  question_likes(user_id, question_id)
VALUES
  (1, 1), (2, 2), (4, 4), (3, 2), (1, 3), (2, 4);
