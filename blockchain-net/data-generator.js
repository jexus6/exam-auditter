const axios = require("axios");
const url = "http://localhost:4000/channels/mychannel/chaincodes/test_cc";
let pk = null;
const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1Njg2NTIwNjgsInVzZXJuYW1lIjoidGVzdF91c2VyIiwib3JnTmFtZSI6Ik9yZzEiLCJpYXQiOjE1Njg2MTYwNjh9.g9NZnhY3G2MHub9I8iH17npWONcZKHcUiUk7Cnifbkw"
let conf = {
	headers: {
		Authorization: `Bearer ${token}`,
		"Content-Type": "application/json"
	}
};


const createPostData = async (pk, data) => {
	return {
		fcn: "CreateSampleData",
		peers: ["peer0.udima.example.com", "peer0.ministerio.example.com"],
		chaincodeName: "test_cc",
		channelName: "mychannel",
		args: [JSON.stringify(data), pk]
	}
}



