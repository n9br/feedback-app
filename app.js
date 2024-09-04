import express from 'express';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

// Creating the express app
const app = express();
const PORT = 3000;

// Middleware for parsing JSON
app.use(express.json());

// Determining directory and file location
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const feedbackFilePath = path.join(__dirname, 'feedback.json');

// Helper functions
const loadFeedback = async () => {
    try {
        const data = await fs.readFile(feedbackFilePath, 'utf-8');
        return JSON.parse(data);
    } catch (error) {
        return [];
    }   
}

const saveFeedback = async (feedback) => {
    await fs.writeFile(feedbackFilePath, JSON.stringify(feedback, null, 2));
}

app.post('/feedback', (req, res) => {
    const { title, text } = req.body;



});

app.get('/feedback', (req, res) => {

});

app.delete('/feedback', (req, res) => {

});


app.listen(PORT, ()=> {
    console.log(`Server laeuft auf http://localhost:${PORT}`);
});