# **Trabajo Práctico 1: Introducción a R**
(UGarte)
Esta guía de ejercicios está destinada a fortalecer la formación práctica en torno a los conceptos desarrolados en la Unidad 1 del curso.

## Ejercicios

#### Ejercicio 1: Operaciones básicas
Obtenga el resultado de las siguientes operaciones con `R`, considerando tres posiciones decimales.
- **a.** $(7-8)+ 53 − \frac{5}{6} +\sqrt{62}$
- **b.** $ln(3) + \sqrt{2}\sin(\pi)-e^3$
- **c.** $2 × (5 + 3) −\sqrt{6}+92$

#### Ejercicio 2: Vectores y secuencias
**2.1** Cree un vector llamado `miVector` que contenga la secuencia de números de 3 a 90 en pasos de 3.
**2.2** Considere dos vectores, $p=(3,5,6,9)$ y $q=(2,2,2,1)$.
  - **a.** Defina $p$ y $q$
  - **b.** Obtenga $p+q$ y $p-q$.
  **2.3**
Cree los vectores `u=(1,2,3,5,7,11)`, `v=(1,2,4,6,8,11)`.
- **a.** Obtenga las posiciones de los elementos de `v` que están en `u`
.
- **b.** Obtenga el vector resultante de los elementos de `u` y `v`.
- **c.** Obtenga las posiciones de los elementos de `v` que son mayores que el valor medio de  `u`.
- **d.** Encuentre el resultado del producto escalar entre `u` y `v`.

**2.4** Sean los siguientes vectores
```
Edad <- c(40, 28, 35, 47)
Nombre <- c("Pedro", "Clara", "Ana", "Carlos")
Ocupacion <- c("Oculista", "Profesor", "Oculista", "Profesor")
```
¿Cuál es el código `R` para obtener:

```
##   Edad   Nombre   Ocupacion
## 1  40    Pedro   Oculista
## 2  35    Ana     Oculista
```

**2.5** Sea

```
x <- c(34, 56, 55, 87, NA, 4, 77, NA, 21, NA, 39)
```

 - **a.**¿Cómo haría para contar el total de `NAs` que tiene el vector?
 - **b.** ¿Cómo haría para mantener todos los valores numéricos que tiene `x`?

 **2.6** Considere el conjunto de datos `mtcars`

 - **a.** Consulte el ayuda de `R` para obtener información acerca de esta base de datos.
 - **b.** Use operadores lógicos para conservar sólo aquellos registros de `mtcars` que contienen valores de `mpg` mayores a 20 y menores a 25, valores de `cyl` iguales a 4 y con `am` distinto de 0.
 - **c.** Extraiga las observaciones correspondientes a la situación en que los valores de `vs` y `am` son diferentes.  

#### Ejercicio 3: Factores
**3.1** Cree un vector llamado `Tratamiento`, que contenga los valores `A`, 20 veces, `B` 10 veces y `C`, 15 veces. Obtenga la tabla de frecuencias correspondiente que muestre tales frecuencias.
**3.2** Considere el conjunto de datos `iris`. A partir de él cree un factor que defina si el pétalo es corto (1-3), mediano (3-4) o largo (más de 5). Sugerencia: investigue la función `cut()`.
**3.3** Cambie la denominación de las especies del conjunto de datos `iris` de *setosa*, *versicolor* y *virginic* a *SE*, *VE*, y *VI*, respectivamente.


#### Ejercicio 4: Matrices

**4.1** Dados `u=(1,2,3,5,7,11)`, `v=(1,2,4,6,8,11)`.
- **a.** Defina la matriz **X** cuyas columnas son los vectores `u` y `v`.
- **b.** Encuentre las dimensiones y la traza de **X**.
- **c.** Defina la matriz **Y** cuyas filas son los vectores `u` y `v`.
- **d.** Obtenga el resultado del producto entre **X** e **Y**.

#### Ejercicio 5: data.frames y listas
**5.1** Cree una matriz, **M**, cuyas columnas sean los vectores: `dia=(lunes, martes, miercoles, jueves, viernes)`, `doctor=(Zapata, Correa,Zapata,Cuenca,Cuenca)`, `horario=(14:30,15:15,14:30,10:45,12:15)` y `consultorio=(1,2,1,2,2)`.

