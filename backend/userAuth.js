const express = require('express');
const mongoose = require('mongoose');
const user = require('./modules/userModel');

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());


const database = () => {
    try {
        mongoose.connect('mongodb+srv://SHIVA:hLdisadAM451XElF@cluster0.zlhka20.mongodb.net/eticket?retryWrites=true&w=majority&appName=Cluster0')
        .then(console.log("sdb connected"));
        
    } catch (error) {
        console.log(error)
        console.log("db connection failed")
    }
}
database();
