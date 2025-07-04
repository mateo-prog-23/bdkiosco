USE [master];
go
CREATE DATABASE [DBKiosco];
go
USE [DBKiosco]
GO
/****** Object:  Table [dbo].[Producto]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Producto](
	[id_producto] [tinyint] IDENTITY(1,1) NOT NULL,
	[precio] [decimal](10, 4) NOT NULL,
	[descripcion] [varchar](255) NOT NULL,
	[stock] [int] NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[cuit_proveedor] [varchar](13) NOT NULL,
	[id_categoria] [tinyint] NOT NULL,
	[estado] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_producto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_VerTodosLosProductos]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_VerTodosLosProductos]
AS
SELECT P.cuit_proveedor AS CuitProveedor, P.nombre AS Nombre, P.precio AS Precio, P.stock AS Stock
FROM Producto P
WHERE P.estado = 1;
GO
/****** Object:  View [dbo].[vw_VerProductosConStock]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_VerProductosConStock]
AS
SELECT 
    P.cuit_proveedor AS CuitProveedor,
    P.nombre AS Nombre,
    P.precio AS Precio,
    P.stock AS Stock,
    P.id_categoria AS IDCategoria
FROM Producto P
WHERE P.stock > 0
  AND P.estado = 1;
GO
/****** Object:  View [dbo].[vw_VerProductosSinStock]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_VerProductosSinStock]
AS
SELECT 
    P.cuit_proveedor AS CuitProveedor,
    P.nombre AS Nombre,
    P.precio AS Precio,
    P.stock AS Stock,
    P.id_categoria AS IDCategoria
FROM Producto P
WHERE P.stock = 0
  AND P.estado = 1;
GO
/****** Object:  View [dbo].[vw_ProductosStockBajo]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ProductosStockBajo] AS
SELECT
    id_producto AS IDProducto,
    nombre AS NombreProducto,
    stock AS StockActual,
    precio AS PrecioUnitario,
    cuit_proveedor AS CuitProveedor,
    id_categoria AS IDCategoria
FROM Producto
WHERE stock < 10 AND estado = 1;
GO
/****** Object:  Table [dbo].[Compra]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Compra](
	[id_compra] [tinyint] IDENTITY(1,1) NOT NULL,
	[fecha] [date] NOT NULL,
	[importe] [decimal](12, 2) NOT NULL,
	[cuit_proveedor] [varchar](13) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_compra] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_VerCompras]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_VerCompras]
AS
SELECT C.cuit_proveedor AS CuitProveedor, C.importe AS Importe, C.fecha AS Fecha
FROM Compra C;
GO
/****** Object:  View [dbo].[vw_TotalComprasPorMes]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_TotalComprasPorMes]
AS
SELECT 
    FORMAT(fecha, 'yyyy-MM') AS Mes,
    SUM(importe) AS TotalGastado
FROM Compra
GROUP BY FORMAT(fecha, 'yyyy-MM');
GO
/****** Object:  Table [dbo].[DetalleCompra]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetalleCompra](
	[id_detalle] [tinyint] IDENTITY(1,1) NOT NULL,
	[cantidad] [int] NOT NULL,
	[precio_unitario] [decimal](10, 4) NOT NULL,
	[id_compra] [tinyint] NOT NULL,
	[id_producto] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ResumenComprasConDetalle]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ResumenComprasConDetalle] AS
SELECT
    C.id_compra AS IDCompra,
    C.fecha AS FechaCompra,
    C.cuit_proveedor AS CuitProveedor,
    P.nombre AS NombreProducto,
    DC.cantidad AS CantidadComprada,
    DC.precio_unitario AS PrecioUnitario,
    (DC.cantidad * DC.precio_unitario) AS SubtotalProducto,
    C.importe AS TotalCompra 
FROM Compra C
INNER JOIN DetalleCompra DC ON C.id_compra = DC.id_compra
INNER JOIN Producto P ON DC.id_producto = P.id_producto;
GO
/****** Object:  Table [dbo].[EmailProveedor]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailProveedor](
	[id_email] [tinyint] IDENTITY(1,1) NOT NULL,
	[email] [varchar](30) NOT NULL,
	[cuit_proveedor] [varchar](13) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Proveedor]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Proveedor](
	[cuit_proveedor] [varchar](13) NOT NULL,
	[razon_social] [varchar](50) NOT NULL,
	[direccion] [varchar](50) NOT NULL,
	[Estado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cuit_proveedor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TelefonoProveedor]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TelefonoProveedor](
	[id_telefono] [tinyint] IDENTITY(1,1) NOT NULL,
	[telefono] [varchar](20) NOT NULL,
	[cuit_proveedor] [varchar](13) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_telefono] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_ProveedoresActivosContactos]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ProveedoresActivosContactos] AS
SELECT 
    p.cuit_proveedor,
    p.razon_social,
    p.direccion,
    tp.telefono,
    ep.email
FROM Proveedor p
LEFT JOIN TelefonoProveedor tp ON p.cuit_proveedor = tp.cuit_proveedor
LEFT JOIN EmailProveedor ep ON p.cuit_proveedor = ep.cuit_proveedor
WHERE p.Estado = 1;
GO
/****** Object:  View [dbo].[vw_ProveedoresCantidadProductos]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ProveedoresCantidadProductos] AS
SELECT 
    p.cuit_proveedor,
    p.razon_social,
    p.estado,
    COUNT(pr.id_producto) AS cantidad_productos
FROM Proveedor p
LEFT JOIN Producto pr ON p.cuit_proveedor = pr.cuit_proveedor
GROUP BY p.cuit_proveedor, p.razon_social, p.estado;
GO
/****** Object:  Table [dbo].[Categoria]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categoria](
	[id_categoria] [tinyint] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_CategoriasCantidadProductos]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_CategoriasCantidadProductos] AS
SELECT 
    c.id_categoria,
    c.nombre AS nombre_categoria,
    COUNT(p.id_producto) AS cantidad_productos
FROM Categoria c
LEFT JOIN Producto p ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre;
GO
/****** Object:  View [dbo].[vw_StockPorProveedor]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_StockPorProveedor] AS
SELECT 
    p.cuit_proveedor,
    p.razon_social,
    SUM(pr.stock) AS stock_total
FROM Proveedor p
JOIN Producto pr ON p.cuit_proveedor = pr.cuit_proveedor
GROUP BY p.cuit_proveedor, p.razon_social;
GO
SET IDENTITY_INSERT [dbo].[Categoria] ON 

INSERT [dbo].[Categoria] ([id_categoria], [nombre]) VALUES (1, N'Bebidas')
INSERT [dbo].[Categoria] ([id_categoria], [nombre]) VALUES (2, N'Snacks')
INSERT [dbo].[Categoria] ([id_categoria], [nombre]) VALUES (3, N'Lácteos')
SET IDENTITY_INSERT [dbo].[Categoria] OFF
GO
SET IDENTITY_INSERT [dbo].[Compra] ON 

INSERT [dbo].[Compra] ([id_compra], [fecha], [importe], [cuit_proveedor]) VALUES (1, CAST(N'2025-06-10' AS Date), CAST(1500.00 AS Decimal(12, 2)), N'20123456789')
INSERT [dbo].[Compra] ([id_compra], [fecha], [importe], [cuit_proveedor]) VALUES (2, CAST(N'2025-06-12' AS Date), CAST(1000.00 AS Decimal(12, 2)), N'20987654321')
INSERT [dbo].[Compra] ([id_compra], [fecha], [importe], [cuit_proveedor]) VALUES (3, CAST(N'2025-06-23' AS Date), CAST(1500.50 AS Decimal(12, 2)), N'20123456789')
SET IDENTITY_INSERT [dbo].[Compra] OFF
GO
SET IDENTITY_INSERT [dbo].[DetalleCompra] ON 

INSERT [dbo].[DetalleCompra] ([id_detalle], [cantidad], [precio_unitario], [id_compra], [id_producto]) VALUES (1, 10, CAST(150.5000 AS Decimal(10, 4)), 1, 1)
INSERT [dbo].[DetalleCompra] ([id_detalle], [cantidad], [precio_unitario], [id_compra], [id_producto]) VALUES (2, 5, CAST(80.0000 AS Decimal(10, 4)), 2, 2)
INSERT [dbo].[DetalleCompra] ([id_detalle], [cantidad], [precio_unitario], [id_compra], [id_producto]) VALUES (3, 10, CAST(45.7500 AS Decimal(10, 4)), 1, 4)
INSERT [dbo].[DetalleCompra] ([id_detalle], [cantidad], [precio_unitario], [id_compra], [id_producto]) VALUES (4, 10, CAST(45.7500 AS Decimal(10, 4)), 1, 4)
INSERT [dbo].[DetalleCompra] ([id_detalle], [cantidad], [precio_unitario], [id_compra], [id_producto]) VALUES (5, 10, CAST(45.7500 AS Decimal(10, 4)), 1, 4)
INSERT [dbo].[DetalleCompra] ([id_detalle], [cantidad], [precio_unitario], [id_compra], [id_producto]) VALUES (6, 10, CAST(45.7500 AS Decimal(10, 4)), 1, 4)
SET IDENTITY_INSERT [dbo].[DetalleCompra] OFF
GO
SET IDENTITY_INSERT [dbo].[EmailProveedor] ON 

INSERT [dbo].[EmailProveedor] ([id_email], [email], [cuit_proveedor]) VALUES (1, N'ventas@proveedoruno.com', N'20123456789')
INSERT [dbo].[EmailProveedor] ([id_email], [email], [cuit_proveedor]) VALUES (2, N'contacto@distsur.com', N'20987654321')
SET IDENTITY_INSERT [dbo].[EmailProveedor] OFF
GO
SET IDENTITY_INSERT [dbo].[Producto] ON 

INSERT [dbo].[Producto] ([id_producto], [precio], [descripcion], [stock], [nombre], [cuit_proveedor], [id_categoria], [estado]) VALUES (1, CAST(150.5000 AS Decimal(10, 4)), N'Coca Cola 1.5L', 100, N'Coca Cola', N'20123456789', 1, 1)
INSERT [dbo].[Producto] ([id_producto], [precio], [descripcion], [stock], [nombre], [cuit_proveedor], [id_categoria], [estado]) VALUES (2, CAST(80.0000 AS Decimal(10, 4)), N'Papas fritas sabor queso 100g', 200, N'Papas Queso', N'20987654321', 2, 1)
INSERT [dbo].[Producto] ([id_producto], [precio], [descripcion], [stock], [nombre], [cuit_proveedor], [id_categoria], [estado]) VALUES (3, CAST(120.7500 AS Decimal(10, 4)), N'Yogur sabor frutilla 200ml', 150, N'Yogur Frutilla', N'20123456789', 3, 1)
INSERT [dbo].[Producto] ([id_producto], [precio], [descripcion], [stock], [nombre], [cuit_proveedor], [id_categoria], [estado]) VALUES (4, CAST(200.9900 AS Decimal(10, 4)), N'Alfajor de chocolate', 50, N'Chocolate', N'20123456789', 2, 0)
INSERT [dbo].[Producto] ([id_producto], [precio], [descripcion], [stock], [nombre], [cuit_proveedor], [id_categoria], [estado]) VALUES (5, CAST(100.5000 AS Decimal(10, 4)), N'sugus', 10, N'Caramelo', N'20123456789', 2, 1)
SET IDENTITY_INSERT [dbo].[Producto] OFF
GO
INSERT [dbo].[Proveedor] ([cuit_proveedor], [razon_social], [direccion], [Estado]) VALUES (N'20123456789', N'Proveedor Uno S.A.', N'Av. Siempre Viva 742', 1)
INSERT [dbo].[Proveedor] ([cuit_proveedor], [razon_social], [direccion], [Estado]) VALUES (N'20987654321', N'Distribuidora Sur', N'Calle Falsa 123', 1)
GO
SET IDENTITY_INSERT [dbo].[TelefonoProveedor] ON 

INSERT [dbo].[TelefonoProveedor] ([id_telefono], [telefono], [cuit_proveedor]) VALUES (1, N'1145678901', N'20123456789')
INSERT [dbo].[TelefonoProveedor] ([id_telefono], [telefono], [cuit_proveedor]) VALUES (2, N'1134567890', N'20987654321')
SET IDENTITY_INSERT [dbo].[TelefonoProveedor] OFF
GO
ALTER TABLE [dbo].[Producto] ADD  DEFAULT ((1)) FOR [estado]
GO
ALTER TABLE [dbo].[Compra]  WITH CHECK ADD FOREIGN KEY([cuit_proveedor])
REFERENCES [dbo].[Proveedor] ([cuit_proveedor])
GO
ALTER TABLE [dbo].[DetalleCompra]  WITH CHECK ADD FOREIGN KEY([id_compra])
REFERENCES [dbo].[Compra] ([id_compra])
GO
ALTER TABLE [dbo].[DetalleCompra]  WITH CHECK ADD FOREIGN KEY([id_producto])
REFERENCES [dbo].[Producto] ([id_producto])
GO
ALTER TABLE [dbo].[EmailProveedor]  WITH CHECK ADD FOREIGN KEY([cuit_proveedor])
REFERENCES [dbo].[Proveedor] ([cuit_proveedor])
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD FOREIGN KEY([cuit_proveedor])
REFERENCES [dbo].[Proveedor] ([cuit_proveedor])
GO
ALTER TABLE [dbo].[Producto]  WITH CHECK ADD FOREIGN KEY([id_categoria])
REFERENCES [dbo].[Categoria] ([id_categoria])
GO
ALTER TABLE [dbo].[TelefonoProveedor]  WITH CHECK ADD FOREIGN KEY([cuit_proveedor])
REFERENCES [dbo].[Proveedor] ([cuit_proveedor])
GO
/****** Object:  StoredProcedure [dbo].[CrearProveedor]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CrearProveedor]
    @CUITProveedor NVARCHAR(13),
    @RazonSocial NVARCHAR(50),
    @Direccion NVARCHAR(50),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(30)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        IF @CUITProveedor IS NULL OR LTRIM(RTRIM(@CUITProveedor)) = ''
        BEGIN
            RAISERROR('El CUIT del proveedor no puede estar vacío.', 16, 1);
            RETURN;
        END
        IF @RazonSocial IS NULL OR LTRIM(RTRIM(@RazonSocial)) = ''
        BEGIN
            RAISERROR('La razón social no puede estar vacía.', 16, 1);
            RETURN;
        END
        IF @Direccion IS NULL OR LTRIM(RTRIM(@Direccion)) = ''
        BEGIN
            RAISERROR('La dirección no puede estar vacía.', 16, 1);
            RETURN;
        END
        IF @Telefono IS NULL OR LTRIM(RTRIM(@Telefono)) = ''
        BEGIN
            RAISERROR('El teléfono no puede estar vacío.', 16, 1);
            RETURN;
        END
        IF @Email IS NULL OR LTRIM(RTRIM(@Email)) = ''
        BEGIN
            RAISERROR('El email no puede estar vacío.', 16, 1);
            RETURN;
        END
        INSERT INTO Proveedor (cuit_Proveedor, razon_social, direccion, estado)
        VALUES (@CUITProveedor, @RazonSocial, @Direccion, 1);
        INSERT INTO TelefonoProveedor (cuit_Proveedor, telefono)
        VALUES (@CUITProveedor, @Telefono);
        INSERT INTO EmailProveedor (cuit_Proveedor, email)
        VALUES (@CUITProveedor, @Email);
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al crear el proveedor: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ComprasPorRangoFechas]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ComprasPorRangoFechas]
    @FechaDesde DATE,
    @FechaHasta DATE
AS
BEGIN
    SELECT
        C.id_compra AS IDCompra,
        C.fecha AS FechaCompra,
        C.cuit_proveedor AS CuitProveedor,
        C.importe AS ImporteCompra
    FROM Compra C
    WHERE C.fecha BETWEEN @FechaDesde AND @FechaHasta
    ORDER BY C.fecha ASC;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_Crear_Compra]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Crear_Compra]
    @Importe DECIMAL(12, 2),
    @CuitProveedor VARCHAR(13)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación: Verificar que el proveedor existe
        IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE cuit_proveedor = @CuitProveedor)
        BEGIN
            RAISERROR('El proveedor especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Importe debe ser mayor a 0
        IF @Importe <= 0
        BEGIN
            RAISERROR('El importe de la compra debe ser mayor a cero.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Inserción en tabla Compra
        INSERT INTO Compra (importe, cuit_proveedor, fecha)
        VALUES (@Importe, @CuitProveedor, GETDATE());

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_Crear_DetalleCompra]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Crear_DetalleCompra]
    @Cantidad INT, 
    @PrecioUnitario DECIMAL(10,4),
    @IDCompra TINYINT,
    @IDProducto TINYINT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación: La compra debe existir
        IF NOT EXISTS (SELECT 1 FROM Compra WHERE id_compra = @IDCompra)
        BEGIN
            RAISERROR('La compra especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: El producto debe existir
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @IDProducto)
        BEGIN
            RAISERROR('El producto especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Cantidad debe ser mayor a 0
        IF @Cantidad <= 0
        BEGIN
            RAISERROR('La cantidad debe ser mayor a cero.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Precio unitario debe ser mayor a 0
        IF @PrecioUnitario <= 0
        BEGIN
            RAISERROR('El precio unitario debe ser mayor a cero.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Inserción en DetalleCompra
        INSERT INTO DetalleCompra(cantidad, precio_unitario, id_compra, id_producto)
        VALUES(@Cantidad, @PrecioUnitario, @IDCompra, @IDProducto);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si ocurre un error, revierte la transacción
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_Crear_Producto]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Crear_Producto]
    @Precio DECIMAL(10, 4),
    @Descripcion VARCHAR(255),
    @Stock INT,
    @Nombre VARCHAR(50),
    @CuitProveedor VARCHAR(13),
    @IDCategoria TINYINT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación: Proveedor debe existir
        IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE cuit_proveedor = @CuitProveedor)
        BEGIN
            RAISERROR('El proveedor especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Categoría debe existir
        IF NOT EXISTS (SELECT 1 FROM Categoria WHERE id_categoria = @IDCategoria)
        BEGIN
            RAISERROR('La categoría especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Precio mayor a 0
        IF @Precio <= 0
        BEGIN
            RAISERROR('El precio debe ser mayor a cero.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Stock no negativo
        IF @Stock < 0
        BEGIN
            RAISERROR('El stock no puede ser negativo.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Nombre no puede ser nulo o vacío
        IF (@Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = '')
        BEGIN
            RAISERROR('El nombre del producto no puede ser nulo o vacío.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Inserción en tabla Producto
        INSERT INTO Producto(precio, descripcion, stock, nombre, cuit_proveedor, id_categoria)
        VALUES(@Precio, @Descripcion, @Stock, @Nombre, @CuitProveedor, @IDCategoria);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_Desactivar_Producto]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Desactivar_Producto]
(
    @IDProducto INT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación: Verificar que el producto existe
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @IDProducto)
        BEGIN
            RAISERROR('El producto especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación opcional: Verificar si ya está desactivado
        IF EXISTS (SELECT 1 FROM Producto WHERE id_producto = @IDProducto AND estado = 0)
        BEGIN
            RAISERROR('El producto ya se encuentra desactivado.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Desactivar producto (baja lógica)
        UPDATE Producto
        SET estado = 0
        WHERE id_producto = @IDProducto;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_Editar_Producto]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Editar_Producto]
(
    @IDProducto INT,
    @Precio DECIMAL(10, 4),
    @Descripcion VARCHAR(255),
    @Stock INT,
    @Nombre VARCHAR(50),
    @CuitProveedor VARCHAR(13),
    @IDCategoria TINYINT
)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validación: El producto debe existir
        IF NOT EXISTS (SELECT 1 FROM Producto WHERE id_producto = @IDProducto)
        BEGIN
            RAISERROR('El producto especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: El proveedor debe existir
        IF NOT EXISTS (SELECT 1 FROM Proveedor WHERE cuit_proveedor = @CuitProveedor)
        BEGIN
            RAISERROR('El proveedor especificado no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: La categoría debe existir
        IF NOT EXISTS (SELECT 1 FROM Categoria WHERE id_categoria = @IDCategoria)
        BEGIN
            RAISERROR('La categoría especificada no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Precio mayor a 0
        IF @Precio <= 0
        BEGIN
            RAISERROR('El precio debe ser mayor a cero.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Stock no negativo
        IF @Stock < 0
        BEGIN
            RAISERROR('El stock no puede ser negativo.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Validación: Nombre no vacío o nulo
        IF (@Nombre IS NULL OR LTRIM(RTRIM(@Nombre)) = '')
        BEGIN
            RAISERROR('El nombre del producto no puede ser nulo o vacío.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Actualización del producto
        UPDATE Producto
        SET
            precio = @Precio,
            descripcion = @Descripcion,
            stock = @Stock,
            nombre = @Nombre,
            cuit_proveedor = @CuitProveedor,
            id_categoria = @IDCategoria
        WHERE
            id_producto = @IDProducto;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProveedor]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateProveedor]
    @CUITProveedor NVARCHAR(13),
    @RazonSocial NVARCHAR(50),
    @Direccion NVARCHAR(50),
    @Telefono NVARCHAR(20),
    @Email NVARCHAR(30)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validaciones básicas
        IF @CUITProveedor IS NULL OR LTRIM(RTRIM(@CUITProveedor)) = ''
        BEGIN
            RAISERROR('El CUIT del proveedor no puede estar vacío.', 16, 1);
            RETURN;
        END

        IF @RazonSocial IS NULL OR LTRIM(RTRIM(@RazonSocial)) = ''
        BEGIN
            RAISERROR('La razón social no puede estar vacía.', 16, 1);
            RETURN;
        END

        IF @Direccion IS NULL OR LTRIM(RTRIM(@Direccion)) = ''
        BEGIN
            RAISERROR('La dirección no puede estar vacía.', 16, 1);
            RETURN;
        END

        IF @Telefono IS NULL OR LTRIM(RTRIM(@Telefono)) = ''
        BEGIN
            RAISERROR('El teléfono no puede estar vacío.', 16, 1);
            RETURN;
        END

        IF @Email IS NULL OR LTRIM(RTRIM(@Email)) = ''
        BEGIN
            RAISERROR('El email no puede estar vacío.', 16, 1);
            RETURN;
        END

        -- Actualizar datos
        UPDATE Proveedor
        SET razon_social = @RazonSocial,
            direccion = @Direccion
        WHERE cuit_proveedor = @CUITProveedor;

        UPDATE TelefonoProveedor
        SET telefono = @Telefono
        WHERE cuit_proveedor = @CUITProveedor;

        UPDATE EmailProveedor
        SET email = @Email
        WHERE cuit_proveedor = @CUITProveedor;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al actualizar el proveedor: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateProveedorEstado]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UpdateProveedorEstado]
    @cuitProveedor NVARCHAR(13),
    @estado BIT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Validar que el CUIT no esté vacío
        IF @cuitProveedor IS NULL OR LTRIM(RTRIM(@cuitProveedor)) = ''
        BEGIN
            RAISERROR('El CUIT del proveedor no puede estar vacío.', 16, 1);
            RETURN;
        END

        -- Validar que el estado sea 0 o 1 (opcional por ser tipo BIT)
        IF @estado NOT IN (0, 1)
        BEGIN
            RAISERROR('El estado debe ser 0 (inactivo) o 1 (activo).', 16, 1);
            RETURN;
        END

        -- Actualizar el estado
        UPDATE Proveedor
        SET Estado = @estado
        WHERE cuit_proveedor = @cuitProveedor;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;

        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error al actualizar el estado del proveedor: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_VerProductosPorCategoria]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VerProductosPorCategoria]
    @IDCategoria TINYINT
AS
BEGIN
    SELECT 
        P.cuit_proveedor AS CuitProveedor,
        P.nombre AS Nombre,
        P.precio AS Precio,
        P.stock AS Stock,
        P.id_categoria AS IDCategoria
    FROM Producto P
    WHERE P.id_categoria = @IDCategoria
      AND P.estado = 1; -- Solo activos si corresponde
END
GO
/****** Object:  StoredProcedure [dbo].[sp_VerProductosPorProveedor]    Script Date: 23/6/2025 23:27:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_VerProductosPorProveedor]
    (
		@CuitProveedor VARCHAR(13)
	)
AS
BEGIN
    SELECT 
        P.cuit_proveedor AS CuitProveedor,
        P.nombre AS Nombre,
        P.precio AS Precio,
        P.stock AS Stock
    FROM Producto P
    WHERE P.cuit_proveedor = @CuitProveedor
      AND P.estado = 1; 
END
GO
