// constraints
CREATE CONSTRAINT ON (product:Product) ASSERT product.id IS UNIQUE;
CREATE CONSTRAINT ON (question:Question) ASSERT question.id IS UNIQUE;
CREATE CONSTRAINT ON (answer:Answer) ASSERT answer.id IS UNIQUE;
CREATE CONSTRAINT ON (photo:Photo) ASSERT photo.id IS UNIQUE;

// load products
:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///product.csv' AS row
CREATE (product:Product { id: toInteger(row.id), name: row.name, category: row.category});

// load questions
:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///questions.csv' AS row
CREATE (q:Question { id: toInteger(row.id), body: row.body, date: row.date_written, name: row.asker_name, email: row.asker_email, helpful: toInteger(row.heplful), reported: row.reported, product_id: toInteger(row.product_id) })

// Load Answers
:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///answers.csv' AS row
CREATE (answer:Answer { id: toInteger(row.id), body: row.body, date: row.date_written, name: row.answerer_name, email: row.answerer_email, helpful: toInteger(row.helpful), reported: row.reported, question_id: toInteger(row.question_id) });

// load photos
:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///answers_photos.csv' AS row
CREATE (photo:Photo { id: toInteger(row.id), answer_id: toInteger(row.answer_id), url: row.url});

// BATCH P/Q
call apoc.periodic.iterate(
  'MATCH (q:Question) RETURN q',
  'UNWIND $_batch AS _batch WITH _batch.q as q MATCH (p:Product {id:q.product_id}) MERGE (p)-[:HAS_QUESTION]->(q)',
  {batchMode: 'BATCH_SINGLE', batchSize:10000})

// BATCH CREATE Q/A
call apoc.periodic.iterate(
  'MATCH (a:Answer) RETURN a',
  'UNWIND $_batch AS _batch WITH _batch.a AS a MATCH (q:Question {id:a.question_id}) MERGE (q)-[:HAS_ANSWER]->(a)',
  {batchMode: 'BATCH_SINGLE', batchSize:10000})

// BATCH photo/answer
call apoc.periodic.iterate(
  'MATCH (p:Photo) RETURN p',
  'UNWIND $_batch AS _batch WITH _batch.p AS p MATCH (a:Answer {id:p.answer_id}) MERGE (a)-[:HAS_PHOTO]->(p)',
  {batchMode: 'BATCH_SINGLE', batchSize:10000})