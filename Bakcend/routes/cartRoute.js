const router = require("express").Router(); 
const cartController = require("../controllers/cartController"); 



// create cart 
router.post("/", cartController.createProduct); 

// update cart 

router.put("/:id",  cartController.updateCart); 


//get cart  for user

router.get("/find/:userId", cartController.getUserCart);

// delet prod from cart
router.delete("/",  cartController.deleteProductFromCart); 










module.exports= router ;