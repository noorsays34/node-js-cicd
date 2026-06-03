const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("Node.js App Running Successfully!");
});

const PORT = process.env.PORT || 3000;

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

module.exports = app;