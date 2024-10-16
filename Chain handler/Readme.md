# Práctica en Ensamblador MIPS - Manipulación de Cadenas

## Descripción
Este proyecto implementa un programa en lenguaje ensamblador MIPS que procesa una cadena de entrada
proporcionada por el usuario. La cadena se divide en varias partes para determinar la operación y 
los operandos, y se realizan diversas tareas de manipulación de cadenas como cálculo de longitud, 
conversión de mayúsculas y minúsculas, concatenación, comparación y operaciones de búsqueda.

## Funcionalidad
- El programa recibe una cadena de entrada que consiste en una operación seguida de uno o dos operandos (cadenas). Luego, ejecuta la operación correspondiente y muestra el resultado en pantalla. 
- Si la entrada es inválida o no sigue la sintaxis correcta, el programa imprime "ENTRADA INCORRECTA".

## Operaciones Soportadas:
- len: Devuelve la longitud de la cadena de entrada (en hexadecimal).
	- Ejemplo: len HOLA → Salida: 4
- lwc: Convierte la cadena de entrada a minúsculas.
	- Ejemplo: lwc HOLA → Salida: hola
- upc: Convierte la cadena de entrada a mayúsculas.
	- Ejemplo: upc hola → Salida: HOLA
- cat: Concatenación de dos cadenas.
	- Ejemplo: cat HOLA MUNDO → Salida: HOLAMUNDO
- cmp: Compara dos cadenas lexicográficamente (carácter por carácter en ASCII). Imprime "IGUAL", "MAYOR" o "MENOR".
	- Ejemplo: cmp HOLA HOLA → Salida: IGUAL
- chr: Encuentra la posición (en hexadecimal) del primer carácter de la primera cadena en la segunda, buscando desde el principio.
	- Ejemplo: chr A BANDA → Salida: 2
- rchr: Encuentra la posición (en hexadecimal) del primer carácter de la primera cadena en la segunda, buscando desde el final.
	- Ejemplo: rchr A BANDA → Salida: 5
- str: Encuentra la posición (en hexadecimal) de la primera cadena dentro de la segunda, buscando desde el principio.
	- Ejemplo: str LO HOLA → Salida: 3
- rev: Invierte la cadena de entrada.
	- Ejemplo: rev HOLA → Salida: ALOH
- rep: Repite la cadena tantas veces como se indique en el número (en hexadecimal).
	- Ejemplo: rep HOLA 3 → Salida: HOLAHOLAHOLA

## Formato de Entrada
La cadena de entrada debe seguir el formato: <operación> <operando1> [<operando2>], con espacios o tabulaciones 
separando los componentes.

Para operaciones que requieren solo un operando (por ejemplo, len, lwc, upc), cualquier segundo operando será  ignorado sin generar error.

Si faltan operandos o se proporcionan más de dos, el programa imprimirá "ENTRADA INCORRECTA".

Los números en hexadecimal se aceptan sin ceros iniciales ni el prefijo 0x.

## Llamadas al Sistema Utilizadas
El programa utiliza las siguientes llamadas al sistema en MIPS para entrada y salida:
- syscall código 4: Imprimir cadena de salida
- syscall código 8: Leer cadena de entrada

##Ejemplos de Uso

Entrada: len HOLA
Salida: 4

Entrada: cmp MUN MUNDO
Salida: MENOR

Entrada: rep HOLA 4
Salida: HOLAHOLAHOLAHOLA

Entrada: HOLA MUNDO
Salida: ENTRADA INCORRECTA
