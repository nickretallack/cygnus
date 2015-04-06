layout = {
	topRow: {
		children: {
			avatar: {
				css: {
					flex: "1 0 auto"
				}
			},
			description: {
				
			}
		}
	},
	bottomRow: {
		css: {
			width: "100%",
			justifyContent: "flex-start"
		},
		children: {
			statuses: {
				css: {
					flexDirection: "column"
				}
			},
			info: {
				css: {
					flexDirection: "column",
					justifyContent: "flex-start",
					flex: "0 1 auto",
				},
				children: {
					offsiteGallery: {

					},
					prices: {
						css: {
							justifyContent: "space-between"
						}
					},
					since: {

					},
					last: {

					}
				}
			}
		}
	}
};