const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
 
  email: {
    type: String,
    required: true,
    unique: true
  },
  username: {
    type: String,
    required: true,

  },
  password: {
    type: String,
    required: true
  },
  isAdmin: {
    type: Boolean,
    default: false
  },
  
 
  photo: {
    type: String,
    default: ""
  },
 

  myProducts: {
    type: [String]
  }

});


module.exports = mongoose.model("User", userSchema);
