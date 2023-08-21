const router = require('express').Router() ; 
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const authController = require("../controllers/authController");



// --------------------------------------- REGISTER --------------------------------------------------- //
router.post('/register',upload.single('photo'),authController.userRegister );


// --------------------------------------- LOGIN --------------------------------------------------- //
router.post('/login',authController.userLogin);



module.exports = router;