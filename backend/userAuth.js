const express = require('express');
const mongoose = require('mongoose');
const User = require('C:/Users/MK/Desktop/SPD/E-TKT/backend/modules/userModel.js');

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());


const database = () => {
    try {
        mongoose.connect('mongodb+srv://SHIVA:hLdisadAM451XElF@cluster0.zlhka20.mongodb.net/eticket?retryWrites=true&w=majority&appName=Cluster0')
        .then(console.log("Connected to Cloud"));
        app.listen(5000, () => {
            console.log('Server is Listening to 5000');
        })

    } catch (error) {
        console.log(error)
        console.log("db connection failed")
    }
}
database();

app.post('/register', async (req, res) => {
    try {
        const {name,password} = req.body;
        
        const existingUser = await User.findOne({name});
        if(existingUser){
            res.status(400).json({
                error:"The User Name is Taken"
            })
        }

        const data = await User.create({name,password});
        res.status(201).json(data); 
        console.log('User Created:', data._id);
    } catch (err) {
        console.error("Error saving user", err);
        res.status(500).json({ error: err.message });
    }
});