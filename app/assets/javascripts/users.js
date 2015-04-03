function ready(){
	showPrices = function(){
		if(checkbox.prop("checked")) prices.show();
		else prices.hide();
	};
	checkbox = $("#user_commissions");
	prices = $("#prices");
	showPrices();
	$("#user_commissions").change(function(){
		showPrices();
	});

	$(".col-md-6").detach().children("form").appendTo($(".row"));

	$("#flexbox").css({
		"display": "flex",
		"justify-content": "space-around",
		"margin": "2% 5%"
	});

	$("#left").css({
		"flex": "1 0 auto"
	});

	showPicture = function(file){
		reader = new FileReader();
		reader.onload = function(event){
			avatar = $("#avatar_img");
			avatar.attr("src", event.target.result);
			$("#hide_avatar").html($("<input />", {
		        type: "button",
		        id: "hide_avatar_button",
		        value: "Hide Avatar"
		    }));
		    $("#hide_avatar_button").click(function(){
		    	if(avatar.is(":visible")){
		    		$("#hide_avatar_button").attr("value", "Show Avatar");
		    		avatar.hide();
		    	}else{
		    		$("#hide_avatar_button").attr("value", "Hide Avatar");
		    		avatar.show();
		    	}
		    });
		}
		reader.readAsDataURL(file.files[0]);
	}

	$(".uploader").change(function(){ showPicture(this); });
}

$(document).ready(ready);
$(document).on('page:load', ready);