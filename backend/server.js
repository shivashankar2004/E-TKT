const express = require('express');
const mongoose =require("mongoose")
const cors = require('cors');
const path = require('path');
const app = express();
const port = 3000;

const database=module.exports=()=>{
    const connectionParams={
        useNewUrlParser:true,
        useUnifiedTopology:true,
    }
    try{
        mongoose.connect('mongodb+srv://SHIVA:hLdisadAM451XElF@cluster0.zlhka20.mongodb.net/eticket?retryWrites=true&w=majority&appName=Cluster0',connectionParams)
        console.log("sdb connected");
    }catch(error){
        console.log(error)
        console.log("db connection failed")
    }
}
database()
app.use(cors());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

app.get('/get_cost', (req, res) => {
    const location1 = req.query.location1;
    const location2 = req.query.location2;

    if (!location1 || !location2) {
        return res.status(400).json({ error: 'Please provide both location1 and location2' });
    }
    const averageCost = 30;
    const cost = averageCost + 4;

    res.json({
        location1,
        location2,
        cost: cost.toFixed(2)
    });
});

app.listen(port, () => {
    console.log(`Location cost API is running at http://localhost:${port}`);
});
