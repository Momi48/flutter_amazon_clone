const express = require("express")
const User = require("../models/user")
const authRouter = express.Router()
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const auth = require("../middlewares/auth");

authRouter.post('/api/sign-up', async (req, res,) => {
    const saltRounds = 10;


    try {
        const { name, email, password, } = req.body;


        const existUser = await User.findOne({ email })
         console.log("Exist User ",existUser)

        if (existUser) {


            return res.status(400).json({ msg: "User With Same Email Already Exist " },)
        }
        //method 1 which is mine and its so shit 
        // bcrypt.hash(password, saltRounds).then(async function (hash) {
        //     password = hash

        //     let user = new User({
        //         name,
        //         password,
        //         email,
        //     })
        //     console.log("User Data ", user)

        //     user = await user.save()

        //     return res.status(200).json(user)

        // });
        //method 2 which is from tutorial its easy to read 
        const hashedPassword = await bcrypt.hash(password, saltRounds)
        let user = new User({
            name,
            password: hashedPassword,
            email,
        })
        console.log('User in mongo ',user)
        user = await user.save()
        return res.status(200).json(user)

    } catch (e) {
        return res.status(500).json({ error: e.message })
    }
})

authRouter.post('/api/sign-in', async (req, res) => {

    const { email, password } = req.body;
  try {
        const userExist = await User.findOne({ email })
        //email dosent exist here in this condtion but i didnt write in json message because attacker can know whats wrong here 
        if (userExist == null) {
            return res.status(200).json({ message: "Invalid credentials” for both cases" });
        }
        
        const hashedPassowrd = await bcrypt.compare(password, userExist.password)
       



        
       
        if (userExist && hashedPassowrd == true) {
            
           const token = jwt.sign({id: userExist._id}, 'passwordKey');
            console.log("Token is ",token)
            
            return res.status(200).json({ token,...userExist._doc});
        }
        //same goes for this 
        else {
            return res.status(400).json({ message: "Invalid credentials” for both cases" });
        }
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }


})
authRouter.post("/api/tokenIsValid",async (req,res) =>{
    try {
       const token = req.header('x-auth-token')
         
      //if token dosent exist 
      if(!token) return res.json(false)
    //if token exist but we need to verify it
    const verified =  jwt.verify(token,'passwordKey')
    
     if(!verified) return res.json(false)
    //if token  is verified we want to check if user is valid or not
    //the token can be valid what if its just a random token that turns out to be correct 
    //so we want to check if that user exist or not
     
    //as we passed verified because we passed to token when jwt.sign in method 
    const user = await User.findById(verified.id)
     console.log("user in token valid api ",user) 
      if(!user) return res.json(false)
        
        return res.json(true)
    }catch(e){
    return res.json({error: e.message})
    }
})
authRouter.get("/api/getUserData",auth,async(req,res) => {
    try {
     const user = await User.findById(req.user)
     console.log("User here is ",user)
      return res.status(200).json({...user._doc,token: req.token})
    } 
    catch(e) {
    return res.status(500).json({error: e.message})
    }
})





module.exports = authRouter