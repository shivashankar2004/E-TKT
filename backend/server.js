const express = require('express');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const cors = require('cors');
const path = require('path');
const LocationCost = require('./models/Locationcost');
const cookieParser = require('cookie-parser');
const User = require('./models/userModel.js');

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
app.use(cors());
app.use(express.static(path.join(__dirname, 'public')));
const JWT_SECRET = "spd";





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

const authenticateToken = (req, res, next) => {
    const token = req.cookies.token
    if (!token) {
        return res.status(401).json({ message: "Log in before booking" });
    }
    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) {
            return res.status(403).json({ message: "Invalid token" });
        }
        req.user = user;

        next();

    });
};

app.post('/register', async (req, res) => {
    try {
        const { name, password, ticket } = req.body;

        const existingUser = await User.findOne({ name });
        if (existingUser) {
            return res.status(400).json({ error: "The User Name is Taken" });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const data = await User.create({ name, password: hashedPassword, ticket });
        console.log( res.status(201).json(data));
        

    } catch (err) {
        console.error("Error handling /register route:", err);
        res.status(500).json({ error: err.message });
    }
});

app.post('/login', async (req, res) => {
    try {
        const { name, password } = req.body;

        const member = await User.findOne({ name });
        const check = req.cookies.token;
        if (check) {
            jwt.verify(check, JWT_SECRET, (err, user) => {
                if (err) {
                    return res.status(403).json({ message: "Invalid token" });
                }
                req.user = user;
            })
            if (name === req.user.name) {
                return res.json({
                    message: name + " is already logged in"
                })
            }
            else {
                return res.json({
                    message: "Logout " + req.user.name + " before logging into " + name
                })
            }
        }
        if (!member) {
            return res.status(404).json({
                message: "No User Named " + name
            });
        }

        const isMatch = await bcrypt.compare(password, member.password);
        if (!isMatch) {
            return res.status(400).json({
                message: "Invalid Password"
            });
        }

        const accessToken = jwt.sign({ name: member.name }, JWT_SECRET, { expiresIn: '1h' });
        res.cookie('token', accessToken, {
            httpOnly: true,
            secure: true,
            maxAge: 3600000
        });
        return res.status(200).json({
            message: "Logged in too " + member.name,
            token: accessToken
        });


    } catch (error) {
        console.error("Error handling /login route:", error);
        res.status(500).json({ error: error.message });
    }
});

app.put('/book', authenticateToken, async (req, res) => {
    try {
        const { name } = req.user;
        const update = await User.findOne({ name });
        if (!update) {
            return res.status(404).json({ error: "User not found" });
        }
        const { location1, location2 } = req.body;
        if (!location1 || !location2) {
            return res.status(400).json({ error: 'Please provide both location1 and location2' });
        }
        const locationCost = await LocationCost.findOne({ location1, location2 });
        if (locationCost) {
            update.ticket = {
                loc1:locationCost.location1,
                loc2:locationCost.location2,
                cost:locationCost.cost
            };
            const upuser = await update.save();

            return res.status(200).json(upuser);

        } else {
            res.status(404).json({ error: 'Cost not found for the provided locations' });
        }

    }
    catch (err) {
        console.error("Error handling /book route:", err);
        res.status(500).json({ error: err.message });
    }
});
app.post('/logout', authenticateToken, async (req, res) => {
    res.clearCookie('token', { httpOnly: true, secure: true });
    return res.status(200).json({ message: "Logged out " + req.user.name + "successfully" });
});
