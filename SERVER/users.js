require('./database');
var salt = "lsakjdlkjasf;ds"; // salted string
SHA2 = new (require('jshashes').SHA512)();

var checkHashF = function checkHash(uid, hash){
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
	
exports.checkHash = checkHashF;

exports.registerUser = function(req, res){
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
			}});};
			
exports.login = function(req, res)
{
	console.log("Attempting login");
	console.log(req.body);
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
};

exports.runTest = 
function(req, res)
{
    res.send(req.params.id);
    return checkHashF(req.params.id, "ssad");
};