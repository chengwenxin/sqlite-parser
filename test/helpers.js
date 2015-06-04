var expect            = require('chai').expect,
    fs                = require('fs'),
    _                 = require('lodash'),
    sqlQueryParser    = require('../lib/index'),
    prettyjson        = require('prettyjson'),
    format, broadcast, getTree, assertOkTree, assertErrorTree,
    isDefined = function (arg) { return arg != null; };

format = function (arg) {
  return broadcast.ugly ? ( _.isString(arg) ? arg : JSON.stringify(arg) ) :
                ( prettyjson.render(arg, {}) );
};

broadcast = function (args, ugly) {
  // Only broadcast when DEBUG=true is set in the environment
  _.forEach(args, function (arg) {
    if (broadcast.shouldBroadcast(arg)) {
      console.log('\n\n', format(arg, ugly), '\n');
    }
  });
};
broadcast.debug = (function (p) {
  return isDefined(process) && _.has(process.env, 'DEBUG');
})(process);
broadcast.canBroadcast = (function (c, p) {
  return isDefined(console) && broadcast.debug;
})(console, process);
broadcast.shouldBroadcast = function (msg) {
  return broadcast.canBroadcast && isDefined(msg);
};
broadcast.ugly = (function (p) {
  return broadcast.shouldBroadcast && _.has(process.env, 'UGLY');
})(process);

/**
Load the source file for the current test and then try and generate the AST from it.
@note Uses the name of the test to determine what test input to use such that `bees-test`
  looks for the file `beesTest.sql` in the `./test/sql/` directory.
@note Alternative arguments format to pass options object is: that, options, callback.
@param [Object] that
  The context of the running test
@param [Function] callback
  The function to call when sqlQueryParser has generated the AST or an error.
*/
getTree = function (that, callback) {
  var args = Array.prototype.slice.call(arguments, 1),
      fileTitle = _.camelCase(that.test.title.trim()),
      filePath = __dirname + '/sql/' + fileTitle + '.sql';
  fs.readFile(filePath, "utf8", function(err, data) {
    if (err) {
      callback(err);
    } else {
      args.unshift(data);
      sqlQueryParser.apply(that, args);
    };
  });
};

/**
Assert that the current file returns an AST without errors.
@note Alternative arguments format to pass options object is: that, options, done.
@param [Object] that
  The context of the running test
@param [Function] done
  The function to call when the test is completed
*/
assertOkTree = function (that, done) {
  var options = {}, func = done;
  if (arguments.length > 2) {
    options = done;
    func = arguments[2];
  }
  getTree.apply(that, [that, options, function (err, ast) {
    broadcast(arguments);
    expect(err).to.not.be.ok;
    expect(ast).to.be.ok;
    func.call(that);
  }]);
};

/**
Assert that the current file returns an error containing the properties and values in the
given object.
@note Alternative arguments format to pass options object is: obj, that, options, done.
@param [Object|String] obj
  The properties and values to assert within the error generated for the running test. If
  a string is given, then it is asserted that the error message contains the text provided.
@param [Object] that
  The context of the running test
@param [Function] done
  The function to call when the test is completed
*/
assertErrorTree = function (obj, that, done) {
  var options = {}, func = done;
  if (arguments.length > 3) {
    options = done;
    func = arguments[3];
  }
  if (_.isUndefined(obj)) { obj = {}; }
  else if (_.isString(obj)) { obj = { 'message': obj }; }
  getTree.apply(that, [that, options, function (err, ast) {
    broadcast(arguments);
    expect(ast).to.not.be.ok;
    if (obj == null) {
      expect(err).to.be.ok;
    } else {
      _.forEach(obj, function (v, k) {
        expect(err).to.include.keys(k);
        expect(err[k]).to.equal(v);
      });
    }
    func.call(that);
  }]);
};

/**
Assert that the current file returns an AST containing the properties and values in the
given object.
@note Alternative arguments format to pass options object is: obj, that, options, done.
@param [Object|String] obj
  The properties and values to assert within the AST generated for the running test.
@param [Object] that
  The context of the running test
@param [Function] done
  The function to call when the test is completed
*/
assertEqualsTree = function (obj, that, done) {
  var options = {}, func = done;
  if (arguments.length > 3) {
    options = done;
    func = arguments[3];
  }
  if (_.isUndefined(obj)) { obj = {}; }
  getTree.apply(that, [that, options, function (err, ast) {
    broadcast(arguments);
    expect(err).to.not.be.ok;
    if (_.isString(obj)) {
      obj = JSON.parse(obj);
    }
    expect(ast).to.deep.equal(obj);
    func.call(that);
  }]);
};

module.exports = {
  'get': getTree,
  'ok': assertOkTree,
  'error': assertErrorTree,
  'equals': assertEqualsTree,
  'broadcast': broadcast
};
