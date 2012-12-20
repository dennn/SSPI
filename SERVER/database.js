var mongoose = require('mongoose');
var Schema = mongoose.Schema;


db = mongoose.createConnection('localhost', 'testImages');
db.on('error', console.error.bind(console, 'connection error:'));


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

imageModel = db.model('Image', imageSchema);
userModel = db.model('User', userSchema);
uploadModel = db.model('Upload', userSchema);