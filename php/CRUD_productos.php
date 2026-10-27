<?php
session_start();
require_once 'conexion.php';

if (!isset($_SESSION['id_usuario'])) {
    header('Location: login.php');
    exit();
}

// CREAR PRODUCTO
if (isset($_POST['accion']) && $_POST['accion'] === 'crear') {
    $nombre = trim($_POST['nombre_producto']);
    $descripcion = trim($_POST['descripcion']);
    $precio = floatval($_POST['precio']);
    $id_categoria = intval($_POST['id_categoria']);
    $fotografia = 'default.png';

    if (isset($_FILES['fotografia']) && $_FILES['fotografia']['error'] === 0) {
        $ext = pathinfo($_FILES['fotografia']['name'], PATHINFO_EXTENSION);
        $fotografia = uniqid() . '.' . $ext;
        if (!is_dir('uploads')) {
            mkdir('uploads', 0755, true);
        }
        move_uploaded_file($_FILES['fotografia']['tmp_name'], 'uploads/' . $fotografia);
    }

    $sql = "INSERT INTO productos (nombre_producto, descripcion, fotografia, precio, id_categoria) 
            VALUES (:nombre, :descripcion, :foto, :precio, :id_cat)";
    $stmt = $conexion->prepare($sql);
    $stmt->execute([
        ':nombre' => $nombre,
        ':descripcion' => $descripcion,
        ':foto' => $fotografia,
        ':precio' => $precio,
        ':id_cat' => $id_categoria
    ]);

    header('Location: CRUD_productos.php');
    exit();
}

// OBTENER LISTADO DE PRODUCTOS
$sql = "SELECT p.*, c.nombre_categoria 
        FROM productos p 
        INNER JOIN categorias c ON p.id_categoria = c.id_categoria 
        ORDER BY p.id_producto DESC";
$productos = $conexion->query($sql)->fetchAll();
?>