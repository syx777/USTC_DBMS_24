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
  if (err) {
    console.error('Error connecting to MySQL:', err);
    process.exit(1);
  }
  console.log('MySQL connected...');

  const schemaPath = path.join(__dirname, 'db', 'schema.sql');
  const schema = fs.readFileSync(schemaPath, 'utf-8');
  db.query(schema, (err, result) => {
    if (err) {
      console.error('Error creating database and tables:', err);
      process.exit(1);
    }
    console.log('Database and tables created...');
  });
});

// 配置 multer 用于保存文件到服务器
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});

const upload = multer({ storage });

// 确保上传目录存在
const uploadDir = path.join(__dirname, 'uploads');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// 获取所有学生信息
app.get('/api/students', (req, res) => {
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

app.get('/api/students/search', (req, res) => {
  const { student_id, name, gender, class: className } = req.query;
  let sql = 'SELECT * FROM Students WHERE 1=1';
  const params = [];

  if (student_id) {
    sql += ' AND student_id = ?';
    params.push(student_id);
  }

  if (name) {
    sql += ' AND name LIKE ?';
    params.push(`%${name}%`);
  }
  if (gender) {
    sql += ' AND gender = ?';
    params.push(gender);
  }

  if (className) {
    sql += ' AND class = ?';
    params.push(className);
  }

  db.query(sql, params, (err, results) => {
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

  const sql = 'CALL AddStudent (?, ?, ?, ?, ?, ?)';
  db.query(sql, [newStudent.student_id, newStudent.name, newStudent.gender, newStudent.class, newStudent.phone, photoPath], (err, result) => {
    if (err) {
      console.error('Error inserting student:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.status(201).json({ id: result.insertId, ...newStudent, photo: photoPath });
  });
});

// 更新学生信息
app.put('/api/students/:id', upload.single('photo'), (req, res) => {
  const updatedStudent = req.body;
  const photoPath = req.file ? req.file.path : null;

  const sql = 'UPDATE Students SET name = ?, gender = ?, class = ?, phone = ?, photo = ? WHERE student_id = ?';
  db.query(sql, [updatedStudent.name, updatedStudent.gender, updatedStudent.class, updatedStudent.phone, photoPath, req.params.id], (err, result) => {
    if (err) {
      console.error('Error updating student:', err);
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
      console.error('Error deleting student:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(result);
  });
});

//获取所有班级信息
app.get('/api/classes', (req, res) => {
  const sql = 'SELECT * FROM Class';
  db.query(sql, (err, result) => {
    if (err) {
      console.error('Database query error:', err);
      res.status(500).json({ error: 'Database query error' });
      return;
    }
    return res.json(result);
  });
});

//添加班级
app.post('/api/classes', (req, res) => {
  const newClass = req.body;
  const sql = 'INSERT INTO Class (class_id, major,grade) VALUES (?, ?,?)';
  db.query(sql, [newClass.class_id, newClass.major, newClass.grade], (err, result) => {
    if (err) {
      console.error('Error inserting class:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.status(201).json({ id: result.insertId, ...newClass });
  });
});

//更新班级信息
app.put('/api/classes/:id', (req, res) => {
  const updatedClass = req.body;
  const sql = 'UPDATE Class SET major = ?, grade = ? WHERE class_id = ?';
  db.query(sql, [updatedClass.major, updatedClass.grade, req.params.id], (err, result) => {
    if (err) {
      console.error('Error updating class:', err);
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(result);
  });
});
// 启动服务器并提供静态文件服务
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
});
app.get('/api/classes/search', (req, res) => {
  const { class_id, major, grade} = req.query;
  let sql = 'SELECT * FROM Class WHERE 1=1';
  const params = [];

  if (class_id) {
    sql += ' AND class_id = ?';
    params.push(class_id);
  }

  if (major) {
    sql += ' AND major LIKE ?';
    params.push(`%${major}%`);
  }
  if (grade) {
    sql += ' AND grade = ?';
    params.push(grade);
  }
  return db.query(sql, params, (err, result) => {
    if (err) {
      console.error('Database query error:', err);
      res.status(500).json({ error: 'Database query error' });
      return;
    }
    return res.json(result);
  });

});
