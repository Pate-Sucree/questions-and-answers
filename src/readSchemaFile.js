import fs from 'fs';
import path from 'path';

/*
  * Read the graphql schema file
  * Convert to string
  * Export it as module
*/
export const typeDefs = fs
  .readFileSync(path.join(__dirname, 'schema.graphql'))
  .toString('utf-8');