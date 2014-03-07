_ = require 'lodash'

module.exports = (config) ->
  config.set
    basePath      : ''
    frameworks    : ['mocha']
    browsers      : ['PhantomJS']
    reporters     : ['progress']
    autoWatch     : true
    logLevel      : config.LOG_ERROR
    plugins       : [
      'karma-mocha'
      'karma-phantomjs-launcher'
      'karma-chrome-launcher'
      'karma-coffee-preprocessor'
    ]
    preprocessors :
      '**/*.coffee'     : ['coffee']
      '../src/*.coffee' : ['coffee']

    # coffeePreprocessor :
    #   options :
    #     bare      : true
    #     sourceMap : false
    #   transformPath: (path) ->
    #     path.replace(/\.coffee$/, '.js')

    files         : [].concat([
      '../node_modules/lodash/dist/lodash.js'
      '../node_modules/chai/chai.js'
      '../node_modules/sinon/pkg/sinon.js'
      '../node_modules/sinon-chai/lib/sinon-chai.js'
      '../src/Clog.coffee'
      'ClogTest.coffee'
    ])
