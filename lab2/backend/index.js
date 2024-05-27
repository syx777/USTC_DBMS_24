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

// 设置 multer 存储配置
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});

const upload = multer({ storage });

// 创建上传目录（如果不存在）
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

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
        student.photo = `http://localhost:3001/${student.photo}`;
      }
      return student;
    });

    res.json(studentsWithPhoto);
  });
});

// 添加学生
app.post('/api/students', upload.single('photo'), (req, res) => {
  const newStudent = req.body;
  const photoPath = req.file ? req.file.path : null;

  const sql = 'INSERT INTO Students (student_id, name, gender, class, phone, photo) VALUES (?, ?, ?, ?, ?, ?)';
  db.query(sql, [newStudent.student_id, newStudent.name, newStudent.gender, newStudent.class, newStudent.phone, photoPath], (err, result) => {
    if (err) {
      console.error('Error inserting student:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.status(201).json({ id: result.insertId, ...newStudent, photo: photoPath });
  });
});

// 更新学生
app.put('/api/students/:id', upload.single('photo'), (req, res) => {
  const updatedStudent = req.body;
  const photoPath = req.file ? req.file.path : updatedStudent.photo;

  const sql = 'UPDATE Students SET name = ?, gender = ?, major = ?, photo = ? WHERE student_id = ?';
  db.query(sql, [updatedStudent.name, updatedStudent.gender, updatedStudent.major, photoPath, req.params.id], (err, result) => {
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

// 提供静态文件服务
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
});
