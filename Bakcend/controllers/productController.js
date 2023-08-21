const Product = require('../models/productModel');
const cloudinary = require('cloudinary').v2;
const User = require("../models/userModel");

cloudinary.config({
  cloud_name: 'dhqqt1nju',
  api_key: '825414438411693',
  api_secret: 'Xz3HC1YaOrsSYHaBpGyFkn7hbZQ',
});
const path = require('path');
const createProduct = async (req, res) => {
  try {
    const product = new Product({
      sellerId: req.body.sellerId,
      nomProduit: req.body.nomProduit,
      prixProduitAfter: req.body.prixProduitAfter,
      prixProduitBefore: req.body.prixProduitBefore,
      photoProduitPrincipale: '',
      photosSecondaire: [],
      description: req.body.description,
    });

    let result = '';

    if (req.file && req.file.path) {
      result = await cloudinary.uploader.upload(req.file.path);
    }

    product.photoProduitPrincipale = result.secure_url || '';

    if (req.files && req.files.length > 0) {
      for (const file of req.files) {
        const photo = await cloudinary.uploader.upload(file.path);
        product.photosSecondaire.push(photo.secure_url);
      }
    }

    await product.save();

    // Update the user's myProducts array with the newly created product's ID
    const user = await User.findById(req.body.sellerId);
    if (user) {
      user.myProducts.push(product._id);
      await user.save();
    }

    res.status(200).json({
      sellerId: product.sellerId,
      id: product._id,
      message: 'Product created successfully',
    });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Error creating product' });
  }
};




const getProductById = async (req, res) => {
  try {
    const productId = req.params.id;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.status(200).json(product);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Error fetching product' });
  }
};


//delete product
const deleteAllProducts = async (req, res) => {
  try {
    await Product.deleteMany({});
    res.status(200).json({ message: 'All products deleted successfully' });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Error deleting products' });
  }
};


//get all products
const getAllProducts = async (req, res) => {
  try {
    const products = await Product.find({});
    res.status(200).json(products);
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Error fetching products' });
  }
};



const deleteProductById = async (req, res) => {
  try {
    const productId = req.params.id;

    // Find the product by ID
    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Delete the product from the database
    await Product.deleteOne({ _id: productId });

    // Remove the product ID from the user's myProducts array
    const user = await User.findById(product.sellerId);
    if (user) {
      user.myProducts = user.myProducts.filter(id => id.toString() !== productId);
      await user.save();
    }

    res.status(200).json({ message: 'Product deleted successfully' });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Error deleting product' });
  }
};


const updateProductById = async (req, res) => {
  try {
    const productId = req.params.id;

    // Find the product by ID
    const product = await Product.findById(productId);

    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Update the product's fields with new values from the request body
    product.nomProduit = req.body.nomProduit || product.nomProduit;
    product.prixProduitAfter = req.body.prixProduitAfter || product.prixProduitAfter;
    product.prixProduitBefore = req.body.prixProduitBefore || product.prixProduitBefore;
    product.description = req.body.description || product.description;

    // Save the updated product
    await product.save();

    res.status(200).json({ message: 'Product updated successfully', updatedProduct: product });
  } catch (err) {
    console.log(err);
    res.status(500).json({ message: 'Error updating product' });
  }
};



module.exports = { createProduct,getProductById,deleteAllProducts,getAllProducts,deleteProductById,updateProductById };
