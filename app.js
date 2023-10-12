const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Ola, Docker fans, from Juvenile! From dev branch');
});

app.listen(port, () => {
  console.log(`App is running on port ${port}`);
});
