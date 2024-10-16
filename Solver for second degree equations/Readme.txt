Práctica Final: Sistemas de Ecuaciones Lineales en Ensamblador MIPS

Descripción
	En esta práctica, implementaremos una serie de funciones en ensamblador MIPS para resolver 
	sistemas de ecuaciones lineales con dos incógnitas. Utilizaremos una biblioteca externa para
	la resolución matemática del sistema y nos enfocaremos en la implementación de funciones de 
	entrada y salida, así como en la integración de estas con la función de resolución.

Objetivos
	- Implementar una función para parsear una ecuación lineal desde una cadena de caracteres.
	- Implementar una función para generar una cadena de caracteres con la solución de un sistema de ecuaciones.
	- Integrar las funciones anteriores con la función de resolución matemática para resolver sistemas de ecuaciones lineales.

Tipos de Datos
- Tipo "Ecuacion"
	- Este tipo de datos contiene tres enteros para representar los coeficientes y el término independiente, 
		además de dos enteros adicionales para los nombres de las incógnitas.
- Tipo "Solucion"
	- Este tipo de datos contiene siete enteros para representar la solución del sistema de ecuaciones
		, incluyendo la parte entera y fraccionaria de las incógnitas, y un entero para el tipo de solución

Funciones: 
- String2Ecuacion
	- Convierte una cadena de caracteres en un objeto Ecuacion.
- Solucion2String
	- Convierte un objeto Solucion en una cadena de caracteres.
- ResuelveSistema
	- Resuelve un sistema de ecuaciones lineales a partir de dos cadenas de caracteres.
- Retorno:
	- código de error (0 si el sistema se resuelve correctamente)



