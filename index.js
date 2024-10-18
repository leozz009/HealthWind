const express = require('express');
const bodyParser = require('body-parser');
const { Pool } = require('pg');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());

// Configurar la conexión a la base de datos Postgres
const pool = new Pool({
  user: 'postgres', // tu usuario de Postgres
  host: 'localhost',
  database: 'HealthWind', // Nombre de la base de datos
  password: 'mello', // tu contraseña de Postgres
  port: 5433,
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