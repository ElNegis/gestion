-- ===================
--      TABLAS
-- ===================

-- Table: corte_plegado
CREATE TABLE corte_plegado (
    id               SERIAL PRIMARY KEY,
    espesor          DECIMAL(10,2) NOT NULL,
    largo            DECIMAL(10,2) NOT NULL,
    precio           DECIMAL(10,2) NOT NULL
);

-- Table: cliente
CREATE TABLE cliente (
    id               SERIAL PRIMARY KEY,
    nombre           VARCHAR(250) NOT NULL,
    apellido         VARCHAR(250) NOT NULL,
    codigo_cliente   VARCHAR(250) NOT NULL,
    ci               VARCHAR(250) NOT NULL DEFAULT '-',
    email            VARCHAR(250) NOT NULL DEFAULT '-',
    telefono         VARCHAR(250) NOT NULL DEFAULT '-',
    creared_at       DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Table: cotizacion
CREATE TABLE cotizacion (
    id               SERIAL PRIMARY KEY,
    pieza            VARCHAR(250) NOT NULL DEFAULT '-',
    precio           MONEY NOT NULL,
    fecha_cotizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    plancha_id       INT NOT NULL,
    corte_plegado_id INT NOT NULL,
    venta_id         INT NOT NULL
);

-- Table: permisos
CREATE TABLE permisos (
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(250) NOT NULL DEFAULT '-',
    description  VARCHAR(250) NOT NULL DEFAULT '-'
);

-- Table: plancha
CREATE TABLE plancha (
    id     SERIAL PRIMARY KEY,
    espesor DECIMAL(10,2) NOT NULL,
    largo   DECIMAL(10,2) NOT NULL,
    ancho   DECIMAL(10,2) NOT NULL
);

-- Table: plancha_proveedor
CREATE TABLE plancha_proveedor (
    id            SERIAL PRIMARY KEY,
    precio        MONEY NOT NULL,
    proveedor_id  INT NOT NULL,
    plancha_id    INT NOT NULL
);

-- Table: proveedor
CREATE TABLE proveedor (
    id       SERIAL PRIMARY KEY,
    nombre   VARCHAR(250) NOT NULL DEFAULT '-',
    telefono INT NOT NULL DEFAULT 0
);

-- Table: roles
CREATE TABLE roles (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(250) NOT NULL DEFAULT '-',
    description TEXT NOT NULL
);

-- Table: roles_permisos
CREATE TABLE roles_permisos (
    id          SERIAL PRIMARY KEY,
    permisos_id INT NOT NULL,
    roles_id    INT NOT NULL
);

-- Table: user_roles
CREATE TABLE user_roles (
    id       SERIAL PRIMARY KEY,
    roles_id INT NOT NULL,
    users_id INT NOT NULL
);

-- Table: users
CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(250) NOT NULL DEFAULT '-',
    apellido    VARCHAR(250) NOT NULL DEFAULT '-',
    username    VARCHAR(250) NOT NULL DEFAULT '-',
    password    VARCHAR(250) NOT NULL DEFAULT '-',
    is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table: venta
CREATE TABLE venta (
    id          SERIAL PRIMARY KEY,
    total       MONEY NOT NULL,
    fecha_venta DATE NOT NULL DEFAULT CURRENT_DATE,
    users_id    INT NOT NULL,
    cliente_id  INT NOT NULL
);

-- ===================
--  RELACIONES (FK)
-- ===================

-- cotizacion -> corte_plegado
ALTER TABLE cotizacion
    ADD CONSTRAINT fk_cotizacion_corte_plegado
    FOREIGN KEY (corte_plegado_id)
    REFERENCES corte_plegado (id);

-- cotizacion -> plancha
ALTER TABLE cotizacion
    ADD CONSTRAINT fk_cotizacion_plancha
    FOREIGN KEY (plancha_id)
    REFERENCES plancha (id);

-- cotizacion -> venta
ALTER TABLE cotizacion
    ADD CONSTRAINT fk_cotizacion_venta
    FOREIGN KEY (venta_id)
    REFERENCES venta (id);

-- plancha_proveedor -> plancha
ALTER TABLE plancha_proveedor
    ADD CONSTRAINT fk_plancha_proveedor_plancha
    FOREIGN KEY (plancha_id)
    REFERENCES plancha (id);

-- plancha_proveedor -> proveedor
ALTER TABLE plancha_proveedor
    ADD CONSTRAINT fk_plancha_proveedor_proveedor
    FOREIGN KEY (proveedor_id)
    REFERENCES proveedor (id);

-- roles_permisos -> permisos
ALTER TABLE roles_permisos
    ADD CONSTRAINT fk_roles_permisos_permisos
    FOREIGN KEY (permisos_id)
    REFERENCES permisos (id);

-- roles_permisos -> roles
ALTER TABLE roles_permisos
    ADD CONSTRAINT fk_roles_permisos_roles
    FOREIGN KEY (roles_id)
    REFERENCES roles (id);

-- user_roles -> roles
ALTER TABLE user_roles
    ADD CONSTRAINT fk_user_roles_roles
    FOREIGN KEY (roles_id)
    REFERENCES roles (id);

-- user_roles -> users
ALTER TABLE user_roles
    ADD CONSTRAINT fk_user_roles_users
    FOREIGN KEY (users_id)
    REFERENCES users (id);

-- venta -> cliente
ALTER TABLE venta
    ADD CONSTRAINT fk_venta_cliente
    FOREIGN KEY (cliente_id)
    REFERENCES cliente (id);

-- venta -> users
ALTER TABLE venta
    ADD CONSTRAINT fk_venta_users
    FOREIGN KEY (users_id)
    REFERENCES users (id);
