var fs = require('fs');

exports.upload = function(req, res){
	// get the temporary location of the file
	console.log(checkHash(12345, "hello"));
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
};

/*

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
*/