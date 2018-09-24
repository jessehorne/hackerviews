-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE post(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	title VARCHAR(255) NOT NULL,
	url VARCHAR(255) NOT NULL,
	username VARCHAR(255) NOT NULL,
	`text` TEXT NOT NULL,
	ups INT NOT NULL,
	downs INT NOT NULL,
	views INT NOT NULL,
	clicks INT NOT NULL
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE post;
