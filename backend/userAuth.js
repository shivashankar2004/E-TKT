const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const User = require('C:/Users/MK/Desktop/SPD/E-TKT/backend/models/userModel.js');

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());


const database = async () => {
    try {
        await mongoose.connect('mongodb+srv://SHIVA:hLdisadAM451XElF@cluster0.zlhka20.mongodb.net/eticket?retryWrites=true&w=majority&appName=Cluster0');
        console.log("Connected to Cloud");
        app.listen(5000, () => {
            console.log('Server is listening on port 5000');
        });
    } catch (error) {
        console.error("DB connection failed:", error);
    }
};


database();

app.post('/register', async (req, res) => {
    try {
        const { name, password } = req.body;


        const existingUser = await User.findOne({ name });
        if (existingUser) {
            console.log(existingUser);
            return res.status(400).json({ error: "The User Name is Taken" });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const data = await User.create({ name, password: hashedPassword });
        console.log('User Created:', data);
        return res.status(201).json(data);

    } catch (err) {
        console.error("Error handling /register route:", err);
        res.status(500).json({ error: err.message });
    }
});

app.get('/login', async (req, res) => {
    try {
        const { name, password } = req.body;

        const member = await User.findOne({ name });
        if (member) {

            const isMatch = await bcrypt.compare(password, member.password);
            if (isMatch) {
                return res.status(201).json({
                    Message: "Logged in to " + member.name
                });
            } else {
                return res.status(400).json({
                    Message: "Invalid Password"
                });
            }
        } else {
            return res.status(404).json({
                Message: "No User Named " + name
            });
        }
    } catch (error) {
        console.error("Error handling /login route:", error);
        res.status(500).json({ error: error.message });
    }
});