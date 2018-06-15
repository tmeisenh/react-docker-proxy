const express = require('express');
const bodyParser = require('body-parser')
const path = require('path');
const app = express();

const port = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, 'build')));

app.get('/ping', function (req, res) {
   return res.send('pong');
});

app.get('/', function (req, res) {
    res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

app.listen(port);

console.log('express is serving on port: ', port);
