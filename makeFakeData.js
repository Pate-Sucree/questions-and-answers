'use strict';

// generate random product_Id numbers for artillery tests
module.exports.generateRandomData = (userContext, events, done) => {
  const product_Id = (min = 1, max = 1000011) => {
    min = Math.ceil(min);
    max = Math.floor(max);
    return String(Math.floor(Math.random() * (max - min) + min));
  };
  userContext.vars.product_Id = product_Id();
  return done();
};
