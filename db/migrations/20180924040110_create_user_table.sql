-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE user(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	username VARCHAR(255) NOT NULL,
	password VARCHAR(255) NOT NULL,
	about TEXT,
	role INT NOT NULL
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE user;
