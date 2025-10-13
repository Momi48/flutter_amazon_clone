const express = require('express')
const adminRouter = express.Router()
const admin = require("../middlewares/admin");
const { Product } = require('../models/product');
const auth = require('../middlewares/auth');
const Order = require('../models/order');

adminRouter.post('/api/add-products', admin, async (req, res) => {
  try {
    const { name, description, images, price, quantity, category } = req.body
    let product = new Product({
      name, description, images, price, quantity, category
    })
    product = await product.save()

    return res.status(200).json(product)
  } catch (e) {
    res.status(500).json({ error: e.message })
  }
})
//TODO: make the middleware auth -> admin
adminRouter.get('/admin/get-products', admin, async (req, res) => {

  try {
    const product = await Product.find({})
    console.log("admin product ", product)
    return res.json(product)
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }


})
adminRouter.delete('/admin/delete-products', admin, async (req, res) => {
  try {
    const { id } = req.body
    console.log("id is ", id)
    const productExist = await Product.findById(id)
    if (!productExist) return res.json({ message: "Product Dosen't Exist" })
    await Product.deleteOne({ _id: id })

    return res.json({ message: "Product Deleted" })
  } catch (e) {
    return res.status(500).json({ error: e.message });

  }
})

adminRouter.get('/admin/fetch-orders', admin, async (req, res) => {

  try {
    const order = await Order.find({})
    if (!order) return res.status(400).json({ message: "No Order Exist" })
    return res.json(order)
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }


})

adminRouter.post('/admin/update-status-orders', admin, async (req, res) => {

  try {
    const { status, id } = req.body
    let updatedOrder = await Order.findByIdAndUpdate(id, { status: status }, { new: true })
    if (!updatedOrder) return res.status(404).json({ message: "Order not found" })
    updatedOrder = await updatedOrder.save()
    return res.json(updatedOrder)
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }


})
adminRouter.get('/admin/analytics', admin, async (req, res) => {
  try {
    let totalEarnings = 0
    const order = await Order.find({})
    
    order.map((data) => {
      data.products.map((product) => {
        totalEarnings += product.product.quantity * product.product.price
        
      })
    })
     let mobileEarnings = await fetchCategoryWiseProduct("Mobiles");
    let essentialEarnings = await fetchCategoryWiseProduct("Essentials");
    let appliancesEarnings = await fetchCategoryWiseProduct("Appliances");
    let booksEarnings = await fetchCategoryWiseProduct("Books");
    let fashionEarnings = await fetchCategoryWiseProduct("Fashion");
   let earnings = {
    totalEarnings,
    mobileEarnings,
    essentialEarnings,
    appliancesEarnings,
    booksEarnings,
    fashionEarnings,
   }
   res.json(earnings)
    
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
})
//calculate specfic category
async function fetchCategoryWiseProduct(category){
  let earnings = 0
  const categoryOrder = await Order.find({"products.product.category": category})
  if(categoryOrder.length == 0) return  console.log("No Order Found")
  
  categoryOrder.map((data) =>{
    data.products.map((category) =>{
      earnings += category.product.price * category.product.quantity 
    })
  })
  return earnings
}
module.exports = adminRouter

