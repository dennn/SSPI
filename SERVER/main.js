var express = require('express');
var app = express();
app.use(express.bodyParser({uploadDir:'./uploads'}));
var salt = "lsakjdlkjasf;ds"; // salted string
SHA2 = new (require('jshashes').SHA512)();

checkHash = function checkHash(uid, hash){
	userModel.findById(uid, function(err, docs)
	{
	  if(err)
	  {
	    console.log("uid doesn't exist");
	    return false;
	  }
	  else
	  {
	    t = new Date();
	    timeStamp = t.getTime().toString();
	    timeStamp = parseInt(timeStamp.substring(0, timeStamp.length-2));
	    //hash format is sha2(Salt+timeStamp+Password)
	    if(SHA2.b64_hmac(salt + timeStamp + docs.password, "") == hash)
	      return true;
	    else
	      return false;
	  }
	});
};

//file includes, must be done after checkHash Function

user = require('./users');
uploadHandler = require('./fileHandler');



app.post('/login', user.login);
app.post('/register', user.registerUser);
app.get('/test/:id', user.runTest);
app.post('/file', uploadHandler.upload);



app.listen(8080);
console.log('listening on port 8080');
