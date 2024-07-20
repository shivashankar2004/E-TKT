const express = require('express');
const mongoose =require("mongoose")
const cors = require('cors');
const path = require('path');
const app = express();
const port = 3000;
const db=require("./database")

db();

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
