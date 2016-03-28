#!/usr/bin/env node

var express = require('express')
var path = require('path')
var app = express()

app.use(express.static(path.join(__dirname, 'public')));
try {
  app.listen(3000)
  console.log('Applize testing website is running on port 3000 now')
} catch(e) {
  console.log(e.stack)
}
