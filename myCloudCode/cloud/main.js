
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("linkVenue", function(request, response) {   
  Parse.Cloud.useMasterKey();
  console.log(request);
  var query = new Parse.Query("Venue");
  var emailStr = request.user.getEmail();
  var place = emailStr.split('@')[1].split('.')[0];
  var user = Parse.User.current();
  query.equalTo("place", place);

  var venueObj = 11;
  query.find().then(function(results) {
    	console.log('results: ' + results);
    	if(results.length > 0){
    		venueObj = results[0];
	    	var userRelation = venueObj.relation('users');
	    	userRelation.add(user);
	    } else{
	    	var VenueClass = Parse.Object.extend("Venue");   
			venueObj = new VenueClass();

			var userRelation = venueObj.relation('users');
			userRelation.add(user);
			venueObj.set('place', place);
		}
		return venueObj.save();
	}).then(function(result) {
    	var venueRelation = user.relation('venue');
    	console.log(venueObj);
    	venueRelation.add(venueObj);
    	return user.save();
  	}).then(function(result){
  		response.success(1);
  	}, function(error){
  		console.log(error);
  		response.error(error);
  	});
});
