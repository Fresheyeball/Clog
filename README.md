Clog
====

Clog your console for fun and profit! 

This is a simple logging library written to address 
the common tasks first and provide sugar. It is Chrome browser oriented
but works with node.js as well. 

Clog is written in CoffeeScript, but you can use it in JavaScript with 
no problems. The examples below will be in CoffeeScript however.

---

## Installation

Clog is available on npm as `clogjs` (as `clog` has already been
taken by a vastly inferior library).

```
// package.json
{
  "devDependencies" : {
    "clogjs" : "*"
  }
}
```

or you can simply include the file in your browser like so:

```
<script type="text/javascript" src="/path/to/lodash.js"></script>
<script type="text/javascript" src="/path/to/console.image.js"></script>
<script type="text/javascript" src="/path/to/Clog.js"></script>
```

[Lodash](http://lodash.com/) is required for Clog to work in the browser. 
[Console.image](https://github.com/adriancooney/console.image) is not
required, but is STRONGLY recommend to receive fun and profit.

---

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

### Now and Since

For measuring time of code execution you can use `Clog.now()` and `Clog.since()` like so:

```
Clog.now()
$.getJSON '/slowness.json', (data) ->
  Clog.since()
```

This is just candy wrapping `console.time` (the little known native time measurement console
feature). You can optionally name you measurement `Clog.now('ajax delay')`, otherwise it will
default to `'tardis'` as the label.

---

### Test

Have you written console logs to determine the value of variables? Do they look like this:

```
  var foo = 5, bar = 60;
  console.log 'foo', foo, 'bar', bar
  // or 
  console.log 'foo '+foo, 'bar '+bar
```

---

### Game Over

If you Clog out more than 2000 logs Clog will log out a `'GAME OVER'` message like below:
![GAMEOVER](https://i.chzbgr.com/maxW500/7780675840/h4A8F373B/)
and then die to prevent your browser from crashing.