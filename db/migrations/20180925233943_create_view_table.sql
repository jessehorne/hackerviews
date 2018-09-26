-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE view(
	id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	post_id BIGINT NOT NULL,
	username VARCHAR(255) NOT NULL
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE view;
