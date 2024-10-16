# Juan Gonzalez Arranz y Tomas Carretero Alarcon - T1 
# COMIENZO STRING2ECUACION: $a0 - input_cad; $a1 - output_ec; $v0 - salida_de_error
.data
primeraVariable: .space 1
segundaVariable: .space 1
.text
String2Ecuacion:addi $sp, $sp, -24
		sw $ra, 8($sp)			#Guardamos la direccion de retorno original en la pila
		sw $s0, 4($sp)			#Guardamos el contenido original de $s0 en la pila
		sw $s1, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		sw $s2, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		sw $s3, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		sw $s4, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		sw $s5, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		
		move $s0, $a2 	#Guardamos direccion de salida
		move $s1, $zero	#Valor de x
		move $s2, $zero #Valor de y
		move $s3, $zero	#Letra primera variable
		move $s4, $zero #Letra segunda variable
		move $s5, $zero #Valor de la constante
		
getNumero:	jal atoi
		beq $v1, 1, errorSintax
		beq $v1, 2, errorTermino
		lb $t0, 0($t2)
		#Comprobamos que es una letra MAYUS
		beq $t0, 32, guardarConstante
		beq $t0, 45, guardarConstante
		beq $t0, 43, guardarConstante
		blt $t0, 65, errorSintax
		bgt $t0, 90, testMinus
		j guardarValor
testMinus1:	blt $t0, 97, errorSintax
		bgt $t0, 122, errorSintax
guardarCoeficiente:bne $s3, $zero, testPrimera
		move $s3, $t0
		j avanzar
testPrimera:	bne $s3, $t0, testSegunda
		move $s3, $t0
		j avanzar
testSegundaSinAsig:bne $s4, $zero, testSegunda
		move $s4, $t0
		j avanzar
testSegunda:	bne $s4, $t0, numIncogError
		move $s4, $t0	
		j avanzar
guardarConstante:add $s5, $s5, $t0
		
avanzar:	addi $t2, $t2, 1
		lb $t0, 0($t2)
		beq $t0, 32, avanzar
		beq $t0, 45, getNumero
		beq $t0, 43, getNumero
		beq $t0, 61, igualdad
		j errorSintax
		
		
		jr $ra 
# FIN STRING2ECUACION

#COMIENZO ATOI: ENTRADA -> $a0 - direccion cadena a convertir; $v0 - numero resultado; $v1 - codigo error; $t2 - ultima posicion
.text
atoi:	li $t6, 10
	move $t5, $zero 		#Contador de numeros
	move $v0, $zero			#Registro de destino
	
bucIni:	lb $t0, 0($a0)			#Recorrido de las primeras posiciones
	addi $a0, $a0, 1
	beq $t0, 32, bucIni		#Espacios: los omitimos
	bne $t0, 43, test1		#Si es un signo positivo, vamos al siguiente bucle desde el siguiente digito
	move $t7, $zero			#Bit indicador de signo: 0 - POSITIVO
	j bucDos
test1:	bne $t0, 45, test2		#Si es un signo negativo, vamos al siguiente bucle desde el siguiente digito
	li $t7, 1			#Bit indicador de signo: 1 - NEGATIVO
	j bucDos			
test2:	blt $t0, 48, error	
	bgt $t0, 57, error		#Cualquier cosa que no sea lo anterior o un numero, es un error
	
	addi $a0, $a0, -1		#Solo si el primer caracter relevante es un numero hay que atrasar el indice
	
bucDos:	lb $t0, 0($a0)		
	blt $t0, 48, finBuc		
	bgt $t0, 57, finBuc
	addi $t5, $t5, 1		#Sumamos uno a los digitos leidos
	addi $t0, $t0, -48		
	
	#COMPROBACIONES DE OVERFLOW
	blt $v0, 214748364, noOverf	#Si no representa riesgo, salimos
	bgt $v0, 214748364, overf	#Si es mayor que lo que podemos gestionar, es overflow
	blt $t0, 8, noOverf		#Si su valor absoluto es menor que 2147483648, entonces no hay riesgo
	beq $t0, 9, overf		#No es posible representar 2147483649 ni -2147483649
	bne $t7, 1, overf		#Solo se puede representar -2147483648, no 2147483648
	li $v0, 0x80000000		
	move $v1, $zero
	jr $ra				#Cargamos -2147483648 y se acabo
			
noOverf:mul $v0, $v0, $t6
	addu $v0, $v0, $t0		#Multiplicamos el numero existente por 10 y sumamos el digito
	addi $a0, $a0, 1		
	j bucDos

finBuc:	beq $t5, $zero, error		#Si hemos terminado la parte de numeros de la cadena sin haber encontrado digitos, es un error
	bne $t7, 1, exit		#Si es negativo, hay que aplicarselo al resultado
	sub $v0, $zero, $v0
