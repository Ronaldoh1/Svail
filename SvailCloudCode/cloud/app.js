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
   var referencerText = req.query.Body;
   var strArray  = referencerText.split('+');
   var queryUser =  new Parse.Query('User');
   queryUser.equalTo('phoneNumber', strArray[0]);
   queryUser.find({
       success: function(results) 
       {
           // results is an array of Parse.Object.
           result = results[0];
           console.log(result['name']);
       },
       error: function(error) 
       {
           // error is an instance of Parse.Error.
       }
   });
   
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
    var userNumber =  '+19253219260';
    messageToUser = 'One of your Svail references just texted Svail about you.';

    Parse.Cloud.run("sendSMS",{toNumber: userNumber, message: messageToUser},{          
              success: function(results) {            

                   console.log('to send');
                }, error: function(results, error) {

                   console.log('to fail');
                }
            });

 });

// Attach the Express app to Cloud Code.
app.listen();
