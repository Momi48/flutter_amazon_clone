const express = require("express")
const auth = require("../middlewares/auth")
const { Product } = require("../models/product")
const User = require("../models/user")
const Order = require("../models/order")
const userRouter = express.Router()

userRouter.post('/api/add-to-cart', auth, async (req, res) => {

    try {
        const { id } = req.body

        const product = await Product.findById(id)



        let user = await User.findById(req.user)

        if (!user) return res.status(404).json({ error: "User not found" });
        if (!product) return res.status(404).json({ error: "Product not found" });


        let isProductFound = false
        //cart empty here 
        if (user.cart.length == 0) {
            user.cart.push({ product, quantity: 1 })
        }
        if (user.cart.length > 0) {

            //if that product exist we just want to increase or increment quantity
            for (let i = 0; i < user.cart.length; i++) {
                //product exist we dont want to loop again 
                if (user.cart[i].product.id == id) {
                    isProductFound = true
                }
            }
            if (isProductFound) {
                let foundProduct = user.cart.find((product) => product.product.id == id)

                foundProduct.quantity += 1
                console.log("Found ", user.cart)

            }
            else {
                user.cart.push({ product, quantity: 1 })
            }
            user = await user.save()
            return res.json(user)

        }
    }
    catch (e) {
        return res.status(500).json({ error: e.message })
    }


})
userRouter.delete('/api/remove-from-cart/:id', auth, async (req, res) => {

    try {
        const { id } = req.params

        const product = await Product.findById(id)
       
        let user = await User.findById(req.user)
          
        if (!user) return res.status(404).json({ error: "User not found" });
        if (!product) return res.status(404).json({ error: "Product not found" });
        for (let i = 0; i < user.cart.length; i++) {
            
                
            if (user.cart[i].product.id == id) {
                
                if (user.cart[i].quantity == 1) {
                    
                 user.cart.splice(i, 1)
                 break   
                   
                 }
                if(user.cart[i].quantity > 1) {
                   
               user.cart[i].quantity -= 1

                }
            }
        }
      
       user = await user.save()
         res.json(user)


    }
    catch (e) {
        return res.status(500).json({ error: e.message })
    }


})


userRouter.post("/api/save-user-address",auth,async(req,res) => {
    try {
       const {address} = req.body

       let user = await User.findById(req.user)
       if(!user) return res.status(500).json({message: "User Dosen't Exist"})
        user.address = address

       user = await user.save()
        return res.json(user)
    } 
    catch(e) {
    return res.status(500).json({error: e.message})
    }
})

userRouter.post("/api/order",auth,async(req,res) => {
    try {
       const {address,totalPrice,cart} = req.body
       let products = []
       
       for(let i =0;i<cart.length;i++){
         console.log("Product quantity ",cart[i].quantity)
         const product = await Product.findById(cart[i].product._id)
         
        if(product.quantity >= cart[i].quantity){
            product.quantity -= cart[i].quantity
            
            products.push({product,quantity:cart[i].quantity})
            
            await product.save()
        }
      else {
       res.status(400).json({message: `${products.name} is out of stock`}) 
      }  
    }
    //means the purchase is complete so we need to empty cart
      let user = await User.findById(req.user)
      user.cart = []
      user = await user.save()
     
      let order = new Order({
       products,
       totalPrice,
       address,
       orderedAt: new Date().getTime(),
       userId: req.user
      }) 
     order = await order.save()
     return res.json(order)
    } 
    catch(e) {
    return res.status(500).json({error: e.message})
    }
})

userRouter.get('/api/fetch-all-orders',auth,async(req,res) => {
    try {
        
        const order = await Order.find({ userId: req.user})
        console.log("Order ",order)
        if( order.length === 0) return res.status(404).json({ message: "No Order Has Been Placed" }); 
        
        console.log("Order ",order)
        return res.json(order)
    }
    catch(e){
      return res.status(500).json({error: e.message})  
    }
})
module.exports = userRouter