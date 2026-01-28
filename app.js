const express = require('express');
const app = express();

const port = process.env.PORT || 8000;

app.get('/', (req, res) => {
  res.send(`
    <h1>Hello from Node.js running on Azure App Service! Blue Environment🚀</h1>
    <p>This app was deployed using Azure Pipelines CI/CD</p>
    <p>Current time: ${new Date().toLocaleString()}</p>
  `);
});

app.listen(port, () => {
  console.log(`Server is running → http://localhost:${port}`);
});
