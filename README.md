Clog
====

Clog your console for fun and profit!

[![Build Status](https://travis-ci.org/Fresheyeball/Clog.svg?branch=master)](https://travis-ci.org/Fresheyeball/Clog)

This is a simple logging library written to address
the common tasks first and provide sugar. It is Chrome browser oriented
but works with node.js as well.

Clog is written in CoffeeScript, but you can use it in JavaScript with
no problems. However, the examples below will be in CoffeeScript.

---

## Installation

Clog is available on npm as `clogjs` (as `clog` has already been
taken by a vastly inferior library).

```
// package.json or bower.json
{
  "devDependencies" : {
    "clogjs" : "*"
  }
}
```

or you can simply include the file in your browser like so:

```
<script type="text/javascript" src="/path/to/console.image.js"></script>
<script type="text/javascript" src="/path/to/Clog.js"></script>
```

[Console.image](https://github.com/adriancooney/console.image) is not
required, but is STRONGLY recommend to receive fun and profit.

---

``` http://fresheyeball.github.io/Clog/javascripts/Clog.js ```

## Things it do:

### Basics

```
  Clog.log 'howdy'
```
will log out `"0 ---> howdy"`. Clog keeps and internal index of logs, so most
logs will start with `"#{index} --->"`. `Clog.log` will also accept multiple arguments
just like `console.log`.

```
  Clog.info 'neat!'
  Clog.warn 'super neat!'
```

The above wraps `console.info` and `console.warn` in the same way that `Clog.log` wraps `console.log`.

---

### Colors

Clog provides easy access to colors! Simply call the colors like so

```
  Clog.red    "I'm red!"
  Clog.blue   "I'm blue!"
  Clog.green  "I'm green!"
  Clog.orange "I'm orange!"
  Clog.purple "I'm purple!"
```

and yes this works in Chrome and Nodejs. Prefer more brevity? you can also use each color
as the first three letters. For example you can call `Clog.purple` as `Clog.pur`.

Color commands will also `JSON.stringify` the first argument for you.

---

### Keanu

Its often necessary to write something simple to the console, in-order to just see if that line of code executes. Many write
something like:

```
  console.log 'woah'
```

with Clog, you can do abit better, with Keanu. `Clog.keanu()` does the same job as `console.log 'woah'`, but will instead
log out a random Keanu Reeves quote! If you have `console.image` installed you will get a small image of Keanu looking good in the matrix. There is also:

```
  // logs out either a quote or small image from the matrix
  Clog.keanu()

  // logs a nice big gif of Keanu
  Clog.keanu true

  // also colored keanus! all supported colors available
  Clog.keanu 'red'
```

---

### Arnold

With similar motivation to Keanu, sometimes you log something simple that you expect to log, and it doesn't. There is a bug in your code! So you leave that console message around and rejoice when you finally see it grace your terminal. Well here is where Arnold comes in. Instead of leaving yourself a message like `console.log 'success'` go big with `Clog.arnold()`. Arnold if you have `console.image` installed, you will be greeted with a random gif of
Arnold Schwarzenegger kicking ass, like you just kicked ass.

```
  // logs out either a quote or a big gif of ass kickery
  Clog.arnold()

  // also colored arnolds! all supported colors available
  Clog.arnold 'blue'
```


---

### Now and Since

For measuring time of code execution you can use `Clog.now()` and `Clog.since()` like so:

```
Clog.now()
$.getJSON '/slowness.json', (data) ->
  Clog.since()
```

This is just candy wrapping `console.time` (the little known native time measurement console
feature). You can optionally name your measurement `Clog.now('ajax delay')` (useful if you have more than one time measurement going on), otherwise it will default to `'tardis'` as the label.

---

### Test

Have you written console logs to determine the value of variables? Do they look like this:

```
  var foo = 5, bar = 60;
  console.log 'foo', foo, 'bar', bar
  // or
  console.log 'foo '+foo, 'bar '+bar
```

Its annoying to write extra code just to know the name of the variable you are logging.
With Clog you have:

```
  var foo = 5, bar = 60;
  Clog.test foo, bar
  // roughly equivalent to
  console.log
    foo : 5
    bar : 60
```

---

### Count

For easy logging out the number of times code has executed, simply call count like so:

```
  for [0...5]
    Clog.count 'simple loop'
  // will log out
  console.log 'simple loop -> 1 times'
  console.log 'simple loop -> 2 times'
  console.log 'simple loop -> 3 times'
  console.log 'simple loop -> 4 times'
  console.log 'simple loop -> 5 times'
  console.log 'simple loop -> 6 times'

```

---

### Game Over

If you Clog out more than 2000 logs Clog will log out a `'GAME OVER'` message like below:
![GAMEOVER](https://i.chzbgr.com/maxW500/7780675840/h4A8F373B/)
and then die to prevent your browser from crashing.

---

### Error Memes

This one is really only if you have `console.image`. There are some errors you can foresee as a developer. Ones that should stop everything until its fixed. Ones that are the result of you breaking things you know you should not break. When that happens its painful, so why not preemptively inject some levity into the situation? `Clog.meme` fires `console.image`'s `console.meme` functionality along with a native Error. If you are in an environment without `console.image` it just throws a native Error.
