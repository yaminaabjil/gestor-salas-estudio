# 📚 Gestor de Reservas de Salas de Estudio

Base de datos relacional diseñada para gestionar de forma integral el sistema de reservas de aulas y espacios de estudio de una universidad. Este proyecto implementa lógica de negocio compleja directamente en la base de datos mediante el uso de funciones, disparadores (triggers) y vistas.

## 🛠️ Tecnologías Utilizadas
* **Lenguaje:** SQL (MySQL)
* **Conceptos aplicados:** Diseño relacional, integridad referencial, automatización de reglas de negocio, subconsultas avanzadas.

## ⚙️ Características Principales

El script `abjil_yamina.sql` abarca la creación completa del esquema (`Estudiantes`, `Salas`, `Reservas`, `Incidencias`) y el desarrollo de las siguientes funcionalidades:

* **Consultas Avanzadas:** Análisis de datos complejos utilizando agrupaciones (`GROUP BY`, `HAVING`), subconsultas anidadas y operadores relacionales (`NOT IN`, `ALL`).
* **Reglas de Negocio (Triggers):** 
  * `trg_validar_reservas`: Bloquea inserciones automáticamente si se supera el aforo de la sala, si el estudiante tiene morosidad (más de 3 reservas pendientes) o si se reserva con más de dos meses de antelación.
  * `trg_formato_email`: Estandariza la entrada de datos limpiando los correos electrónicos.
* **Funciones Personalizadas:** Creación de rutinas (`plazas_libres`, `reservas_pendientes`) para calcular en tiempo real la disponibilidad de aforo y el estado de los usuarios.
* **Vistas Optimizadas:** Generación de vistas precalculadas (`Vista_Incidencias_Pendientes`, `Vista_Reservas_Detalladas`) para facilitar la consulta del personal de mantenimiento e información evitando cruces de tablas manuales recurrentes.

## 👩‍💻 Autora
**Yamina Abjil**
* Estudiante de Ingeniería Informática
* [LinkedIn](https://www.linkedin.com/in/yamina-abjil) | [GitHub](https://github.com/yaminaabjil)
