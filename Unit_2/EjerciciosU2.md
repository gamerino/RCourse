# **Trabajo Práctico 2: Herramientas de análisis exploratorio.**

Esta guía de ejercicios está destinada a fortalecer la formación práctica en torno a los conceptos desarrolados en la Unidad 2 del curso.

## Ejercicios

#### Ejercicio 1

Considere el conjunto de datos `Survival` del repositorio de datos de *Machine Learning* de [UCI](https://archive.ics.uci.edu/ml/index.php) de Haberman (1976). El *dataset* contiene datos de un estudio realizado a pacientes que sobrevivieron a una cirugía de cáncer de mama entre 1958 y 1970 en el Hospital Billings de la Universidad de Chicago.

- **a.** Estudie qué variables contiene el conjunto de datos.
- **b.** Descargue el conjunto de datos, guárdelo en un archivo y cárguelo en `R`.
- **c.** Redefina la variable `Survival` de manera que si el registro es un `1`, entonces el nuevo valor sea `al menos 5` y si el registro fue `2`, sea `menos de 5`, en referencia a la cantidad de años de sobrevida post-cirugía.
- **d.** Caracterice las variables observadas en término de medidas resumen estadísticas y gráficos útiles como los diagramas de cajas.
- **e.** Utilice herramientas gráficas para analizar posibles relaciones entre las variables del *dataset* y concluya en función de los resultados.


#### Ejercicio 2
Considere la base de datos `iris`.
- **a.** Caracterice las variables observadas en término de medidas resumen estadísticas.
- **b.** Explore la distribución de los datos en forma global y para cada especie. ¿Son similares?
- **c.** Encuentre, para cada especie, el valor medio de la longitud  y ancho del sépalo y del pétalo y compare con los valores medios de tales variables encontrados para todo el conjunto de datos.
- **d.** Encuentre, para cada especie, la correlación entre la longitud y el ancho del sépalo. ¿Son diferentes?
- **e.** Construya un gráfico que permita explorar posibles relaciones entre ancho y largo de pétalo de cada especie.

#### Ejercicio 3
Trabaje con la base de datos `polyps3`, *Familial Adenomatous Polyposis*, del paquete `HSAUR2`.
- **a.** Describa las variables que conforman este conjunto de datos.
- **b.** Encuentre los cuantiles, la media, el máximo, mínimo, rango intercuarílico, la varianza y el desvío estándar de las variables `baseline` y `numb3m`.
- **c.** Construya diagramas de cajas para estas variables, teniendo en cuenta la separación entre tratamientos. ¿Que opina de los datos a partir de lo observado? Considere ahora los distintos sexos, y rehaga los diagramas de caja. ¿Cambia algo?
- **d.** Obtenga la tabla de frecuencias que ilustra la cantidad de personas de cada sexo que han recibido los distintos tratamientos
- **e.** Construya diagramas de dispersión entre las variables `age`, `baseline` y `numb3m`. ¿Qué observa?
- **f.** Repita los gráficos del punto anterior, teniendo en cuenta los distintos sexos y distintos tratamientos. ¿Qué opina al respecto?

#### Ejercicio 4
Considere un conjunto de datos del paquete `HSAUR2` que involcure tanto variables continuas como categóricas y realice una análisis exploratorio considerando los siguientes aspectos:
- **a.** Medidas resumen y tablas de frecuencias.
- **b.** Distribución de los datos.
- **c.** Relaciones entre variables: tablas de frecuencias, diagramas de dispersión, etc.
