const router = require('express').Router() ; 
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const productController = require("../controllers/productController");



// --------------------------------------- addProduct --------------------------------------------------- //
router.post('/addProduct',upload.single('photoProduitPrincipale'), productController.createProduct);

// --------------------------------------- getProductById --------------------------------------------------- //
router.get('/:id', productController.getProductById);

// --------------------------------------- deleteProduct --------------------------------------------------- //
router.delete('/', productController.deleteAllProducts);

// --------------------------------------- getAllProducts --------------------------------------------------- //
router.get('/', productController.getAllProducts);


// --------------------------------------- deleteProductById --------------------------------------------------- //
router.delete('/id/:id', productController.deleteProductById);



// --------------------------------------- UpdateProductById --------------------------------------------------- //
router.put('/:id', productController.updateProductById);


module.exports = router;