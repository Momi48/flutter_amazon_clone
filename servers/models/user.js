const mongoose = require('mongoose');
const { productSchema, Product } = require('./product');

const userSchema = mongoose.Schema({
    name: {
        type: String,
        require: true,
        trim: true, 
    },
      email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a valid email address",
    },
  },
   password: {
    required: true,
    type: String,
  },
  address: {
    type: String,
    default: "",
  },
  // check if user is seller or admin 
  type: {
    type: String,
    default: "user",
  },
 cart: [
  {
    product: productSchema,
    quantity: {
      type: Number,
      required: true 
  
    },
  }
 ]
 
})
//create a collection with user name or create model 
const User = mongoose.model("Users", userSchema,)
module.exports = User