const mongoose = require("mongoose");

const productSchema = new mongoose.Schema({
 
  sellerId: {
    type: String,
   
  },

  nomProduit: {
    type: String,
    required: true,

  },

  description :{
    type: String,
  },

  prixProduitAfter: {
    type: String,
    required: true
  },

  prixProduitBefore: {
    type: String,
  },
 
  photoProduitPrincipale: {
    type: String,
    default: ""
  },
 
 
});


module.exports = mongoose.model("Product", productSchema);
