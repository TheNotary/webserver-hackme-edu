var http = require("http");
var qs = require('querystring');
var port = 3006;
var server = http.createServer(function(request, response) {

  if (request.url === "/correct" && request.method === "POST") {

    // get the text from the POST data
    var body = '';
    request.on('data', function (data) {
      body += data;
      if (body.length > 1e6) request.connection.destroy();
    });

    request.on('end', function () {
      response.writeHead(200, {"Content-Type": "application/json"});

      var post = qs.parse(body);
      var text = post['text'];
      var correct = text.replace( /\. +/g, ". ");

      var response_body = { body: correct, diff: null};
      response.write(JSON.stringify(response_body));
      response.end();
    });

  }
  else {
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.write("Hello World node!");
    response.write("Path requested was: " + request.url);
    response.end();
  }
});

server.listen(port);
console.log("Server is listening on " + port);
