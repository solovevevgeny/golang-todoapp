CREATE SCHEMA todoapp;

CREATE TABLE todoapp.users (
  id SERIAL PRIMARY KEY,
  version       BIGINT       NOT NULL,
  full_name     VARCHAR(100) NOT NULL CHECK(char_length(full_name) BETWEEN 3 AND 100),    
  phone_number  VARCHAR(20)           CHECK(
    phone_number ~ '^\+[0-9]+$' 
    AND char_length(phone_number) BETWEEN 10 AND 15 
  )   
);

CREATE TABLE todoapp.tasks (
    id SERIAL PRIMARY KEY,
    version       BIGINT       NOT NULL,
    title         VARCHAR(100) NOT NULL CHECK(char_length(title) BETWEEN 1 AND 255),
    description   VARCHAR(1000),
    completed     BOOLEAN      NOT NULL DEFAULT FALSE,
    creaated_at   TIMESTAMPTZ   NOT NULL,
    completed_at  TIMESTAMPTZ,
    author_user_id INTEGER NOT NULL REFERENCES todoapp.users(id)

);