var mongoose = require('mongoose');
var Schema = mongoose.Schema;


db = mongoose.createConnection('localhost', 'testImages');
db.on('error', console.error.bind(console, 'connection error:'));


var imageSchema = new Schema({
  pitch        : Number,
  heading      : Number,
  dataLocation : String
});

var textSchema = new Schema({ text: String });
var audioSchema = new Schema({ dataLocation: String });

var userSchema = new Schema({
	user: String,
	pass: String,
	date: Number
});

var uploadSchema = new Schema({
	userID: String,
	kind: {
		type: String,
		enum: ['image', 'text', 'audio'],
		required: true
		},
	date: Number,
	data: Object,
	long: Number,
	lat:  Number,
	name: String
});



imageModel  = db.model('Image', imageSchema);
userModel   = db.model('User',  userSchema);
uploadModel = db.model('Upload', userSchema);
textModel   = db.model('Text',  textSchema);
audioModel  = db.model('Audio', audioSchema);

/*
 * dataLocation - Where the data is stored on the server/youtube/wherever
heading - The reading from the compass on the iPhone...Could be useful if we manage to show the data in 3D in Gamma
locationID - The location where the upload was tagged
pitch - Using the accelerometer to get the pitch of the iphone when a picture was taken
type - The type of media being taken
uploadID - A unique ID for the upload
userID - The unique ID of the user who uploaded the data item
*/