const User = require('../models/userModel');
const bcrypt = require('bcryptjs');
var path = require('path');
const cloudinary = require('cloudinary').v2;
const nodemailer = require('nodemailer');

          
cloudinary.config({ 
  cloud_name: 'dhqqt1nju', 
  api_key: '825414438411693', 
  api_secret: 'Xz3HC1YaOrsSYHaBpGyFkn7hbZQ' 
});


const userRegister = async (req, res) => {
  try {
    const emailExist = await User.findOne({ email: req.body.email });
    if (emailExist) {
      return res.status(400).json({ message: 'This email already exists' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(req.body.password, salt);
    let result = '';
    if (req.file && req.file.path) {
      result = await cloudinary.uploader.upload(req.file.path);
    }

    const user = new User({
      email: req.body.email,
      password: hashedPassword,
      username: req.body.username,
      photo: result.secure_url || '',
    
    });
    new User(user).save();
    res.status(200).json({
      id: user._id,
      message: 'Registration successful',
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Error registering user' });
  }
};


 
 const userLogin = async (req, res) => {
  try {
    // checking email existence
    const user = await User.findOne({ email: req.body.email });
    if (!user) {
      throw new Error('Invalid email');
    }

    const validPass = await bcrypt.compare(req.body.password, user.password);
    if (!validPass) {
      throw new Error('Wrong password');
    }

   
    res.status(200).json({  id: user._id, message: 'Login successful' , data : user });
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};


 
 module.exports = { userLogin , userRegister}