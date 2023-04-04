/**********************************************************************************************************************
** Autor:       Divanny
** Procedimiento: GenerateCRUDProcedures
** Descripción: Este procedimiento almacenado genera scripts para crear procedimientos almacenados CRUD (Create, Read, Update, Delete)
**              para una tabla específica en la base de datos.
**
** Parámetros:  @tableName - Nombre de la tabla para la cual se generarán los procedimientos almacenados CRUD.
**              @idFieldName - Nombre del campo de identificación (ID) de la tabla.
**
** Uso:         Ejecute el procedimiento almacenado proporcionando los parámetros requeridos.
**              Copie y pegue los scripts generados en su base de datos para crear los procedimientos almacenados CRUD.
**
** Ejemplo:     EXEC GenerateCRUDProcedures @tableName = 'MiTabla', @idFieldName = 'MiTablaID';
**
** Nota:        Asegúrese de tener los permisos adecuados para crear y modificar procedimientos almacenados en la base de datos.
*/

-- PROCEDURE TO GENERATE CRUD PROCEDURES
CREATE PROCEDURE GenerateCRUDProcedures
    @tableName NVARCHAR(MAX),
    @idFieldName NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- Obtener nombres de columnas
    DECLARE @columnNames NVARCHAR(MAX) = ''

    SELECT @columnNames += COLUMN_NAME + ', '
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName AND COLUMN_NAME != @idFieldName

    SET @columnNames = LEFT(@columnNames, LEN(@columnNames) - 1)

	-- Obtener nombres de columnas con @
    DECLARE @columnNamesParameters NVARCHAR(MAX) = ''

    SELECT @columnNamesParameters += '@' + COLUMN_NAME + ', '
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName AND COLUMN_NAME != @idFieldName

    SET @columnNamesParameters = LEFT(@columnNamesParameters, LEN(@columnNamesParameters) - 1)

	-- Obtener nombres de columnas con @ y tipo de dato
	DECLARE @columnNamesParametersWithDataType NVARCHAR(MAX) = ''

	SELECT 
		@columnNamesParametersWithDataType += '@' + COLUMN_NAME + ' ' + UPPER(DATA_TYPE) + 
		CASE 
            WHEN DATA_TYPE IN ('VARCHAR', 'NVARCHAR', 'CHAR', 'NCHAR') THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(10)) + ')'
            ELSE ''
        END + ', '
	FROM 
		INFORMATION_SCHEMA.COLUMNS
	WHERE 
		TABLE_NAME = @tableName AND 
		COLUMN_NAME != @idFieldName

	SET @columnNamesParametersWithDataType = LEFT(@columnNamesParametersWithDataType, LEN(@columnNamesParametersWithDataType) - 1) -- Remover la última coma

	-- Obtener nombres de columnas con insercion
    DECLARE @columnNamesParametersWithValue NVARCHAR(MAX) = ''

    SELECT @columnNamesParametersWithValue += COLUMN_NAME + '= @' + COLUMN_NAME + ', '
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = @tableName AND COLUMN_NAME != @idFieldName

    SET @columnNamesParametersWithValue = LEFT(@columnNamesParametersWithValue, LEN(@columnNamesParametersWithValue) - 1)

    -- Generar Stored Procedures
    DECLARE @createSP NVARCHAR(MAX) = '
	/* CRUD STOREDPROCEDURES OF '+ @tableName + ' */
	-- CREATE SP '+ @tableName + '
CREATE PROCEDURE Create' + @tableName + '
    (' + @columnNamesParametersWithDataType + ')
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ' + @tableName + ' (' + @columnNames + ')
    VALUES (' + @columnNamesParameters + ')
END'

    DECLARE @readSP NVARCHAR(MAX) = '
	-- READ SP '+ @tableName + '
CREATE PROCEDURE Read' + @tableName + '
    @' + @idFieldName + ' INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM ' + @tableName + ' WHERE ' + @idFieldName + ' = @' + @idFieldName + '
END'

    DECLARE @updateSP NVARCHAR(MAX) = '
	-- UPDATE SP '+ @tableName + '
CREATE PROCEDURE Update' + @tableName + '
    @' + @idFieldName + ' INT, ' + @columnNamesParametersWithDataType + '
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ' + @tableName + '
    SET ' + @columnNamesParametersWithValue + '
    WHERE ' + @idFieldName + ' = @' + @idFieldName + '
END'

    DECLARE @deleteSP NVARCHAR(MAX) = '
	-- DELETE SP '+ @tableName + '
CREATE PROCEDURE Delete' + @tableName + '
    @' + @idFieldName + ' INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM ' + @tableName + ' WHERE ' + @idFieldName + ' = @' + @idFieldName + '
END'

    -- Generar mensaje con scripts
    DECLARE @message NVARCHAR(MAX) = 'Copie y pegue los siguientes scripts en su base de datos:

' + @createSP + '

' + @readSP + '

' + @updateSP + '

' + @deleteSP

    PRINT @message
END