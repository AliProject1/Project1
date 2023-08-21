const Cart = require("../models/Carts");

// create cart 
const createProduct = async (req, res) => {
    const { userId, productId } = req.body;
  
    try {
      let userCart = await Cart.findOne({ userId });
  
      if (!userCart) {
        // If the user doesn't have a cart, create a new one
        userCart = new Cart({ userId, productIds: [productId] });
      } else {
        // If the user already has a cart, add the new product ID to the cart's productIds array
        userCart.productIds.push(productId);
      }
  
      const savedCart = await userCart.save();
  
      res.status(200).json(savedCart);
    } catch (err) {
      res.status(400).json(err);
    }
  };
  

// update cart 
const updateCart = async(req,res)=>{
    try{
        const updatedCart = await Cart.findByIdAndUpdate(req.params.id, {$set : req.body}, {new: true});
        res.status(200).json(updatedCart); 

    }catch(err){
        res.status(400).json(err); 

    }
}


//get cart 
const getUserCart = async (req, res) => {
    try {
      const userCart = await Cart.findOne({ userId: req.params.userId }).select("productIds");
      res.status(200).json(userCart);
    } catch (err) {
      res.status(400).json(err);
    }
  };
  



// delete product from cart
const deleteProductFromCart = async (req, res) => {
  const { userId, productId } = req.body;

  try {
    const userCart = await Cart.findOne({ userId });

    if (!userCart) {
      return res.status(404).json({ message: "User cart not found" });
    }

    // Remove the productId from the productIds array
    userCart.productIds = userCart.productIds.filter(id => id !== productId);

    const savedCart = await userCart.save();

    res.status(200).json(savedCart);
  } catch (err) {
    res.status(400).json(err);
  }
};



module.exports = {createProduct, updateCart,  getUserCart,deleteProductFromCart}