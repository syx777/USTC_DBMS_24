const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const mysql = require('mysql');
const fs = require('fs');
const path = require('path');
const multer = require('multer');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'sun20030707',
  database: 'SchoolManagementSystem',
  multipleStatements: true
});

db.connect((err) => {
  if (err) throw err;
  console.log('MySQL connected...');

  const schemaPath = path.join(__dirname, 'db', 'schema.sql');
  const schema = fs.readFileSync(schemaPath, 'utf-8');
  db.query(schema, (err, result) => {
    if (err) throw err;
    console.log('Database and tables created...');
  });
});

const storage = multer.memoryStorage();
const upload = multer({ storage });


app.get('/api/students', (req, res) => {
  console.log('Received request for /api/students');
  const sql = 'SELECT * FROM Students';
  db.query(sql, (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      res.status(500).json({ error: 'Database query error' });
      return;
    }
    const studentsWithPhoto = results.map(student => {
      if (student.photo) {
        student.photo = `data:image/jpeg;base64,${student.photo.toString('base64')}`;
      }
      return student;
    });

    res.json(studentsWithPhoto);
  });
});

// 添加学生
app.post('/api/students', upload.single('photo'), (req, res) => {
  const newStudent = req.body;
  const photoData = req.file ? req.file.buffer : null;

  const sql = 'INSERT INTO Students (student_id, name, gender, class, phone, photo) VALUES (?, ?, ?, ?, ?, ?)';
  db.query(sql, [newStudent.student_id, newStudent.name, newStudent.gender, newStudent.class, newStudent.phone, photoData], (err, result) => {
    if (err) {
      console.error('Error inserting student:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.status(201).json({ id: result.insertId, ...newStudent });
  });
});

// 更新学生
app.put('/api/students/:id', upload.single('photo'), (req, res) => {
  const updatedStudent = req.body;
  const photoData = req.file ? req.file.buffer : null;
  const sql = 'UPDATE Students SET name = ?, gender = ?, class = ?, phone = ?, photo=? WHERE student_id = ?';
  db.query(sql, [updatedStudent.name, updatedStudent.gender, updatedStudent.class,updatedStudent.phone,photoData, req.params.id], (err, result) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(result);
  });
});

// 删除学生
app.delete('/api/students/:id', (req, res) => {
  const sql = 'DELETE FROM Students WHERE student_id = ?';
  db.query(sql, [req.params.id], (err, result) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(result);
  });
});


const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
});
