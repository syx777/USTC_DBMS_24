import mysql.connector

def read_file(filename):
    with open(filename, 'rb') as file:
        binary_data = file.read()
    return binary_data

def add_student(student_id, name, gender, class_, phone, photo_path):
    # 连接到数据库
    conn = mysql.connector.connect(
        host='localhost',
        user='your_username',
        password='your_password',
        database='your_database'
    )
    cursor = conn.cursor()
    
    # 读取文件内容
    photo = read_file(photo_path)
    
    # 调用存储过程
    cursor.callproc('AddStudent', (student_id, name, gender, class_, phone, photo))
    
    # 提交事务
    conn.commit()
    
    # 关闭连接
    cursor.close()
    conn.close()

# 示例调用
add_student('PB21111001', 'Tom', 'M', 'CS001', '19337353643', 'exp1.jpg')
add_student('PB21111002', 'Jerry', 'F', 'Ma002', '18934372238', 'exp2.jpg')
