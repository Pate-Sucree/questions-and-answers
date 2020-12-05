import { ApolloServer } from 'apollo-server';
import neo4j from 'neo4j-driver';
import { makeAugmentedSchema, inferSchema } from 'neo4j-graphql-js';
import dotenv from 'dotenv';

// set neo4j credentials as environment vars from .env file
dotenv.config();

// create the driver to connect to the neo4j db
const driver = neo4j.driver(
  process.env.NEO4J_URI || 'bolt://localhost:7687',
  neo4j.auth.basic(
    process.env.NEO4J_USER || 'neo4j',
    process.env.NEO4J_PASSWORD || 'neo4j'
  ),
  {
    encrypted: process.env.NEO4J_ENCRYPTED ? 'ENCRYPTION_ON' : 'ENCRYPTION_OFF',
  }
)

// specify options for the inferschema function
const schemaInferenceOptions = {
  alwaysIncludeRelationships: false,
}

const inferAugmentedSchema = (driver) => {
  return inferSchema(driver, schemaInferenceOptions).then((result) => {
    console.log('TYPEDEFS:')
    console.log(result.typeDefs)

    return makeAugmentedSchema({
      typeDefs: result.typeDefs,
    })
  })
}

const createServer = (augmentedSchema) =>
  new ApolloServer({
    schema: augmentedSchema,
    // inject the request object into the context to support middleware
    // inject the Neo4j driver instance to handle database call
    context: ({ req }) => {
      return {
        driver,
        req,
      }
    },
  })

const port = process.env.GRAPHQL_SERVER_PORT || 3000

// generate a graphQL schema based off of existing neo4j db
inferAugmentedSchema(driver)
  .then(createServer)
  .then((server) => server.listen(port, '0.0.0.0'))
  .then(({ url }) => {
    console.log(`GraphQL API ready at ${url}`)
  })
  .catch((err) => console.error(err));