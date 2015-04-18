layout = {
	topRow: {
		children: {
			avatar: {
			},

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
	},
	bottomRow: {
		css: {
			width: "100%",
			justifyContent: "flex-start"
		},
		children: {
			description: {
				css: {
					flexDirection: "column",
					justifyContent: "flex-start",
					flex: "0 1 auto",
				}
			}
		}
	}
};
