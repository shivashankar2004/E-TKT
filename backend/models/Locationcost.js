// models/LocationCost.js
const mongoose = require('mongoose');

const LocationCostSchema = new mongoose.Schema({
    location1: {
        type: String,
        required: true
    },
    location2: {
        type: String,
        required: true
    },
    cost: {
        type: Number,
        required: true
    }
});

module.exports = mongoose.model('LocationCost', LocationCostSchema);
