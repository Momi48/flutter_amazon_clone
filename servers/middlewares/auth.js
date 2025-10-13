const jwt = require('jsonwebtoken');

const auth =  (req,res,next) => {
    try {
      
         
      const token   = req.header('x-auth-token')
     
       
      if(!token) return res.status(401).json({message: "No Auth Token, Access Denied"})
      
      const verified =  jwt.verify(token,'passwordKey')
      
       
      if(!verified) return res.status(401).json({message: "Token Verification Failed. Authorization Failed"})
       
        //these are used for passing data
        req.user = verified.id 
        req.token= token
        console.log("req user ",req.user)
        next()
    } 
    catch(e)
    {
        return res.status(500).json({error: e.message})
    }
}
module.exports = auth