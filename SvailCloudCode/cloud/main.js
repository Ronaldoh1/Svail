require('cloud/app.js');

Parse.Cloud.define('sendSMS', function(request, response) {
      response.success("Hello world!");

    var accountSid = 'AC15e01d63ee41196ae0ea0b3c19a4d22c'; 
    var authToken = 'e767a9cbb965540a7a21d102cb1e9b9b'; 

    var toNumber = request.params.toNumber;
    var fromNumber = '+19252300512';
    var message = request.params.message;
    console.log('fuck');

    //require the Twilio module and create a REST client
    var client = require('twilio')(accountSid, authToken);

    //Send an SMS text message
    client.sendSms
    ({

     //   to:'+19253219260', // Any number Twilio can deliver to
     //   from: '+19252300512', // A number you bought from Twilio and can use for outbound communication
     //   body: 'test' // body of the SMS message
        to: toNumber, // Any number Twilio can deliver to
        from: fromNumber, // A number you bought from Twilio and can use for outbound communication
        body: message // body of the SMS message
    }, function(err, responseData) 
    { //this function is executed when a response is received from Twilio

//        if (!err) { // "err" is an error received during the request, if any
//            console.log(responseData.from); // outputs "+14506667788"
//            console.log(responseData.body); // outputs "word to your mother."

 //       }
//        if (err) { // "err" is an error received during the request, if any
//            console.log(error); // outputs "+14506667788"
//        }
    });
});





//// Include Cloud Code module dependencies
//var express = require('express'),
//    twilio = require('twilio');
//     
//     // Create an Express web app (more info: http://expressjs.com/)
//     var app = express();
//      
//      // Create a route that will respond to am HTTP GET request with some
//      // simple TwiML instructions
//      app.get('/hello', function(request, response) {
//          // Create a TwiML response generator object
//              var twiml = new twilio.TwimlResponse();
//               
//                   // add some instructions
//                       twiml.say('Hello there! Isn\'t Parse cool?', {
//                               voice:'woman'
//                                   });
//                      console.log("Received a new text: " + request.Url);
//                                    
//                                        // Render the TwiML XML document
//                                            response.type('text/xml');
//                                                response.send(twiml.toString());
//                                                });
//                                                 
//                                                 // Start the Express app
//                                                 app.listen();
