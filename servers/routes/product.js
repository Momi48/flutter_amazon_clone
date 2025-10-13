const {Product} = require('../models/product');
const User = require('../models/user');
const express = require('express')
const productRouter = express.Router()
const auth = require("../middlewares/auth");

productRouter.get('/api/products', auth, async (req, res) => {
   try {
      console.log(req.query.category)
      const product = await Product.find({ category: req.query.category })
      res.json(product)
   } catch (e) {
      res.status(501).json({ error: e.message })
   }
})
productRouter.get('/api/search-products', auth, async (req, res) => {
   try {
      const products = await Product.find({
         name: { $regex: new RegExp(req.params.name), $options: "i" },
      });

      return res.json(products)
   }
   catch (e) {
      res.status(501).json({ error: e.message })
   }
})
productRouter.post("/api/rate-product", auth, async (req, res) => {
   try {
      const { id, rating } = req.body;
      const doubleVal = Number(rating)

      let product = await Product.findById(id);
      console.log("product is ", product)
      console.log("Rating is ", doubleVal)
      for (let i = 0; i < product.ratings.length; i++) {
         if (product.ratings[i].userId == req.user) {
            product.ratings.splice(i, 1);
            break;
         }


      }
      let ratingSchema = {
         userId: req.user,
         rating: doubleVal
      };

      if (doubleVal == Math.round(doubleVal)) {
         console.log('Double is ', doubleVal + 0.1)
         ratingSchema = {
            userId: req.user,
            rating: doubleVal + 0.1
         };

      }
      else {
         console.log('Int  is ', doubleVal)
         ratingSchema = {
            userId: req.user,
            rating: doubleVal
         };

      }
      product.ratings.push(ratingSchema);
      product = await product.save();
      return res.status(200).json(product);
      // const ratingSchema = {
      //    userId: req.user,
      //    rating
      // };

      // product.ratings.push(ratingSchema);
      // product = await product.save();

   } catch (e) {
      res.status(500).json({ error: e.message });
   }
});

productRouter.get('/api/deal-of-the-day', auth, async (req, res) => {

   try {
      const product = await Product.find({})
      let largest = product[0].ratings[0].rating
      let result = null
      let productData = null

      product.map((data) => {

         data.ratings.map((rating) => {

            if (largest < rating.rating) {
               largest = rating.rating
               result = largest
               productData = data

            }
            if (largest == rating.rating) {
               largest = rating.rating
               result = largest
               productData = data

            }

         })

      })

      if (result) {
         console.log(productData)
         return res.json(productData)
      }
   }
   catch (e) {
      console.log(e.message)
      res.status(500).json({ error: e.message });
   }

   //2nd method
   //  try {
   //     let products = await Product.find({});

   //     products = products.sort((a, b) => {
   //       let aSum = 0;
   //       let bSum = 0;

   //       for (let i = 0; i < a.ratings.length; i++) {
   //         aSum += a.ratings[i].rating;
   //       }

   //       for (let i = 0; i < b.ratings.length; i++) {
   //         bSum += b.ratings[i].rating;
   //       }
   //       return aSum < bSum ? 1 : -1;
   //     });

   //     res.json(products[0]);
   //   } catch (e) {
   //     res.status(500).json({ error: e.message });
   //   }


})
module.exports = productRouter