exit:	move $v1, $zero			#Salida correcta
	move $t2, $a0
	jr $ra
	
error:	li $v1, 1			#Salida de error
	jr $ra
overf:	li $v1, 2			#Salida de overflow
	jr $ra
#FIN ATOI



# COMIENZO RESUELVESISTEMA: $a0 - input_ec1; $a1 - input_ec2; $a2 - output_sol 
# Errores: 	0 --> Sistema de ecuaciones resulto 	1 --> Sintaxix incorrecta. 
#  		2 --> Overflow en termino o coeficiente.3 --> Overflow al reducir terminos o coeficientes 
#		4 --> Numero de incognitas incorrecta	5 --> Sistema de ecuaciones. 
ResuelveSistema: addi $sp, $sp, -12
		sw $ra, 0($sp)			#Guardamos la direccion de retorno original en la pila
		sw $s0, 4($sp)			#Guardamos la direccion de retorno original en la pila
		sw $s1, 8($sp)			#Guardamos el contenido original de $s0 en la pila
		sw $s2, 12($sp)			#Guardamos el contenido original de $s1 en la pila
		
		# incialmente $a0 contiene la dirección del string de la ec1
		move $s2, $a1
		jal String2Ecuacion 
	
		beq $v0, 1, Error	# Errores arriba. 
		beq $v0, 2, Error
		beq $v0, 3, Error
		beq $v0, 4, Error
		# Sino se da ninguna de las anteriores condciones, la ecs es correcta y pasamos a buscar la otra.
		move $s1, $a1		# $s1 <-- primera ecuacion direccion.
	 
Ec2: 		move $a0, $s2
		jal String2Ecuacion 
	
		beq $v0, 1, Error	# Errores arriba. 
		beq $v0, 2, Error
		beq $v0, 3, Error
		beq $v0, 4, Error
		move $s2, $a1 		# $s2 <-- segunda ecuacion direccion
		# Sino se da ninguna de las anteriores condciones, la ecs es correcta, guardo su direccion. 
		# ¡OJO! Aunque ambas ecuaciones sean correctas pueden no tener los mismos parámetros. 
	
		lw $t0, 12($s1)
		lw $t1, 16($s1)
		lw $t2, 12($s2)
		lw $t3, 16($s2)
	
		#fenf
		bne $t0, $t2, distinto # incog1.a != incog2b --> Salta a 1ditinto
		beq $t0, $t3, codigo5	# incog1.a != incog2.b -->  Salta a Sistema incorrecto
		bne $t1, $t3, codigo5 	# incog1.b != incog2.b -->  Salta a Sistema incorrecto
		j correcto
			
distinto:	bne $t0, $t3, codigo5
		bne $t1, $t2, codigo5
		j  correcto 
codigo5: 	li $v0, 5
		j Error
		 
correcto:
		
		# Si pasa de aquí los parámetros son iguales. 
		move $a0, $s1
		move $a1, $s2 		# Cramer recibe como parametros ec1 en $a0 y ec2 en $a1, este ultimo ya está cargado. 
		jal Cramer
	
		move $s0, $a2 		# $s2 <-- direccion de la solucion. 
		move $a0, $s0
	
		jal Solucion2String
	
		move $a2, $a1	# ResuelveSistema hace return en $a2, mientras que Solucion2String en $a1. 
		move $v0, $zero
	
Error:  	lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)			#Guardamos el contenido original de $s0 en la pila
		lw $s2, 12($sp)			#Guardamos el contenido original de $s1 en la pila
		addi $sp, $sp, 12
		jr $ra
	
# FIN ResuelveSistema.
 
# COMIENZO SOLUCION2STRING: $a0 - input_sol; $a1 - output_string
.data
Indeterminado:	.asciiz "INDETERMINADO"
Incompatible:	.asciiz "INCOMPATIBLE"
.text
Solucion2String:addi $sp, $sp, -12
		sw $ra, 8($sp)			#Guardamos la direccion de retorno original en la pila
		sw $s0, 4($sp)			#Guardamos el contenido original de $s0 en la pila
		sw $s1, 0($sp)			#Guardamos el contenido original de $s1 en la pila
		
		move $s0, $a0
		move $s1, $a1

		lw $t0, 0($s0)			#Obtenemos el tipo de solucion
		beq $t0, 1, Sol2StrIndet 
 		beq $t0, 2, Sol2StrIncom
 		
 		lw $t0, 28($s0)			#Escribimos la primera variable y el =
 		sb $t0, 0($s1)
 		li $t0, 61			
 		sb $t0, 1($s1)	
 				
 		addi $a1, $s1, 2		#Escribimos parte entera del primer numero
 		lw $a0, 4($s0)
 		jal itoa
 		move $s1, $v0
 		
 		lw $t1, 12($s0)			#Obtenemos la parte decimal
 		beq $t1, $zero, Sol2StrSegNum	#Si no hay decimales, hemos acabado
 		li $t0, 46			#Escribimos la coma
 		sb $t0, 0($s1)
 		lw $t1, 8($s0)			#Obtenemos el número de 0s
 		addi $s1, $s1, 1
 		beq $t1, $zero, Sol2StrDecPrim
 		
