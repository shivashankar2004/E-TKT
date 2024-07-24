const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
const connectDB = require('./database');
const LocationCost = require('./models/Locationcost');

    const app = express();
    const port = 3000;

    connectDB();

    app.use(cors());
    app.use(express.urlencoded({ extended: true }));
    app.use(express.json());
    app.use(express.static(path.join(__dirname, 'public')));

app.get('/get_cost', async (req, res) => {
    const { location1, location2 } = req.query;

    if (!location1 || !location2) {
        return res.status(400).json({ error: 'Please provide both location1 and location2' });
    }

    try {
        const locationCost = await LocationCost.findOne({ location1, location2 });

        if (locationCost) {
            res.json({
                location1,
                location2,
                cost: locationCost.cost
            });
        } else {
            res.status(404).json({ error: 'Cost not found for the provided locations' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Server error' });
    }
});

app.listen(port, () => {
    console.log(`Location cost API is running at http://localhost:${port}`);
});
