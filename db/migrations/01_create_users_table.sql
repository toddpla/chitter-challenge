CREATE TABLE Users(
  id SERIAL PRIMARY KEY,
  email VARCHAR(60) NOT NULL,
  password VARCHAR(140) NOT NULL
);
