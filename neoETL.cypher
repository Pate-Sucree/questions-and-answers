CREATE CONSTRAINT ON (product:Product) ASSERT product.id IS UNIQUE;
CREATE CONSTRAINT ON (question:Question) ASSERT question.id IS UNIQUE;
CREATE CONSTRAINT ON (answer:Answer) ASSERT answer.id IS UNIQUE;
CREATE CONSTRAINT ON (photo:Photo) ASSERT photo.id IS UNIQUE;

:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///product.csv' AS row
MERGE (product:Product {id: toInteger(row.id) })
  SET product += row


:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///questions.csv' AS row
WITH toInteger(row.id) AS id, toInteger(row.helpful) AS helpful, row.body AS body, row.asker_email AS email, row.asker_name AS name, toInteger(row.product_id) AS product_id, row.date_written AS date_written, row.reported AS reported
MERGE (question:Question {id: id})
  SET question.helpful = helpful, question.body = body, question.email = email, question.name = name, question.product_id = product_id, question.date_written = date_written, question.reported = reported




:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///questions.csv' AS row
CREATE (question:Question) SET question = row { .*, id: toInteger(row.id), helpful: toInteger(row.heplful), product_id: toInteger(row.product_id) }

:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///questions.csv' AS row
CREATE (q:Question) { id: toInteger(row.id), body: row.body, date: row.date_written, name: row.asker_name, email: row.asker_email, helpful: toInteger(row.heplful), reported: row.reported, product_id: toInteger(row.product_id) })


:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///questions.csv' AS row
WITH toInteger(row.helpful) AS helpful, row.body AS body, row.asker_email AS email, row.asker_name AS name, toInteger(row.product_id) AS product_id, row.date_written AS date_written, row.reported AS reported, row.id AS id
MERGE (q:Question {id: id})
  SET q.helpful = helpful, q.body = body, q.email = email, q.name = name, q.product_id = product_id, q.date_written = date_written, q.reported = reported

:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///questions.csv' AS row
WITH toInteger(row.id) AS id, toInteger(row.helpful) AS helpful, row.body AS body, row.asker_email AS email, row.asker_name AS name, toInteger(row.product_id) AS product_id, row.date_written AS date_written, row.reported AS reported
MERGE (q:Question {id: id})
  SET q.helpful = helpful, q.body = body, q.email = email, q.name = name, q.product_id = product_id, q.date_written = date_written, q.reported = reported


:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///answers.csv' AS row
CREATE (answer:Answer { id: toInteger(row.id), body: row.body, date: row.date_written, name: row.answerer_name, email: row.answerer_email, helpful: toInteger(row.helpful), reported: row.reported, question_id: toInteger(row.question_id) });
