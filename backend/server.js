const express = require('express');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const cors = require('cors');
const path = require('path');
const LocationCost = require('./models/Locationcost');
const cookieParser = require('cookie-parser');
const User = require('./models/userModel.js');
const Admin = require('./models/admin.js'); // Import admin model

const app = express()
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
app.use(cors());
app.use(express.static(path.join(__dirname, 'public')));
const JWT_SECRET = "spd";



const port = 5555;


const database = async () => {
    try {
        await mongoose.connect('mongodb+srv://SHIVA:hLdisadAM451XElF@cluster0.zlhka20.mongodb.net/eticket?retryWrites=true&w=majority&appName=Cluster0');
        console.log("Connected to Cloud");
        app.listen(port,() => {
            console.log('Server is listening on port '+port);
        });
    } catch (error) {
        console.error("DB connection failed:", error);
    }
};

database();

// const authenticateToken = (req, res, next) => {
//     const token = req.cookies.token
//     if (!token) {
//         return res.status(401).json({ message: "Log in before booking" });
//     }
//     jwt.verify(token, JWT_SECRET, (err, user) => {
//         if (err) {
//             return res.status(403).json({ message: "Invalid token" });
//         }
//         req.user = user;

//         next();

//     });
// };

// User Registration Route
app.post('/register', async (req, res) => {
    try {
        const { name, password, ticket } = req.body;
        const existingUser = await User.findOne({ name });
        if (existingUser) {
            return res.status(400).json({ error: "The User Name is Taken" });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser = await User.create({ name, password: hashedPassword, ticket });

        console.log(newUser);
        
        res.status(201).json(newUser);
        
    } catch (err) {
        console.error("Error handling /register route:", err);
        res.status(500).json({ error: err.message });
    }
});

// User Login Route
app.post('/login', async (req, res) => {
    try {
        const { name, password } = req.body;

        const member = await User.findOne({ name });

        if (!member) {
            return res.status(404).json({ message: "No User Named " + name });
        }

        const isMatch = await bcrypt.compare(password, member.password);
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid Password" });
        }

        const accessToken = jwt.sign({ name: member.name }, JWT_SECRET, { expiresIn: '1h' });



        
        
        return res.status(200).json({
            status : true,
            token: accessToken
        });


    } catch (error) {
        console.error("Error handling /login route:", error);
        res.status(500).json({ error: error.message });
    }
});


app.post('/admin-register', async (req, res) => {
    try {
        const { name, password } = req.body;

        // Check if admin with the same name already exists
        const existingAdmin = await Admin.findOne({ name });
        if (existingAdmin) {
            return res.status(400).json({ error: "Admin name is already taken" });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create new admin
        const newAdmin = await Admin.create({ name, password: hashedPassword });

        console.log(newAdmin);
        res.status(201).json(newAdmin);

    } catch (err) {
        console.error("Error handling /admin/register route:", err);
        res.status(500).json({ error: err.message });
    }
});


// Admin Login Route
app.post('/admin-login', async (req, res) => {
    try {
        const { name, password } = req.body;

        const admin = await Admin.findOne({ name });
        const check = req.cookies.token;
        if (check) {
            jwt.verify(check, JWT_SECRET, (err, adminData) => {
                if (err) {
                    return res.status(403).json({ message: "Invalid token" });
                }
                req.admin = adminData;
            });
            if (name === req.admin.name) {
                return res.json({ message: name + " is already logged in as Admin" });
            } else {
                return res.json({ message: "Logout " + req.admin.name + " before logging into " + name });
            }
        }

        if (!admin) {
            return res.status(404).json({ message: "No Admin Named " + name });
        }

        const isMatch = await bcrypt.compare(password, admin.password);
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid Password" });
        }

        const accessToken = jwt.sign({ name: admin.name }, JWT_SECRET, { expiresIn: '1h' });
        res.cookie('token', accessToken, { httpOnly: true, secure: true, maxAge: 3600000 });
        return res.status(200).json({ message: "Logged in as Admin " + admin.name, token: accessToken });

    } catch (error) {
        console.error("Error handling /admin-login route:", error);
        res.status(500).json({ error: error.message });
    }
});

// Book Ticket Route
app.put('/book', async (req, res) => {
    try {
        const { location1, location2, cost, name } = req.body;

        if (!location1 || !location2 || !cost || !name) {
            return res.status(400).json({ error: 'Please provide all required fields: location1, location2, cost, and name.' });
        }

        const user = await User.findOne({ name });
        
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        user.ticket = {
            loc1: location1,
            loc2: location2,
            cost: cost
        };

        await user.save();


        return res.status(200).json({ message: 'Ticket information updated successfully' });
    } catch (err) {
        console.error("Error handling /book route:", err);
        return res.status(500).json({ error: err.message });
    }
});


app.post('/test',async(req,res) =>{
    try{    
    const {location1,location2} = req.body;

        const locdet = await LocationCost.findOne({location1,location2});

        return res.status(200).json(
            {
                status:true,
                cost : locdet.cost
            }
        )
    
    }
    catch(err){
        console.log(err);
    }
});

app.post('/ticket', async (req, res) => {
    try {
        const { name } = req.body;
        

        // Find the user by name
        const user = await User.findOne({ name });

        
        if (!user) {
            console.log("No User");
        }

        // Check if the user has a ticket and loc1 is not empty
        if (user.ticket && user.ticket.loc1 !== "") {
            return res.status(200).json({
                status: true,
                ticket: user.ticket
            });
        } else {
            // If loc1 is empty, return 204 (No Content)
            return res.status(204).json({
                status: false,
                message: 'No ticket available'
            });
        }
    } catch (err) {
        console.log(err.message);
        // Return 500 (Internal Server Error) in case of any server-side error
        return res.status(500).json({
            status: false,
            message: 'Server error'
        });
    }
});

