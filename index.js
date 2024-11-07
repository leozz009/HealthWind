const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');
const multer = require('multer'); // Importar multer
const path = require('path');
const fs = require('fs'); // Para manejar archivos

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());
app.use('/uploads', express.static('uploads')); // Servir archivos estáticos desde la carpeta 'uploads'

// Configurar la conexión a la base de datos Postgres
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'HealthWind',
  password: 'mello',
  port: 5433,
});

// Configuración de multer para subir imágenes
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Carpeta donde se guardarán las imágenes
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname)); // Nombre único para cada archivo
  }
});

const upload = multer({ storage: storage });

// Endpoint para crear un nuevo post con imagen
app.post('/posts', upload.single('imagen'), async (req, res) => {
  const { usuario_id, descripcion } = req.body;
  const imagen = req.file ? `/uploads/${req.file.filename}` : null; // Guardar la ruta de la imagen

  if (!usuario_id || !descripcion) {
    return res.status(400).json({ error: 'El ID del usuario y la descripción son requeridos' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO post (usuario_id, descripcion, imagen) VALUES ($1, $2, $3) RETURNING *',
      [usuario_id, descripcion, imagen]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al crear el post' });
  }
});


// Endpoint para el registro de usuarios
app.post('/signup', async (req, res) => {
    const { nombre, foto_perfil, correo, contraseña } = req.body;
  
    if (!nombre || !correo || !contraseña) {
      return res.status(400).json({ error: 'Faltan campos requeridos' });
    }
  
    try {
      const result = await pool.query(
        'INSERT INTO usuario (nombre, foto_perfil, correo, contraseña) VALUES ($1, $2, $3, $4) RETURNING *',
        [nombre, foto_perfil, correo, contraseña]
      );
      res.status(201).json(result.rows[0]);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Error al crear el usuario' });
    }
  });

// Endpoint para obtener todos los posts
app.get('/posts', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT post.*, usuario.nombre, usuario.foto_perfil 
      FROM post
      JOIN usuario ON post.usuario_id = usuario.id
      ORDER BY post.fecha DESC
    `);
    res.status(200).json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener los posts' });
  }
});



  // Endpoint para crear un nuevo post
app.post('/posts', async (req, res) => {
  const { usuario_id, descripcion, imagen } = req.body;

  if (!usuario_id || !descripcion) {
    return res.status(400).json({ error: 'El ID del usuario y la descripción son requeridos' });
  }

  try {
    const result = await pool.query(
      'INSERT INTO post (usuario_id, descripcion, imagen) VALUES ($1, $2, $3) RETURNING *',
      [usuario_id, descripcion, imagen]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al crear el post' });
  }
});

// Endpoint para el inicio de sesión
app.post('/login', async (req, res) => {
    const { correo, contraseña } = req.body;
  
    // Verificar que el correo y la contraseña estén presentes
    if (!correo || !contraseña) {
      return res.status(400).json({ error: 'Correo y contraseña son requeridos' });
    }
  
    try {
      // Buscar al usuario en la base de datos por su correo
      const result = await pool.query('SELECT * FROM usuario WHERE correo = $1', [correo]);
  
      // Si no se encuentra el usuario, devolver un mensaje de error
      if (result.rows.length === 0) {
        return res.status(400).json({ error: 'Correo o contraseña incorrectos' });
      }
  
      const usuario = result.rows[0];
  
      // Verificar si la contraseña ingresada coincide con la almacenada
      if (usuario.contraseña !== contraseña) {
        return res.status(400).json({ error: 'Correo o contraseña incorrectos' });
      }
  
      // Si la contraseña coincide, permitir el acceso al usuario
      return res.status(200).json({ message: 'Inicio de sesión exitoso', usuario });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: 'Error al iniciar sesión' });
    }
});


app.listen(port, () => {
  console.log(`API corriendo en http://localhost:${port}`);
});