- **a.** Defina el `data.frame`, `planilla`, a partir de la matriz **M**.
- **b.** Acceda a los días y horarios de atención del doctor "Cuenca".
- **c.** Modifique el nombre de las columnas del objeto `planilla` para que todos comiencen con mayúsculas.
- **d.** Redefina la variable consultorio para que los posibles valores sean `A`, para el consultorio 1, y `B`, para el consultorio 2.
- **e.** Defina una función que permita obtener los días y horarios de atención de cualquier doctor, según lo especifique el usuario.

**5.2** Defina una lista, `L` que contenga las matrices **X**, **Y** y **M**.

- **a.** Acceda, a través de `L`, al segundo elemento de **Y**.
- **b.** Obtenga las dimensiones de los elementos de `L`.
## Ejercicio 6: Ciclos y estructuras de control.

**6.1** Obtenga la clase de cada uno de los elementos de la matriz `L` del ejercicio **5.2** utilizando:
  - **a.** Un ciclo `for`
  - **b.** La función `lapply`

**6.2** Cree un vector de longitud igual a la cantidad de observaciones de `iris` y donde cada elemento sea `mayor a 5` si se cumple que `Sepal.Length` es $>5$ o `menor a 5`, en caso contrario, utilizando
  - **a.** Un ciclo `for`
  - **b.** La función `apply`
  - **c.** La sentencia `ifelse`

**6.3** Cree un ciclo `while` que imprima en cada iteración un número obtenido aleatoriamente a partir de la distribución normal estándar pero que se detenga si el número es mayor a 1. Sugerencia: use `rnorm()`.  


#### Ejercicio 6: Funciones definidas por el usuario

**6.1** Implemente las siguientes funciones:
- **a.** `simon.dice`: Esta función debe tomar una cadena de caracteres proporcionada por el usuario y devolver un mensaje incluyendo esa cadena de caracteres luego de la frase "Simón dice: ".

- **b.** `IQR`, para el cálculo del rango intercuartílico de un vector de datos.

- **c.** `greater`: Función que recibe una matriz y un número y devuelve un valor lógico que indica si más de la mitad de los elementos de la matriz son mayores que el número especificado.

- **d.** `prodMat`, para que tome dos matrices y devuelva un valor lógico que indique si dichas matrices pueden ser multiplicadas.

- **e.** `size`: Función que recibe un objeto y, si éste es una matriz o `data.frame`, devuelve sus dimensiones, mientras que si es un vector devuelve su longitud. En el caso de que el objeto sea una lista además de su longitud devuelve el tipo de dato que almacena cada elemento de ésta.

**6.2** Cree una función que, dado un `data.frame`, imprima el nombre de cada columna junto con el nombre del tipo de dato que contiene (Ej. Variable1 es Numeric).

**6.3** Cree una función que reciba un vector `V` y un entero `x` y devuelva el número de veces que `x` aparece en `V`.

#### Ejercicio 7: Importando y exportando datos en `R`

**7.1** Explore el uso de las funciones `read.table()`, `read.delim()` y `read.csv()`.

**7.2** Explore el uso de las funciones `write.table()` y `write.csv()`.

**7.3** Almacene el conjunto de datos `iris` en un archivo llamado `iris.tab`, de formato tabular, donde cada columna conserve su nombre y luego en un archivo llamado `iris.csv`, con formato separado por comas y sin conservar el nombre de las columnas.

**7.4** Cargue en `R` los datos almacenados en el punto **7.3**.


#### Ejercicio 8
Elija una base de datos del paquete `HSAUR2` y realice las siguientes actividades.
- **a.** Describa brevemente la base de de datos en términos de número de registros u observaciones, variables almacenadas, tipos de datos, etc.
- **b.** Considere cada variable en forma individual y caracterícela.
- **c.** Obtenga a partir de la base de datos, subconjuntos de datos definidos mediante criterios y/o umbrales sobre las variables observadas. Por ejemplo, si una variable es `peso`, considere un subconjunto aquel formado por todas las observaciones cuyo valor de `peso` registrado es menor a 50.
