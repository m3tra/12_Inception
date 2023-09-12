const path = require("path");
const express = require("express");
const app = express();

app.use(express.static("/static-website"));

app.listen(4242, function() {
	console.log("Listening on port 4242...");
});
