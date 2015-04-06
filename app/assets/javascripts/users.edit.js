function ready(){
	if(!Modernizr.flexbox) return;

	commissions = $("#commissions");
	commissionsCheckbox = commissions.children(":checkbox");
	commissionsLabel = commissions.children("label");
	price = $("#price");
	price.insertAfter(commissionsLabel);

	showPrice = function(){
		if(commissionsCheckbox.prop("checked")) price.show();
		else price.hide();
	};

	showPrice();
	commissionsCheckbox.change(function(){
		showPrice();
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
		    })
		    .click(function(){
		    	if(avatar.is(":visible")){
		    		$("#hide_avatar_button").attr("value", "Show Avatar");
		    		avatar.hide();
		    	}else{
		    		$("#hide_avatar_button").attr("value", "Hide Avatar");
		    		avatar.show();
		    	}
		    }));
		}
		reader.readAsDataURL(file.files[0]);
	}

	$(".uploader").change(function(){ showPicture(this); });
}

$(document).ready(ready);
$(document).on('page:load', ready);