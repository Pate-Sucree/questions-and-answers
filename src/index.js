import { ApolloServer } from 'apollo-server';
import neo4j from 'neo4j-driver';
import { makeAugmentedSchema } from 'neo4j-graphql-js';
import dotenv from 'dotenv';
import { typeDefs } from './readSchemaFile';

// set neo4j credentials as environment vars from .env file
dotenv.config();

// use the defined graphql schema that is read from readSchemaFile.js
const schema = makeAugmentedSchema({ typeDefs });

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

// create apollo server with ne4j driver and schema
const server = new ApolloServer({
  context: { driver, neo4jDatabase: process.env.NEO4J_DATABASE },
  schema: schema,
  playground: true,
});

// use gloabl prot ENV var or port 3000
const port = process.env.GRAPHQL_SERVER_PORT || 3000;

// START THE SERVER!
server.listen(port, '0.0.0.0')
  .then(({ url }) => {
    console.log(`GraphQL API ready at ${url}`)
  })
  .catch((err) => console.error(err));
