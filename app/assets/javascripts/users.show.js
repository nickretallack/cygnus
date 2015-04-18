layout = {
	topRow: {
		children: {
			avatar: {
			},
			description: {
				css: {
					alignSelf: "center"
				}
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