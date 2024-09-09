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

const feedbackDirPath = path.join(__dirname, 'data');
const feedbackFilePath = path.join(feedbackDirPath, 'feedback.json');

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

// POST /feedback - fuegt neues Feedback hinzu
app.post('/feedback', async (req, res) => {
    const { title, text } = req.body;

    if (!title || !text ) {
        return res.status(400).json({ message: "title und text sind im body erforderlich." })
    }
    
    try {
        const feedback = await loadFeedback();
        feedback.push({ title, text });
        await saveFeedback(feedback);
        res.status(201).json({ message: "Toll!!! Feedback erfolgreich gespeichert."});
    } catch (error) {
        res.status(500).json({ message: "Fehler beim Speichern des Feedbacks." });
    }

});

app.get('/feedback', async (req, res) => {

    try {
        const feedback = await loadFeedback();
        res.status(200).json(feedback);

    } catch (error) {
        res.status(500).json({ message: "Fehler beim Abrufen des Feedbacks." });
    }

});

app.delete('/feedback/:title', async (req, res) => {
    const { title } = req.params;

    try {
        let feedback = await loadFeedback();
        const filteredFeedback = feedback.filter(fb => fb.title !== title);

        if (feedback.length === filteredFeedback.length ) {
            return res.status(404).json({ message: "Feedback nicht gefunden." });
        }

        await saveFeedback(filteredFeedback);
        res.status(200).json({ message: "Feedback erfolgreich geloescht." });

    } catch (error) {
        res.status(500).json({ message: "Fehler beim Loeschen des Feedbacks." });
    }

});


app.listen(PORT, ()=> {
    console.log(`Server laeuft auf http://localhost:${PORT}`);
});