<?php
// Archivo de conexión centralizado a MySQL mediante PDO
$host = 'localhost';
$dbname = 'db_cafeteria';
$username = 'root';
$password = '1234'; // Ajustar según las credenciales de tu XAMPP

try {
    $conexion = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conexion->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);

    echo "¡Conexión exitosa a la base de datos de la cafetería!";
} catch (PDOException $e) {
    die("Error crítico de conexión a la Base de Datos: " . $e->getMessage());
}
?>