Sol2StrCerosPrim:li $t0, 48
 		sb $t0, 0($s1)
 		addi $s1, $s1, 1
 		addi $t1, $t1, -1
 		bne $t1, $zero, Sol2StrCerosPrim
 		
Sol2StrDecPrim:	lw $a0, 12($s0)
		move $a1, $s1
		jal itoa
		move $s1, $v0
		
Sol2StrSegNum:	li $t0, 32			#Escribimos el espacio
		sb $t0, 0($s1)
		addi $s1, $s1, 1
		
		lw $t0, 32($s0)			#Escribimos la segunda variable y el =
 		sb $t0, 0($s1)
 		li $t0, 61			
 		sb $t0, 1($s1)			
 		
 		addi $a1, $s1, 2		#Escribimos parte entera del segundo numero
 		lw $a0, 16($s0)
 		jal itoa
 		move $s1, $v0
 		
 		lw $t1, 24($s0)			#Obtenemos la parte decimal
 		beq $t1, $zero, Sol2StrFin	#Si no hay decimales, hemos acabado
 		li $t0, 46			#Escribimos la coma
 		sb $t0, 0($s1)
 		lw $t1, 20($s0)			#Obtenemos el número de 0s
 		addi $s1, $s1, 1
 		beq $t1, $zero, Sol2StrDecSeg
 		
Sol2StrCerosSeg:li $t0, 48
 		sb $t0, 0($s1)
 		addi $s1, $s1, 1
 		addi $t1, $t1, -1
 		bne $t1, $zero, Sol2StrCerosSeg
 		
Sol2StrDecSeg:	lw $a0, 24($s0)
		move $a1, $s1
		jal itoa
		j Sol2StrFin
		
Sol2StrIndet:	la $t1, Indeterminado
		j Sol2StrExcep
Sol2StrIncom:	la $t1, Incompatible
Sol2StrExcep:	lb $t0, 0($t1)			#Escribimos el mensaje resultado adecuado
		sb $t0, 0($a1)
		addi $t1, $t1, 1
		addi $a1, $a1, 1
		bne $t0, $zero, Sol2StrExcep	#Cuando lleguemos al caracter \0, se ha terminado la copia
Sol2StrFin:	lw $s1, 0($sp)			#Restauramos $s1
		lw $s0, 4($sp)			#Restauramos $s0
		lw $ra, 8($sp)			#Restauramos $ra
		addi $sp, $sp, 12
		jr $ra
   	
# FIN SOLUCION2STRING	

# COMIENZO ITOA: $a0 - numero a convertir; $a1 - direccion de la cadena resultado; $v0 - ultima posicion
.data
NumeroEspecial: .asciiz "-2147483648"
.text
itoa:		beq $a0, -2147483648, ItoaEspecial#En caso de que sea -2147483648 complica mucho la aritmetica, mejor tratarlo aparte
		move $t0, $a0 
		move $t1, $a1
		li $t2, 10 
	
ItoaCont:	div $t0, $t2			#Buscamos la ultima posicion a escribir
		mflo $t0
		addi $t1, $t1, 1		
		bne $t0, $zero, ItoaCont
		move $v0, $t1
	
		ble $zero, $a0, ItoaPositivo	#Comprobamos si es negativo 
		li $t0, 45			
		sb $t0, 0($a1)			#Escribimos un - en la primera posicion
		sub $a0, $zero, $a0		#Cambio de signo
		addi $t1, $t1, 1		#Escribimos el terminador de cadena (en caso de ser negativo se hace en el siguiente byte)
ItoaPositivo:	sb $zero, 0($t1)		#Escribimos el terminador de cadena
	
ItoaBucle:  	div $a0, $t2			
		mfhi $t0			#Resto -> $t0
		mflo $a0			#Cociente -> $a0
		addi $t1, $t1, -1
		addi $t0, $t0, 48		#Los numeros ASCII empiezan en el 48	
		sb $t0, 0($t1)
		bne $a0, $zero, ItoaBucle	#Si el cociente es 0, hemos terminado
		jr $ra
	
		#Caso especial
ItoaEspecial:	la $t1, NumeroEspecial		#Copiamos la cadena NumeroEspecial en la direccion a la que apunta $a1
ItoaBucEspecial:lb $t0, 0($t1)
		sb $t0, 0($a1)
		addi $t1, $t1, 1
		addi $a1, $a1, 1
		bne $t0, $zero, ItoaBucEspecial	#Cuando lleguemos al caracter \0, se ha terminado la copia
		jr $ra
# FIN ITOA
