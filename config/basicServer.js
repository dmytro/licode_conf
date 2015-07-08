/*global require, __dirname, console*/
var express = require('express'),
    bodyParser = require('body-parser'),
    errorhandler = require('errorhandler'),
    morgan = require('morgan'),
    net = require('net'),
    N = require('./nuve'),
    fs = require("fs"),
    https = require("https"),
    httpProxy = require('http-proxy'),
    config = require('./../../licode_config');

//var options = {
//    key: fs.readFileSync('cert/key.pem').toString(),
//    cert: fs.readFileSync('cert/cert.pem').toString()
//};

var options = {
   // ca: fs.readFileSync("/opt/ssl_bundle.crt"),
    key: fs.readFileSync('/opt/keys/myserver.key'),
    cert: fs.readFileSync('/opt/keys/STAR_mentorstudents_org.crt'),
    ca: [ fs.readFileSync("/opt/keys/ssl_bundle.crt") ]
};

var app = express();

// app.configure ya no existe
"use strict";
app.use(errorhandler({
    dumpExceptions: true,
    showStack: true
}));
app.use(morgan('dev'));
app.use(express.static(__dirname + '/public'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: true
}));

//app.set('views', __dirname + '/../views/');
//disable layout
//app.set("view options", {layout: false});

N.API.init(config.nuve.superserviceID, config.nuve.superserviceKey, 'http://localhost:3000/');

var myRoom;

app.get('/easyMentor', function(req, res) {
	res.sendfile(__dirname + '/public/easyMentor.html');
});

app.get('/easyMentor2', function(req, res) {
	res.sendfile(__dirname + '/public/easyMentor2.html');
});

app.get('/easyModerator', function(req, res) {
	res.sendfile(__dirname + '/public/easyModerator.html');
});

app.get('/easyStudent', function(req, res) {
	res.sendfile(__dirname + '/public/easyStudent.html');
});

app.get('/mentor', function(req, res) {
	res.sendfile(__dirname + '/public/mentor.html');
});

app.get('/moderator', function(req, res) {
	res.sendfile(__dirname + '/public/moderator.html');
});

app.get('/student', function(req, res) {
	res.sendfile(__dirname + '/public/student.html');
});

app.get('/conf', function(req, res) {
	res.sendfile(__dirname + '/public/conf.html');
});

app.get('/deleteRoom', function(req, res) {
	res.sendfile(__dirname + '/public/deleteRoom.html');
});

app.get('/upload', function(req, res) {
	res.sendfile(__dirname + '/public/upload.html');
});

N.API.getRooms(function(roomlist) {
    "use strict";
    var rooms = JSON.parse(roomlist);
    console.log(rooms.length); //check and see if one of these rooms is 'basicExampleRoom'
    for (var room in rooms) {
        if (rooms[room].name === 'basicExampleRoom'){
            myRoom = rooms[room]._id;
        }
    }
    if (!myRoom) {

        N.API.createRoom('basicExampleRoom', function(roomID) {
            myRoom = roomID._id;
            console.log('Created room ', myRoom);
        });
    } else {
        console.log('Using room', myRoom);
    }
});


app.get('/getRooms/', function(req, res) {
    "use strict";
    N.API.getRooms(function(rooms) {
        res.send(rooms);
    });
});

app.get('/getUsers/:room', function(req, res) {
    "use strict";
    var room = req.params.room;
    N.API.getUsers(room, function(users) {
        res.send(users);
    });
});


app.post('/createToken/', function(req, res) {
    "use strict";
    var room = myRoom,
        username = req.body.username,
        role = req.body.role;
    N.API.createToken(room, username, role, function(token) {
        console.log(token);
        res.send(token);
    });
});


app.post('/createTokenRoom/', function (req, res) {
    console.log('Request for service createTokenRoom ');
	var newRoom,
    username	= req.body.username,
    role		= req.body.role;
    confId		= req.body.confId,
    console.log("Creating Room token CONFID="+ confId+" UNAME="+username+" ROLE="+ role);

	N.API.getRooms(function (roomlist) {
            "use strict";
            var rooms = JSON.parse(roomlist);
            console.log(" ROOMS--> "+rooms.length);
            //check and see if one of these rooms is 'myRoom'
            for (var i in rooms) {
                if (rooms[i].name === 'conf-'+confId) {
                    newRoom = rooms[i]._id;
                    console.log("Room already exists id= "+newRoom+" Name= "+rooms[i].name);
                }
            }
            if (!newRoom) {
                N.API.createRoom('conf-'+confId, function (roomID) {
                    newRoom = roomID._id;
                    console.log('Created room ', newRoom);
                    N.API.createToken(newRoom, username, role, function (token) {
                        console.log(token);
                        res.send(token);
                    });
                });
            } else {
                    console.log('Create token using room ', newRoom);
                    N.API.createToken(newRoom, username, role, function (token) {
                            console.log(token);
                            res.send(token);
                    });
            }
	}); 
});

app.use(function(req, res, next) {
    "use strict";
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS, DELETE');
    res.header('Access-Control-Allow-Headers', 'origin, content-type');
    if (req.method == 'OPTIONS') {
        res.send(200);
    } else {
        next();
    }
});



app.listen(3001);

var server = https.createServer(options, app);
server.listen(443);

var proxy = httpProxy.createServer({
    target: {
        host: 'localhost',
        port: 8080,
    },
    ws: true,
    ssl: options,
    secure: true
}).listen(3004);
proxy.on('error', function (e) {
    console.log('proxy error: ' + e);
});
