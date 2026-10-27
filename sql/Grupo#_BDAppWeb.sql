CREATE DATABASE IF NOT EXISTS db_cafeteria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE db_cafeteria;

-- 1. Tabla Roles
CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 2. Tabla Usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    id_rol INT NOT NULL,
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES roles(id_rol) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Tabla Categorias
CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 4. Tabla Productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    fotografia VARCHAR(255) DEFAULT 'default.png',
    precio DECIMAL(8,2) NOT NULL,
    estado_disponibilidad VARCHAR(20) DEFAULT 'Disponible',
    id_categoria INT NOT NULL,
    CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Tabla Mesas
CREATE TABLE mesas (
    id_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numero_mesa INT(3) NOT NULL UNIQUE,
    estado_mesa VARCHAR(20) DEFAULT 'Libre'
) ENGINE=InnoDB;

-- 6. Tabla Inventarios
CREATE TABLE inventarios (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_ingrediente VARCHAR(100) NOT NULL,
    cantidad_estimada DECIMAL(8,2) DEFAULT 0.00
) ENGINE=InnoDB;

-- 7. Tabla Recetas
CREATE TABLE recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    cantidad_necesaria DECIMAL(8,4) NOT NULL,
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    CONSTRAINT fk_recetas_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_recetas_inventarios FOREIGN KEY (id_ingrediente) REFERENCES inventarios(id_ingrediente) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Tabla Pedidos
CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado_pedido VARCHAR(30) DEFAULT 'Pendiente',
    porcentaje_propina DECIMAL(5,2) DEFAULT 10.00,
    total_pagar DECIMAL(8,2) DEFAULT 0.00,
    metodo_pago VARCHAR(30),
    id_mesa INT NOT NULL,
    id_usuario INT NOT NULL,
    CONSTRAINT fk_pedidos_mesas FOREIGN KEY (id_mesa) REFERENCES mesas(id_mesa) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pedidos_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. Tabla Detalle_Pedidos
CREATE TABLE detalle_pedidos (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    subtotal DECIMAL(8,2) NOT NULL,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    CONSTRAINT fk_detalles_pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalles_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- DATOS INICIALES DE PRUEBA
INSERT INTO roles (nombre_rol) VALUES ('Administrador'), ('Empleado'), ('Cliente');

-- Usuario Administrador por defecto (La contraseña es '1234')
INSERT INTO usuarios (nombre_completo, nombre_usuario, contrasena, id_rol) VALUES 
('Administrador General', 'admin', '$2y$10$TKh8H1.PfQx37YgCzwiKb.KjNyWgaHb9cbcoQgdIVFlYg7B77UdFm', 1);

INSERT INTO categorias (nombre_categoria) VALUES ('Bebidas Calientes'), ('Bebidas Frías'), ('Postres');
INSERT INTO mesas (numero_mesa, estado_mesa) VALUES (1, 'Libre'), (2, 'Libre'), (3, 'Libre');