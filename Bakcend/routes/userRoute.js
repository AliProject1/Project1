const router = require("express").Router(); 

const userController = require("../controllers/userController"); 



// updating user info : works
router.put("/:id", userController.updateUser ); 
//deleting a user by id : works
router.delete("/:id", userController.deleteUser);
//get user by id  : worksa
router.get("/id/:id", userController.getUser);
//get all users  : works
router.get("/",  userController.getAllUsers);
//send newPass
router.post('/send-new-password', userController.sendNewPassword);






module.exports = router ; 