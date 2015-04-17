// These two lines are required to initialize Express in Cloud Code.
 express = require('express');
 app = express();

// Global app configuration section
app.set('views', 'cloud/views');  // Specify the folder to find templates
app.set('view engine', 'ejs');    // Set the template engine
app.use(express.bodyParser());    // Middleware for reading request body

// Example reading from the request query string of an HTTP get request.
 app.get('/receiveSMS', function(req, res) {
   // GET http://example.parseapp.com/test?message=hello
//   res.send(req.query.Body);
   console.log(req.query.Body);
   var toNumber = req.query.From;
   var text = req.query.Body;
   var strs  = text.split('+');
    Parse.Cloud.run("sendSMS",{toNumber: toNumber, message: 'Thanks!'},{          
              success: function(results) {            

                   console.log('to send');
                }, error: function(results, error) {

                   console.log('to fail');
                }
            });
 });

// Attach the Express app to Cloud Code.
app.listen();
