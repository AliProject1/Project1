
const bcrypt = require('bcryptjs');
const User = require("../models/userModel");
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const jwt = require("jsonwebtoken");
const cloudinary = require('cloudinary').v2;
var path = require('path');


cloudinary.config({ 
  cloud_name: 'dvfe83opu', 
  api_key: '739451239748159', 
  api_secret: 'wK3eLAFldGtQchf4Wtr-UAg1BYQ' 
});

const updateUser = async (req,res)=>{
  
  if(req.body.password){
    const salt = await bcrypt.genSalt(10);
      req.body.password = await bcrypt.hash(req.body.password,salt);
  }
  try{
      const updatedUser = await User.findByIdAndUpdate(req.params.id, {$set : req.body}, {new: true});
      res.status(200).json(updatedUser); 

  }catch(err){
      res.status(400).json(err); 
  }
}

// delete user by id 
const deleteUser = async (req, res)=>{
    try{
        await User.findByIdAndDelete(req.params.id);
        res.status(200).json("user has been deleted"); 

    }catch(err){
        res.status(400).json(err);
    }
}

// get user by id 
const getUser = async (req,res)=>{
    try{
        const user = await User.findById(req.params.id);
      res.status(200).json(user);


    }catch(err){
        res.status(400).json(err);
    }
}




//get all users
const getAllUsers = async (req,res)=>{
    try{
        const users = await User.find();
        res.status(200).json(users);
    }catch(err){
        res.status(400).json(err);
    }
}


async function generatePassword() {
  // Generate a random password with 8 characters
  const password = crypto.randomBytes(4).toString('hex');
  return password;
}

async function sendNewPassword(req, res) {
  // Generate a new password
  const password = await generatePassword();
  
  const salt = await bcrypt.genSalt(10);
  const hashedPassword = await bcrypt.hash(password, salt);
  
  const emailExist = await User.findOne({ email: req.body.email });
  if (!emailExist) {
    return res.status(400).json({ message: 'This email does not exist' });
  }

  const filter = { email: req.body.email };
  const update = { $set: { password: hashedPassword } };
  const options = { new: true };

  const updatedUser = await User.findOneAndUpdate(filter, update, options);

  var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: 'kaidigital3@gmail.com',
      pass: 'gwjddngeowzgihgk'
    }
  });

  var mailOptions = {
    from: 'projectdb65@gmail.com',
    to: req.body.email,
    subject: 'NEW PASSWORD',
    text: `Your new password is: ${password}`
  };

  transporter.sendMail(mailOptions, function (error) {
    if (error) {
      res.status(400).json(error);
    } else {
      res.status(200).json(updatedUser);
    }
  });
}











module.exports = {updateUser, deleteUser, getUser, getAllUsers, sendNewPassword}