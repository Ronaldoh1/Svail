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
   var referencerNumber = req.query.From;
   var message = req.query.Body;
   var messageToReferencer = "Thanks for texting us about one of our users.Svail.";
   if (referencerNumber.indexOf(message) <= -1){
       Parse.Cloud.run("sendSMS",{toNumber: referencerNumber  , message: messageToReferencer});         
       Parse.Cloud.run('processReferenceText',{fromNumber:referencerNumber , message: message});         
   } else {
       console.log("Prevent self referencing");
   }




  
//   var replyToReferencer = 'Thanks for being a reference to ' + strArray[0];
//   console.log(replyToReferencer);
//    Parse.Cloud.run('sendSMS',{toNumber: referencerNumber, message: replyToReferencer},{          
//              success: function(results) {            

//                   console.log('to send');
//                }, error: function(results, error) {

//                   console.log('to fail');
//                }
//            });

//    var userNumber =  '+12405061982';
    
 });

// Attach the Express app to Cloud Code.
app.listen();
