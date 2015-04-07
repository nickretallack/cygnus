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

	showPicture = function(file){
		reader = new FileReader();
		reader.onload = function(event){
			avatar = $("#avatar_img");
			avatar.attr("src", event.target.result);
		}
		reader.readAsDataURL(file.files[0]);
	}

	$(".uploader").change(function(){ showPicture(this); });
}

$(document).ready(ready);
$(document).on('page:load', ready);

layout = {
	form: {
		children: {
			box: {
				before: "#save-button",
				css: {
					display: "flex"
				},
				children: {
					left: {
						css: {
							flex: "3 0 auto",
							flexDirection: "column"
						}
					},
					right: {
						css: {
							flex: "1 1 auto",
							flexDirection: "column",
							maxWidth: "30%"
						}
					}
				}
			}
		}
	}
};