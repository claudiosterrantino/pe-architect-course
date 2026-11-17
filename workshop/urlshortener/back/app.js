const createError = require("http-errors");
const express = require("express");
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
const cors = require("cors");

const indexRouter = require("./routes/index");
const urlRouter = require("./routes/urls")

const app = express();

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));
app.use(cors());

app.use("/", indexRouter);
app.use("/urls", urlRouter);


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.send(err);
});

console.log('BEGIN BUILD TABLE');
buildtable();

async function buildtable() {
  // BEGIN The following section of code will create the database table IF NECESSARY
  const { Client } = require('./utils/getClient');

  // "route" is the shortened URL; "url" is the long (where it goes) URL
  console.log('table will be created now...');
  //const client = getClient();
  const client = await Client();
  const createTableQuery = `CREATE TABLE IF NOT EXISTS routes (route varchar PRIMARY KEY NOT NULL, url varchar, date TIMESTAMP NOT NULL DEFAULT current_timestamp)`;

  const res = await client.query(createTableQuery);
  console.log('Created table.');
  // END
};

module.exports = app;
