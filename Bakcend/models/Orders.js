const mongoose = require("mongoose"); 

const orderSchema = new mongoose.Schema({
     
    userId:{
        type: String, 
        required : true
    },

    productID: {
        type : String ,
        required : true,
    },
     

    amount:{
        type: String ,
        default : "1"
    },

    rue :{
        type: String, 
        
    },

    mo3tamdia :{
        type: String, 
        
    },

    wileya :{
        type: String, 
        
    },

    code_postal :{
        type: String, 
        
    },

    phone :{
        type: String, 
        
    },

    nameUser :{
        type: String, 
        
    },

    lastName :{
        type: String, 
        
    },


    status:{
        type: String, 
        default : "pending",
    },

    namep:{
        type: String,   
    },
    pricep:{
        type: String, 
        
    },
    
    pphote:{  
        type: String,
    }
   
    
},

{timestamps:true}

);

module.exports = mongoose.model('Order' , orderSchema) ;