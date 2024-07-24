const mongoose = require('mongoose');
const { Schema } = mongoose;

const ticketSchema = new Schema({
    loc1: {
        type: String,
        default: ''
    },
    loc2: {
        type: String,
        default: ''
    },
    cost: {
        type: Number,
        default: 0
    },
    issueDate: {
        type: Date,
        default: Date.now
    }
});

const userSchema = new Schema({
    name: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    ticket: {
        type: ticketSchema,
        default: {}
    }
});

module.exports = mongoose.model('User', userSchema);
