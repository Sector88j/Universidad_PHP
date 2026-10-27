<?php
session_start();
require_once 'conexion.php';

$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $usuario_input = trim($_POST['nombre_usuario'] ?? '');
    $password_input = trim($_POST['contrasena'] ?? '');

    if (!empty($usuario_input) && !empty($password_input)) {
        $sql = "SELECT u.id_usuario, u.nombre_completo, u.nombre_usuario, u.contrasena, u.id_rol, r.nombre_rol 
                FROM usuarios u 
                INNER JOIN roles r ON u.id_rol = r.id_rol 
                WHERE u.nombre_usuario = :usuario 
                LIMIT 1";
        
        $stmt = $conexion->prepare($sql);
        $stmt->execute([':usuario' => $usuario_input]);
        $user = $stmt->fetch();

        if ($user && password_verify($password_input, $user['contrasena'])) {
            $_SESSION['id_usuario'] = $user['id_usuario'];
            $_SESSION['nombre_completo'] = $user['nombre_completo'];
            $_SESSION['nombre_usuario'] = $user['nombre_usuario'];
            $_SESSION['id_rol'] = $user['id_rol'];
            $_SESSION['nombre_rol'] = $user['nombre_rol'];

            header('Location: dashboard.php');
            exit();
        } else {
            $error = 'Usuario o contraseña incorrectos.';
        }
    } else {
        $error = 'Por favor complete todos los campos.';
    }
}
?>