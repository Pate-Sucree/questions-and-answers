const concurrently = require('concurrently');
const path = require('path');
const execa = require('execa');

const concurrentOpts = {
  restartTries: 3,
  prefix: '{time} {name} |',
  timestampFormat: 'HH:mm:ss',
}

const jobs = [
  {
    name: 'graphQL API',
    command: `npm run start:dev`,
    prefixColor: 'magenta',
  },
]

concurrently(jobs, concurrentOpts).catch((e) => {
  console.error(e.message)
})