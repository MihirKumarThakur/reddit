// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require posts.js


$(document).ready(function(){

	$(".post_vote").on('click', function(event){

		if(current_user_name)
		{
			event.preventDefault();

			var attr = $(this).attr('style');
			
			// if a link is alread clicked (Vote up or down is pressed), then ajax should modify only that 
			// link color. else mark the current clicked link silver and its sibling color as white
			if (attr) 
			{
				var id = $(this).attr('id');
				$('#'+id).removeAttr('style');
			}
			else
			{
				$(this).siblings().css("background-color","");
		 		$(this).css("background-color","silver");
			}


			var pid = $("#post_vote_value_section").data('postid');
			
			// code to update the total vote count
			$.ajax({
				url: '/post_vote/value_up',
				type: 'POST',
				data: {post_vote_value: $(this).attr('value'), post_id: pid},
				success: function(response){
					$("#post_vote_value").text(response.post_vote_value);

				},
			});
		}
		else
		{
			var url = "/login";    
			$(location).attr('href',url);	
		}
	});



		$(".comment_vote").on('click', function(event){
			if(current_user_name)
			{
				event.preventDefault();
				var comment_attr = $(this).attr('class')[0];
				console.log(comment_attr);
				var cid = $($(this)[0]).attr('class').split(' ')[0];
				console.log(cid);
			// code to update the total vote count
			$.ajax({
				url: '/comment_vote/value_up',
				type: 'POST',
				data: {comment_vote_value: $(this).attr('value'), comment_id: cid},
				success: function(response){
					
					$("#comment_vote_value_"+cid).text(response.comment_vote_value);
					console.log(cid);

				},
			}); // end of ajax

			} //end if if(current_user_name)
			else
			{
				var url = "/login";    
				$(location).attr('href',url);	
			} // end of ifelse(current_user_name)

		});

}); //end of document ready
