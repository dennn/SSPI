var express = require('express');
var app = express();
var fs = require('fs');
var mongoose = require('mongoose')
  , Schema = mongoose.Schema;
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
	hash: String
});

var uploadSchema = new Schema({
	user: String,
	kind: {
		type:String,
		enum: ['thumbnail', 'catalog', 'detail', 'zoom'],
		required: true
		},
	date: Number,
	url: String
});

var imageModel = db.model('Image', imageSchema);
var userModel = db.model('User', userSchema);
var uploadModel = db.model('Upload', userSchema);


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


app.post('/user/reg', function (req, res){
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

app.get('/login/:user/:pass', function(req, res)
{
	return imageModel.find({user: req.params.user, pass: req.params.pass}, function (err, product)
	{
		if(err)
		{
			console.log("invalid user data");
		}
		else
		{
			console.log(product);
		}
	});
});

app.listen(8080);
console.log('listening on port 8080');
