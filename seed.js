// npm install --save neo4j-driver
var neo4j = require('neo4j-driver');
var driver = neo4j.driver('bolt://localhost:7687', neo4j.auth.basic('neo4j', 'coffee'));

var query =
  'MATCH (n) \
   RETURN (n)';

var session = driver.session();

session.run(query)
  .then((results) => {
    console.log('HEY FROM THE DATABASE');
    console.log(results);
  })
  .catch((err) => console.log(err))
  .finally(() => session.close());

