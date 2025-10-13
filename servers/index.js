const express = require("express")
const mongoose = require("mongoose")
const authRouter = require("./routes/auth")
const adminRouter = require("./routes/admin")
const productRouter = require("./routes/product")
const userRouter = require("./routes/user")
const DB = "mongodb+srv://mozi:mozi@cluster0.ee0lyyk.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

const app = express()

app.use(express.json())
app.set("trust proxy",true)
app.use(express.urlencoded({ extended: true }))
app.use(authRouter,adminRouter,productRouter,userRouter)
mongoose.connect(DB).then((_) =>{
    console.log("Mongosse  Connected ")
})
app.listen(8000,(error) => {
 if(error) return console.log("Error ",error)
 else 
    console.log("Server Started ")
});