var express = require('express');
var app = express();
var fs = require('fs');
var mongoose = require('mongoose')
  , Schema = mongoose.Schema;
var salt = "lsakjdlkjasf;ds"; // salted string
var SHA2 = new (require('jshashes').SHA512)();


db = mongoose.createConnection('localhost', 'testImages');
db.on('error', console.error.bind(console, 'connection error:'));
app.use(express.bodyParser({uploadDir:'./uploads'}));

var imageSchema = new Schema({
  name    : String,
  date     : Number
});

var userSchema = new Schema({
	user: String,
	pass: String,
	hash: String,
	date: Number
});

var uploadSchema = new Schema({
	user: String,
	kind: {
		type:String,
		enum: ['image', 'text', 'audio'],
		required: true
		},
	date: Number,
	dataLocation: String,
});

var imageModel = db.model('Image', imageSchema);
var userModel = db.model('User', userSchema);
var uploadModel = db.model('Upload', userSchema);


app.post('/login', function(req, res){
	
	console.log("Attempting login");
	//res.body.user and res.body.pass is what we're looking for
	return userModel.findOne({user: req.body.user, pass: req.body.pass},
		function(err,obj) { console.log(obj);
			if(obj == null)
			{
				//incorrect username or password
				console.log("Incorrect username or pass");
				res.send("Incorrect username or pass");
			}
			else
			{
				//correct details entered, initate login stuff
				console.log("Correct login details send");
				res.send(obj._id);
			}


		});
	
});

app.post('/register', function(req, res){
	return userModel.findOne({user: req.body.user},
		function(err,obj) { console.log(obj);
			if(obj == null) 
			{
				//user not found, safe to add new one
				t = new Date();
				nUser = new userModel(
				{
					user: req.body.user,
					pass: req.body.pass,
					date: t.getTime()
				});
				nUser.save(function (err)
				{
					if(err)
					{
						//problem creating the user
						console.log("Error creating user");
						res.send("Error added user to db");
					}
					else
					{

						console.log(req.body.user + " successfully added to db");
						res.send(req.body.user + " successfully added to db");
						
					}
				});
			}
			else
			{
				console.log(req.body.user + " already taken");
				res.send(req.body.user + " already taken");
			}});
});

app.post('/file',  function(req, res){
	// get the temporary location of the file
	var tmp_path = req.files.thumbnail.path;
	// set where the file should actually exists - in this case it is in the "images" directory
	var target_path = './uploads/final/' + req.files.thumbnail.name;
	// move the file from the temporary location to the intended location
	var images;
	console.log("POST: ");
	console.log(req.body);
	t = new Date();
	images = new imageModel(
	{
		name: req.files.thumbnail.name,
		date: t.getTime()
	});
	images.save(function (err)
	{
		if (!err)
		{
			return console.log("created");
		}
		else
		{
			return console.log(err);
		}
	});
	fs.rename(tmp_path, target_path,
	function(err)
	{
		if (err)
			console.log(err);
		// delete the temporary file, so that the explicitly set temporary upload dir does not get filled with unwanted files
		fs.unlink(tmp_path, function()
		{
			if (err)
				console.log(err);
			res.send('File uploaded to: ' + target_path + ' - ' + req.files.thumbnail.size + ' bytes');
		});
	});
	res.send("\n"+images);
});

app.get('/get/:id', function (req, res)
{
	return imageModel.findById(req.params.id, function (err, product)
	{
		if (!err)
		{
				return fs.readFile("./uploads/final/"+product.name, "binary", function(error, file)
				{
					if(error)
					{
						res.writeHead(500, {"Content-Type": "text/plain"});
						res.write(error + "\n");
						res.end();
					}
					else
					{
						res.writeHead(200, {"Content-Type": "image/png"});
						res.write(file, "binary");
					}
				});
		}
		else
		{
			return console.log("error - " + err);
		}
  	});
});

app.get('/all', function (req, res) {
imageModel.find({}, function (err, products) {
  if(err) {console.log("errror");} else {console.log("products = " + products);}
});
	res.send("here");
});


app.post('/upload/:userhash', function (req, res){
  var user;
  console.log("POST: ");
  console.log(req.body);
  user = new ProductModel({
    user: req.body.user,
    pass: req.body.pass
  });
  user.save(function (err) {
    if (!err) {
      return console.log("created");
    } else {
      return console.log(err);
    }
  });
  return res.send(user);
});


app.listen(8080);
console.log('listening on port 8080');
