from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import os

app = Flask(__name__)

DB_PATH = os.path.join(app.static_folder, 'instructions.db')

def get_db_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    if not os.path.exists(DB_PATH):
        with get_db_connection() as conn:
            c = conn.cursor()
            c.execute('''CREATE TABLE IF NOT EXISTS sections (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT UNIQUE NOT NULL)''')
            c.execute('''CREATE TABLE IF NOT EXISTS instructions (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        section_id INTEGER,
                        title TEXT NOT NULL,
                        content TEXT NOT NULL,
                        FOREIGN KEY (section_id) REFERENCES sections(id) ON DELETE CASCADE)''')
            conn.commit()

@app.route('/')
def index():
    with get_db_connection() as conn:
        sections = conn.execute("SELECT * FROM sections").fetchall()
    return render_template('index.html', sections=sections)

@app.route('/add_section', methods=['POST'])
def add_section():
    section_name = request.form['section_name']
    with get_db_connection() as conn:
        try:
            conn.execute("INSERT INTO sections (name) VALUES (?)", (section_name,))
            conn.commit()
        except sqlite3.IntegrityError:
            return "Ошибка: Раздел с таким именем уже существует."
    return redirect(url_for('index'))

@app.route('/edit_section/<int:section_id>', methods=['POST'])
def edit_section(section_id):
    new_name = request.form['new_name']
    with get_db_connection() as conn:
        try:
            conn.execute("UPDATE sections SET name = ? WHERE id = ?", (new_name, section_id))
            conn.commit()
        except sqlite3.IntegrityError:
            return "Ошибка: Раздел с этим именем уже существует."
    return redirect(url_for('index'))

@app.route('/delete_section/<int:section_id>', methods=['POST'])
def delete_section(section_id):
    with get_db_connection() as conn:
        conn.execute("DELETE FROM sections WHERE id = ?", (section_id,))
        conn.commit()
    return redirect(url_for('index'))

@app.route('/section/<int:section_id>')
def section(section_id):
    with get_db_connection() as conn:
        section = conn.execute("SELECT * FROM sections WHERE id=?", (section_id,)).fetchone()
        instructions = conn.execute("SELECT * FROM instructions WHERE section_id=?", (section_id,)).fetchall()
    if not section:
        return "Ошибка: Раздел не найден."
    return render_template('section.html', section=section, instructions=instructions)

@app.route('/add_instruction/<int:section_id>', methods=['POST'])
def add_instruction(section_id):
    title = request.form['title']
    content = request.form['content']
    with get_db_connection() as conn:
        try:
            conn.execute("INSERT INTO instructions (section_id, title, content) VALUES (?, ?, ?)",
                         (section_id, title, content))
            conn.commit()
        except sqlite3.Error:
            return "Ошибка: Не удалось добавить инструкцию."
    return redirect(url_for('section', section_id=section_id))

@app.route('/delete_instruction/<int:instruction_id>/<int:section_id>', methods=['POST'])
def delete_instruction(instruction_id, section_id):
    with get_db_connection() as conn:
        conn.execute("DELETE FROM instructions WHERE id = ?", (instruction_id,))
        conn.commit()
    return redirect(url_for('section', section_id=section_id))

@app.route('/edit_instruction/<int:instruction_id>', methods=['GET', 'POST'])
def edit_instruction(instruction_id):
    with get_db_connection() as conn:
        instruction = conn.execute("SELECT * FROM instructions WHERE id=?", (instruction_id,)).fetchone()
        if not instruction:
            return "Инструкция не найдена."

        if request.method == 'POST':
            title = request.form['title']
            content = request.form['content']
            conn.execute("UPDATE instructions SET title=?, content=? WHERE id=?",
                         (title, content, instruction_id))
            conn.commit()
            return redirect(url_for('section', section_id=instruction['section_id']))

    return render_template('edit_instruction.html', instruction=instruction)

if __name__ == '__main__':
    os.makedirs(app.static_folder, exist_ok=True)
    init_db()
    app.run(debug=True, host="0.0.0.0")
