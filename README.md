<!-- PROCEDURE TO GENERATE CRUD PROCEDURES -->

<h1>Stored Procedure: GenerateCRUDProcedures</h1>

<p>Este procedimiento almacenado permite generar procedimientos CRUD básicos para una tabla dada en una base de datos SQL Server.</p>

<h2>Parámetros</h2>

<ul>
  <li><code>@tableName</code>: Nombre de la tabla para la cual se generarán los procedimientos.</li>
  <li><code>@idFieldName</code>: Nombre del campo de identificador único (clave primaria) en la tabla.</li>
</ul>

<h2>Funcionamiento</h2>

<p>El procedimiento obtiene los nombres de las columnas de la tabla dada y genera procedimientos almacenados para realizar operaciones básicas de creación, lectura, actualización y eliminación (CRUD) sobre ella.</p>

<p>Los procedimientos almacenados generados por este script son:</p>

<ul>
  <li><code>Create[tableName]</code>: Inserta un nuevo registro en la tabla.</li>
  <li><code>Read[tableName]</code>: Lee un registro de la tabla según su identificador único.</li>
  <li><code>Update[tableName]</code>: Actualiza un registro de la tabla según su identificador único.</li>
  <li><code>Delete[tableName]</code>: Elimina un registro de la tabla según su identificador único.</li>
</ul>

<h2>Ejemplo de uso</h2>

<p>Para generar los procedimientos CRUD para la tabla <code>Customers</code> en la base de datos <code>Northwind</code>, ejecutar el siguiente código:</p>
