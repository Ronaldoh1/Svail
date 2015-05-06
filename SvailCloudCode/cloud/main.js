require('cloud/app.js');

Parse.Cloud.define('sendSMS', function(request, response) {
      response.success("Hello world!");

    var accountSid = 'AC15e01d63ee41196ae0ea0b3c19a4d22c'; 
    var authToken = 'e767a9cbb965540a7a21d102cb1e9b9b'; 

    var toNumber = request.params.toNumber;
    var fromNumber = '+19252300512';
    var message = request.params.message;

    //require the Twilio module and create a REST client
//    var client = require('twilio')(accountSid, authToken);

    //Send an SMS text message

    Parse.Cloud.httpRequest({
        method: 'POST',
        url: 'https://' + accountSid + ':' + authToken + '@api.twilio.com/2010-04-01/Accounts/' + accountSid + '/Messages.json',
        body: {
            To: toNumber,
            From: fromNumber,
            Body: message
        }, 
        success: function(httpResponse) {
            console.log('Successfully sent sms.');
        },
        error: function(httpResponse) {
            console.error('Error sending sms: ' +
            JSON.stringify(httpResponse));
        }
    });
});


Parse.Cloud.define("processReferenceText", function(request, response) {

//    Parse.Cloud.useMasterKey()
    var fromNumber = request.params.fromNumber;
    var numberInMessage = request.params.message;

    var Reference = Parse.Object.extend("Reference");
    var User = Parse.Object.extend("User");
    var queryOfUser = new Parse.Query(User);
    queryOfUser.include("verification.references");
    queryOfUser.equalTo("phoneNumber", numberInMessage);

    queryOfUser.find().then(function(results) 
    {
         var userToVerify = results[0];
         var verification = userToVerify.get("verification");
         var references = verification.get("references");
         for (var i = 0; i < references.length; ++i) 
         {
            console.log(i);
            var reference = references[i];
            console.log(reference.get("fromPhoneNumber"));
            var fromPhoneNumber = reference.get("fromPhoneNumber");
            console.log(fromPhoneNumber);
            if (fromPhoneNumber ===  fromNumber) 
            {
                return Parse.Promise.error("Reference already exists");
            }

         }

         console.log("record not found");

         var reference = new Reference();
         reference.set("fromPhoneNumber",fromNumber);
         reference.set("userToVerify",userToVerify);
         verification.add("references",reference);

         return  verification.save();
    }, function(error) {
        return Parse.Promise.error("the phonenumber in message is not valid");
    })

})


Parse.Cloud.define("test", function(request, response) {
//    Parse.Cloud.run('processReferenceText',{fromNumber: '0123456789', message: '9253219260'},{          
//              success: function(results) {            
//
//                   console.log('to send');
//                   response.success(results);
//                }, error: function(results, error) {
//
//                   console.log('to fail');
//                  response.error("failed test");
//                }
//            });
//
    Parse.Cloud.run('processReferenceText',{fromNumber: '0123456789', message: '9253219260'}).then(function(){         

                    return Parse.Promise.as("Save successful");
                },function(error) {
                    return Parse.Promise.error("Save failed");
            })
 
})

Parse.Cloud.define("charge", function(request, response) {

    console.log("fuck");
    console.log("token: "+request.params.token);
    console.log("amount: "+request.params.amount);
    console.log("currency: "+request.params.currency);

    Stripe.Charges.create({
      amount: request.params.amount, // in cents
      currency: request.params.currency,
      name: "Ronald Hernandez",
	card: request.params.token
    },{
    success: function(results) {
      response.success(results);
    },
    error: function(httpResponse) {
      response.error(httpResponse);
    }
 });
});;


var stripe = require('stripe');
 stripe.initialize('sk_test_MmcKyzlkanhBHXzaLtbgOTVX');
Parse.Cloud.define("stripeCharge", function(request, response) {



var stripeToken = request.params.token;

  var charge = stripe.Charges.create({
  amount: request.params.amount * 100, // express dollars in cents 
  currency: 'usd',
  card: stripeToken
}).then(function(result) {
  console.log(result);
   response.success()

}, function(error){
response.error()});
  });



Parse.Cloud.define("applePayCharge", function(request, response) {



var stripeToken = request.params.token;

  var charge = stripe.Charges.create({
  amount: request.params.amount * 100, // express dollars in cents 
  currency: 'usd',
  card: stripeToken
}).then(function(result) {
  console.log(result);
   response.success()

}, function(error){
response.error()});

  });


Parse.Cloud.define("sendPushToUser", function(request, response) {
    var sender = request.user;
    var recipient = request.params.recipient;
    var message = request.params.message;

    // Validate that the sender is allowed to send to the recipient.
    // For example each user has an array of objectIds of friends
//    if (senderUser.get("friendIds").indexOf(recipientUserId) === -1) {
//        response.error("The recipient is not the sender's friend, cannot send push.");
//    }

    // Send the push.
    // Find devices associated with the recipient user
//    var recipientUser = new Parse.User();
//    recipientUser.id = recipientUserId;
    var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.equalTo("user", recipientUser);

    // Send the push notification to results of the query
    Parse.Push.send({
        where: pushQuery,
        data: {
            alert: message
        }
    }).then(function() {
        response.success("Push was sent successfully.")
    }, function(error) {
        response.error("Push failed to send with error: " + error.message);
    });
});
