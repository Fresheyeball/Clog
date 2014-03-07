{expect} = chai

window.CONFIG = BUILD_MODE : false

describe 'Clog', ->
  clog         = null
  window.debug = 1

  init = (isChrome) ->    
    clog = new window.__ClogClass()
    clog._console =
      log      : sinon.spy()
      warn     : sinon.spy()
      info     : sinon.spy()
      image    : (if isChrome then sinon.spy() else null)
      meme     : sinon.spy()
      group    : sinon.spy()
      time     : sinon.spy()
      timeEnd  : sinon.spy()
      groupEnd : sinon.spy()
      trace    : sinon.spy()

  describe 'basics', ->
    beforeEach -> init()

    it '_arrow', ->
      for i in [0..._.random 25, 500]
        expect(clog._arrow()).to.equal "#{i} --->\t"

    describe 'is a passthrough plus arrow', ->

      testLogType = (name) -> it name, ->
        clog[name] 'woot'
        expect(clog._console[name]).to.have.been.calledWith '0 --->\t', 'woot'

        clog[name] 'woot', 234, foo : 2
        expect(clog._console[name]).to.have.been.calledWith '1 --->\t', 'woot', 234, foo : 2

      testLogType type for type in ['log','info','warn']

  describe 'game over', ->

    it 'do not log more than MAX_LOG times', ->
      init()
      clog._MAX_LOG = 10
      clog.log 'woot' for [0...clog._MAX_LOG]
      expect(clog._console.log.callCount).to.equal clog._MAX_LOG
      clog.log 'one too many'
      expect(clog._console.log.callCount).to.equal clog._MAX_LOG + 1
      expect(clog._console.log).to.have.been.calledWithMatch "#{clog._MAX_LOG} is Clogged enough"
      clog.log 'blocked' for [0..._.random 5, 500]
      expect(clog._console.log.callCount).to.equal clog._MAX_LOG + 1

    it 'should be an image if available', ->
      init true
      clog._MAX_LOG = 10
      clog.log 'woot' for [0...clog._MAX_LOG + 2]
      expect(clog._console.log).to.have.been.calledWithMatch "#{clog._MAX_LOG} is Clogged enough"
      expect(clog._console.image).to.have.been.called
      
  describe 'count', ->

    it 'unnamed counter warns', ->
      init()
      clog.count()
      expect(clog._console.warn).to.have.been.calledWith '0 --->\t', 'Clog.counter needs a name'

    it 'chrome version styles the number', ->
      init true
      clog.count 'thingy'
      expect(clog._console.warn).to.not.have.been.called
      expect(clog._console.log).to.have.been.calledWith '0 --->\t thingy -> %c1',
      "font-weight:bold;font-size:14px;", 'times'

    it 'increments', ->
      init()
      for i in [0..._.random 10, 100]
        clog.count 'thingy'
        expect(clog._console.warn).to.not.have.been.called
        expect(clog._console.log).to.have.been.calledWith "#{i} --->\t thingy -> #{i + 1} times"

    it 'multiple counters', ->
      init()
      clog.count 'thingy'
      expect(clog._console.log).to.have.been.calledWith "0 --->\t thingy -> 1 times"
      clog.count 'other thing'
      expect(clog._console.log).to.have.been.calledWith "1 --->\t other thing -> 1 times"
      clog.count 'thingy'
      clog.count 'thingy'
      expect(clog._console.log).to.have.been.calledWith "3 --->\t thingy -> 3 times"
      clog.count 'other thing'
      expect(clog._console.log).to.have.been.calledWithMatch "4 --->\t other thing -> 2 times"

  describe 'test', ->

    beforeEach -> init()

    it 'one arg', ->
      foo = 5
      clog.test foo
      expect(clog._console.log).to.have.been.calledWith "0 --->\t", foo : 5

    it 'many args', ->
      foo = 12
      bar = 'how?'
      baz = this : 'cant be'

      clog.test foo, bar, baz
      expect(clog._console.log).to.have.been.calledWith "0 --->\t",
        foo : 12
        bar : 'how?'
        baz : this : 'cant be'

    it '`this` becomes @', ->
      @foo = 6
      clog.test @foo
      expect(clog._console.log).to.have.been.calledWith "0 --->\t", '@foo' : 6

    it 'no args memes', ->
      expect(clog.test).to.throw.Error

    it.skip 'multiple tests', ->
      foo = 6
      bar = 7
      clog.test foo
      expect(clog._console.log).to.have.been.calledWith "0 --->\t", 'foo' : 6
      clog.test bar
      expect(clog._console.log).to.have.been.calledWith "1 --->\t", 'bar' : 7

  describe 'now and since', ->
    beforeEach -> init()
    it 'unnamed', ->
      clog.now()
      expect(clog._console.group).to.have.been.called
      expect(clog._console.log).to.have.been.calledWith 'tardis begins'
      expect(clog._console.time).to.have.been.calledWith 'tardis'

      clog.since()
      expect(clog._console.timeEnd).to.have.been.called
      expect(clog._console.groupEnd).to.have.been.called

    it 'named', ->
      name = 'jack'
      clog.now name
      expect(clog._console.group).to.have.been.called
      expect(clog._console.log).to.have.been.calledWith name + ' begins'
      expect(clog._console.time).to.have.been.calledWith name

      clog.since()
      expect(clog._console.timeEnd).to.have.been.called
      expect(clog._console.groupEnd).to.have.been.called

  describe 'meme', ->
    meme = -> clog.meme 'topline', 'bottomline', 'type', 'message'

    afterEach -> window.CONFIG = BUILD_MODE : false

    describe 'build false', ->
      beforeEach -> window.CONFIG = BUILD_MODE : false

      it 'in chrome', ->
        init true
        expect(meme).to.throw 'message'
        expect(clog._console.meme).to.have.been.calledWith 'topline', 'bottomline', 'type'

      it 'not chrome', ->
        init()
        expect(meme).to.throw 'message'
        expect(clog._console.meme).to.not.have.been.called

    describe 'build true', ->
      beforeEach ->
        window.CONFIG = BUILD_MODE : true

      it 'in chrome', ->
        init true
        meme()
        expect(clog._console.meme).to.have.been.calledWith 'topline', 'bottomline', 'type'
        expect(clog._console.log).to.not.have.beenCalled

      it 'not chrome', ->
        init()
        meme()
        expect(clog._console.meme).to.not.have.been.called
        expect(clog._console.log).to.have.been.calledWith 'ERROR meme : message'

  describe 'huge', ->

    it 'in chrome', ->
      init true
      clog.huge 'biggness'
      expect(clog._console.log).to.have.been.calledWith '%cbiggness', '''
        font-size:60px;color:#fff;text-shadow:0 1px 0 #ccc ,0 2px 0 #c9c9c9 ,0 3px 0 #bbb ,
        0 4px 0 #b9b9b9 ,0 5px 0 #aaa ,0 6px 1px rgba(0,0,0,.1),
        0 0 5px rgba(0,0,0,.1),0 1px 3px rgba(0,0,0,.3),
        0 3px 5px rgba(0,0,0,.2),0 5px 10px rgba(0,0,0,.25),
        0 10px 10px rgba(0,0,0,.2),0 20px 20px rgba(0,0,0,.15);
      '''

    it 'not chrome', ->
      init()
      clog.huge 'not biggness'
      expect(clog._console.log).to.have.been.calledWith 'HUGE : not biggness'

  describe 'color', ->
    COLORS = ['red','blue','green','orange','purple']

    it 'in chrome', ->
      init true

      testColor = (color, i = 0) ->
        clog[color] color + 'ness'
        expect(clog._console.log).to.have.been.calledWith "%c#{i} --->\t #{color}ness",
        "color:#{color};font-weight:bold;"

      testColor color, i for color, i in COLORS

    it 'should JSON.stringify first argument', ->
      init true
      foo = bar : 3
      clog.red foo
      expect(clog._console.log).to.have.been.calledWith "%c0 --->\t #{JSON.stringify foo}",
        "color:red;font-weight:bold;"

    # BASH VERSION IS NOT TESTABLE

    it 'aliases', ->
      init true
      for color in _.last COLORS, COLORS.length - 1
        clog[color] = sinon.spy()
        clog[_.first(color, 3).join('')] color + 'short'
        expect(clog[color]).to.have.been.calledWith color + 'short'

  describe 'keanu', ->

    it 'in chrome', ->
      init true
      clog.keanu true
      expect(clog._console.image).to.have.been.calledWith 'http://replygif.net/i/537.gif'

      clog.keanu()
      expect(clog._console.image).to.have.been.calledWith 'http://www.quotespapa.com/images/mini-keanu-reeves.jpg'

    it 'not chrome', (done) ->
      init()
      clog._console.log = (str) ->
        expect(str).to.match /KEANU/
        done()
      clog.keanu()

    it 'return quote', ->
      init()
      expect(clog.keanu()).to.be.a.String

  describe 'arnold', ->

    it 'in chrome', ->
      init true
      clog.arnold()
      expect(clog._console.image).to.have.been.called

    it 'not chrome', (done) ->
      init()
      clog._console.log = (str) ->
        expect(str).to.match /ARNOLD/
        done()
      clog.arnold()

    it 'return quote', ->
      init()
      expect(clog.arnold()).to.be.a.String