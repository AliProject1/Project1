const express = require("express");
const app = express();
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const bodyParser = require("body-parser");
const helmet = require('helmet');
const mongoSanitize = require("express-mongo-sanitize");
const xss = require("xss-clean");
const hpp = require("hpp");


dotenv.config();

// http headers security
app.use(helmet());

// Parsing data
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Data sanitization against NoSQL injection
app.use(mongoSanitize());

// Data sanitization against XSS
app.use(xss());

// Preventing HTTP parameter pollution
app.use(hpp());

// CORS
app.use(cors());

// Importing routes
const authRoute = require("./routes/authRoute");
const userRoute = require("./routes/userRoute");
const productRoute = require("./routes/productRoute");
const orderRoute = require("./routes/orderRoute");
const cartRoute = require("./routes/cartRoute");



// Routes
app.use("/api/auth", authRoute);
app.use("/api/user", userRoute);
app.use("/api/product", productRoute);
app.use("/api/order", orderRoute);
app.use("/api/cart", cartRoute);






// DB connection
mongoose.set('strictQuery', true);
mongoose.connect(process.env.DB, { useNewUrlParser: true });

// Server connection
const port = process.env.PORT || 3000;
app.listen(port, () => {
  
  console.log("Listening on port " + port);
});

