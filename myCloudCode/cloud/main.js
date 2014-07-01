
//for new user setup- link new user with a venue
Parse.Cloud.define("linkVenue", function(request, response) {   
  Parse.Cloud.useMasterKey();
  console.log(request);
  var query = new Parse.Query("Venue");
  var emailStr = request.user.getEmail();
  var place = emailStr.split("@")[1].split(".")[0];
  var user = Parse.User.current();
  query.equalTo("place", place);

  var venueObj = 11;
  query.find().then(function(results) {
    	console.log("results: " + results);
    	if(results.length > 0){
    		venueObj = results[0];
	    	var userRelation = venueObj.relation("users");
	    	userRelation.add(user);
	    } else{ //if venue doesn"t exist then make a new one with a new "place" - in production remove this   
	    	var VenueClass = Parse.Object.extend("Venue");   
			venueObj = new VenueClass();

			var userRelation = venueObj.relation("users");
			userRelation.add(user);
			venueObj.set("place", place);
		}
		return venueObj.save();
	}).then(function(result) {
    	var venueRelation = user.relation("venue");
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

//for new user setup- delete second email account created while signup
Parse.Cloud.define("deleteUser", function(request, response){   
	Parse.Cloud.useMasterKey();
	var query = new Parse.Query(Parse.User);
	console.log("id: " + query);
	query.get("" + request.params.userID, {
		userMasterKey: true,
		success: function(result){
			result.destroy().then(function(result){
				response.success(1);
			}, function(error){
				response.error(error);
			});
		},
		error : function(error){

		}
	});
});



var sendPushToUserWithMessage = function(userId, message, success, error){
	sendPushWithChannelsAndMessage([userId], message, success, error);
}

var sendPushWithChannelsAndMessage = function(channels, message, success, error){
	Parse.Push.send({
	  channels: channels,
	  data: {
	    alert: message
	  }
	}).then(success,
	error);
}

//for new user setup- delete second email account created while signup
Parse.Cloud.define("acceptTask", function(request, response){   
	Parse.Cloud.useMasterKey();
	var taskId = request.params.taskId;


	//update task -> acceptor, status
	var taskQuery = new Parse.Query("Task");
	taskQuery.equalTo("objectId", taskId);
	taskObj = "";
	taskQuery.first().then(function(result){
		taskObj = result;
		//taskAcceptorRelation = taskObj.relation("acceptor");
		//taskAcceptorRelation.add(request.user);
		//return taskObj.save();
		taskObj.set('acceptor', request.user);
		return taskObj.save();
	}).then(function(result){
		var venue = taskObj.get("venue");
		 var query = new Parse.Query("Venue");
		 console.log(venue.id);
		 return query.get(venue.id);
		//var venueRelation = taskObj.relation("venue");
		//return venueRelation.query().find();
	}).then(function(result){
		console.log(result);
		var venueObj = result;
		var postedTasksRelation = venueObj.relation("tasks");
		postedTasksRelation.remove(taskObj);
		var acceptedTasksRelation = venueObj.relation("acceptedTasks");   
		acceptedTasksRelation.add(taskObj);
		return venueObj.save();
	}).then(function(result){
		sendPushToUserWithMessage("" + request.user.id, "accepted task!", function(result){
			response.success(1);
		}, function(error){
			response.error(error);
		});
	}, function(error){
		response.error(error);
	})


	//update venue -> move from regular to "accepted tasks"

	//update user -> accepted tasks
	//send push notification to task owner that their task has been accepted by __name__


});



