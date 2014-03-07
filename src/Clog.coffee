MAXCLOG = 2000

_ = require 'lodash' if require?

class Clog
  constructor : ->
    @_logIndex      = 0
    @_MAX_LOG       = 2000
    @_console       = console
    @_level         = (if window? and window.debug then window.debug else 0)
    @_console.image = null unless (window? and window.chrome and window.console.image)

  setLevel = (level) -> @_level = level

  _arrow : -> "#{@_logIndex++} --->\t"

  _bail  : ->
    if not @__bailed and @_logIndex >= @_MAX_LOG
      @__bailed = true
      enough    = "#{@_MAX_LOG} is Clogged enough"
      if @_console.image
        gameOverGifs = [
          'https://i.chzbgr.com/maxW500/7780675840/h4A8F373B/'
          'https://i.chzbgr.com/maxW500/6162212352/h20E396D/'
          'https://i.chzbgr.com/maxW500/5947685376/h2026921A/'
          'https://i.chzbgr.com/maxW500/5192719104/h254004F0/'
          'http://files.alexasto-com.webnode.es/200000002-cfe27d1d67/classic_game_over_screen_by_el_tortuga-d5eeh9l.gif'
          'http://images.wikia.com/sawfilms/images/8/8c/Game_Over_1.gif'
          'http://2.bp.blogspot.com/-zNngZiOlI3g/URurPtgBfSI/AAAAAAAASY4/Tvzxso3_PKA/s400/Game-Over-Man-Game-Over.jpg'
        ]
        @_console.image gameOverGifs[_.random 0, gameOverGifs.length - 1]
        @_console.log enough
      else
        @_console.log '''
          <------------------------>\n
          <------- GAME OVER ------>\n
          <------------------------>\n
        ''' + enough
    return @__bailed

  _passThrough : (name, args...) ->
    @_console[name] @_arrow(), args... unless @_bail()
  log     : (args...) -> @_passThrough 'log', args...
  info    : (args...) ->
    @_passThrough 'info', args... if @_level > 0
  warn    : (args...) -> @_passThrough 'warn', args...

  count  : (name) ->
    return @warn 'Clog.counter needs a name' unless name
    @_counter       ?= {}
    @_counter[name] ?= 0
    if @_console.image
    then @_console.log "#{@_arrow()} #{name} -> %c#{++@_counter[name]}", "font-weight:bold;font-size:14px;", 'times'
    else @_console.log "#{@_arrow()} #{name} -> #{++@_counter[name]} times"

  test   : ->
    unless @_bail()
      if arguments.length is 0
        return @meme "You wish to test nothing...", "Solipsist!", "Philosoraptor"

      meta = arguments.callee.caller.toString().match /Clog.test\(.+\)/igm
      meta = meta[0].substr "Clog.test(".length
      meta = meta.substr 0, meta.length - 1
      meta = meta.split ','
      meta = _.map meta, (d) -> d.trim().replace('this.','@')
      res  = {}
      res[meta[i]] = arguments[i] for i in [0...meta.length]
      @log res

  timerName = null
  now : (msg) =>
    unless @_bail()
      msg ?= 'tardis'
      timerName = msg
      @_console.group "#{@_arrow()} #{timerName}"
      @_console.log "#{timerName} begins"
      @_console.time timerName
  since : ->
    unless @_bail()
      @_console.timeEnd timerName
      @_console.groupEnd()

  meme : (memeOne, memeTwo, memeType, logMessage) ->
    if @_console.image
      @_console.meme memeOne, memeTwo, memeType
    
    if (window? and window.CONFIG and window.CONFIG.BUILD_MODE is false) or not window?
      throw new Error logMessage

    if window? and not @_console.image
      @_console.log "ERROR meme : #{logMessage}"

  silence : ->
    @_console =
      log      : ->
      warn     : ->
      info     : ->
      group    : ->
      groupEnd : ->
      trace    : ->
      time     : ->
      image    : false

  noImage : ->
    @_console.image = false

  huge : (str) ->
    if @_console.image
      @_console.log "%c#{str}", '''
        font-size:60px;color:#fff;text-shadow:0 1px 0 #ccc ,0 2px 0 #c9c9c9 ,0 3px 0 #bbb ,
        0 4px 0 #b9b9b9 ,0 5px 0 #aaa ,0 6px 1px rgba(0,0,0,.1),
        0 0 5px rgba(0,0,0,.1),0 1px 3px rgba(0,0,0,.3),
        0 3px 5px rgba(0,0,0,.2),0 5px 10px rgba(0,0,0,.25),
        0 10px 10px rgba(0,0,0,.2),0 20px 20px rgba(0,0,0,.15);
      '''
    else @_console.log "HUGE : #{str}"

  _drill : ->
    if @_console.image
      @_console.image "http://www.pixeljoint.com/files/icons/full/steam_mech_drillpunch.gif"
    else @_console.log "DRILLDOWN"

  _color : (color, str, args...) ->
    unless @_bail()
      if @_console.image
        @_console.log "%c#{str}", "color:#{color};font-weight:bold;", args...
      else
        END_COLOR = `'\033[0m'`
        bashColor = switch color
          when 'red'    then `'\033[0;31m'`
          when 'green'  then `'\033[0;32m'`
          when 'blue'   then `'\033[0;34m'`
          when 'orange' then `'\033[1;33m'`
          when 'purple' then `'\033[0;35m'`

        for ar in args
          str += " | #{JSON.stringify ar}"
        @_console.log "#{bashColor} #{str} #{END_COLOR}"

  _prepForColor : (str) ->
    str = JSON.stringify str unless _.isString str
    "#{@_arrow()} #{str}"

  red    : (str, args...) -> @_color 'red',      @_prepForColor(str), args...
  green  : (str, args...) -> @_color 'green',    @_prepForColor(str), args...
  blue   : (str, args...) -> @_color 'blue',     @_prepForColor(str), args...
  orange : (str, args...) -> @_color 'orange',   @_prepForColor(str), args...
  purple : (str, args...) -> @_color 'purple',   @_prepForColor(str), args...
  blu    : (args...)      -> @blue   args...
  ora    : (args...)      -> @orange args...
  gre    : (args...)      -> @green  args...
  pur    : (args...)      -> @purple args...

  _andrew : (memeTwo, logMessage) ->
    @meme "hey developer", memeTwo, "http://i.imgur.com/aQ3wwGi.jpg", logMessage

  keanu : (isBig) ->
    keanu     = ['Woah', 'I am the one.', 'Party on', 'No way', 'Woah', 'I know kung fu', 'Excellent!', 'Huh?', 'Whoah..', 'All we are is dust in the wind, dude', 'Most Triumphant', 'Strange things are a foot at the Circle K', 'no way', '69 Dudes!', 'Those are historic babes!', 'Bodacious!','Fully full on evil robots','So-crates','Morpheous',"I'm going to learn jiu jitsu?",'My name is Neo.','No.','take 1 step out and take my hand','freeze','id wanna know what bus it was','bomb on bus','i need to know can you handle this bus','the man has no time','theres a gap in the freeway','thats all we can do','floor it','thats against the rules','im gonna rip your fucking spine out i swear to god','pop quiz asshole','your crazy your fuckin crazy','he lost his head']
    thisKeanu = 'KEANU -> ' + keanu[_.random(keanu.length - 1)]
    unless @_bail()
      if @_console.image and not _.isString isBig
        if isBig
        then @_console.image 'http://replygif.net/i/537.gif'
        else @_console.image 'http://www.quotespapa.com/images/mini-keanu-reeves.jpg'
      else if _.isString isBig
        @_color isBig, thisKeanu
      else
        @_console.log  thisKeanu

    return thisKeanu

  arnold : (color) ->
    arnold     = ["It's simple, if it jiggles, it's fat.", 'Milk is for babies. When you grow up you have to drink beer.', 'The best activities for your health are pumping and humping.', "You're Fiuhed!","Cookies, who told you you could MY COOKIES!!!!??","Who is your Daddy, and what does he do?","I'm detective John Kimble","Get in the chopper, now!!", "Guwhah ruuugh guawh!", "Grrrgh uu ahhh!", "Naaa gruh aagghh!!!","Grrruu guaw ghh raaaaaagh!","IT'S NOT A TUMOR!","SHAAAD AAAAAAAAAAAAAAAP!",'I let him go..','He had to split',"Remember Sully when I said I'd kill you last? I lied.","You are not sending me to the coolah...","Stop CHEEERING ME UP!","You are one ugly motherfucker...","Do it.","I'll be back.","Foget it, I'm nut goiing to sit on yo lap" ]    
    arnoldIMG  = ['http://s3-ec.buzzfed.com/static/enhanced/terminal05/2012/9/18/18/anigif_enhanced-buzz-12040-1348006909-1.gif','http://s3-ec.buzzfed.com/static/enhanced/web05/2012/9/18/14/anigif_enhanced-buzz-1597-1347992379-13.gif','http://s3-ec.buzzfed.com/static/enhanced/web05/2012/9/18/15/anigif_enhanced-buzz-11594-1347996346-0.gif','http://s3-ec.buzzfed.com/static/enhanced/web05/2012/9/18/18/anigif_enhanced-buzz-30295-1348006023-2.gif','http://s3-ec.buzzfed.com/static/enhanced/web04/2012/9/18/17/anigif_enhanced-buzz-6990-1348002721-21.gif','http://s3-ec.buzzfed.com/static/enhanced/web05/2012/9/18/17/anigif_enhanced-buzz-26908-1348003972-9.gif','http://s3-ec.buzzfed.com/static/enhanced/web05/2012/9/18/17/anigif_enhanced-buzz-26853-1348003850-7.gif','http://s3-ec.buzzfed.com/static/enhanced/web04/2012/9/18/18/anigif_enhanced-buzz-13635-1348008096-4.gif','http://s3-ec.buzzfed.com/static/enhanced/web03/2012/9/19/10/anigif_enhanced-buzz-10529-1348063943-15.gif','http://s3-ec.buzzfed.com/static/enhanced/web03/2012/9/19/10/anigif_enhanced-buzz-10529-1348063918-13.gif']
    thisArnold = 'ARNOLD -> ' + arnold[_.random(arnold.length - 1)]
    unless @_bail()
      if @_console.image and not color
        @_console.image arnoldIMG[_.random(arnoldIMG.length - 1)]
      else if _.isString color
        @_color color, thisArnold
      else
        @_console.log  thisArnold
    return thisArnold

window?.__ClogClass = Clog # for testing
window?.Clog        = new Clog()
module?.exports     = new Clog()