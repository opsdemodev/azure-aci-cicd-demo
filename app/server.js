const http = require("http");

const PORT = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, {
      "Content-Type": "application/json"
    });

    res.end(JSON.stringify({
      status: "healthy",
      application: "Azure ACI CI/CD Demo"
    }));

    return;
  }

  res.writeHead(200, {
    "Content-Type": "text/html"
  });

  res.end(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>Azure ACI CI/CD Demo</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 100px;
          }

          h1 {
            color: #0078d4;
          }
        </style>
      </head>

      <body>
        <h1>Azure ACI CI/CD Demo</h1>

        <p>
          Node.js application running on
          <strong>Azure Container Instances</strong>
        </p>

        <p>
          Deployment:
          GitHub Actions / Jenkins
        </p>

        <p>
          Registry:
          Azure Container Registry
        </p>
      </body>
    </html>
  `);
});

server.listen(PORT, () => {
  console.log(`Application running on port ${PORT}`);
});
