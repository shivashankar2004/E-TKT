const mongoose = require("mongoose")

const database = module.exports = async () => {
    try {
        await mongoose.connect('mongodb+srv://SHIVA:hLdisadAM451XElF@cluster0.zlhka20.mongodb.net/eticket?retryWrites=true&w=majority&appName=Cluster0')
        console.log("sdb connected");
    } catch (error) {
        console.log(error)
        console.log("db connection failed")
    }
}
