// WARNING: This file is a JavaScript, NOT a CoffeeScript
if(process.env.NODE_ENV == null) {
    process.env.NODE_ENV = "test";
}

require('coffee-script');
require('chai').should();
require('../initEnvironment');



