Antes de sumergirnos en las (otras) cosas divertidas (distribuciones de probabilidad, modelos lineales, pruebas de hipótesis, análisis de correlación, etc.),
vamos a aprender a usar `R` y todas sus facilidades, que utilizaremos luego en las unidades posteriores. `R` se usa tanto para el desarrollo *software* como para el análisis de datos. Durante este curso, vamos a trabajar en un área gris, en algún lugar entre estas dos tareas. Nuestro objetivo principal será analizar datos, pero también realizaremos ejercicios de programación que ayuden a ilustrar ciertos conceptos y que nos provean herramientas para poder desarrollar nuestras propias herramientas de análisis.

# Introducción
## Conociendo R
`R` es tanto un lenguaje de programación como un software útil para la manipulación y el análisis de datos. Es gratis y *open-source*, tanto la distribución base de `R` así como también un gran número de paquetes desarrollados por los usuarios están libremente disponibles bajo los términos de la licencia GNU. Esta licencia tiene dos implicaciones principales para el analista de datos que trabaja con R. Por un lado, el código fuente completo está disponible y, por lo tanto, es posible investigar los detalles de la implementación de un método especial. También se pueden realizar cambios de métodos existentes y distribuir las modificaciones hechas a sus colegas. Consecuentemente, el sistema `R` para la informática estadística está disponible para todos. Todos los científicos, tienen acceso a herramientas de vanguardia para el análisis de datos estadísticos sin costos adicionales. Con la ayuda del sistema `R`, la investigación realmente se vuelve reproducible cuando los datos y los resultados de todos los pasos de análisis de datos informados en un documento están disponibles para los lectores en un *script*.
El sistema `R` para análisis estadístico consiste de la distribución base y una colección de paquetes (*packages*). `R` está implementado en la distribución base, la cual es mantenida por un pequeño grupo de estadísticos, el *Equipo Principal de Desarrollo R* (*R core team*). Las implementaciones de los distintos métodos de análisis y funcionalidades están organizadas en los paquetes. Un paquete contiene clases, métodos, funciones, ejemplos y documentación útiles para cumplir un fin. Los paquetes son creados y mantenidos por los propios usuarios y muchas veces son gestionados en repositorios. La principal fuente de información sobre el sistema `R` está en la  [página web oficial](http://www.R-project.org) de la red mundial del proyecto.
### Por qué usar R?
* Es libre.
* Es multiplataforma.
* Permite analizar todo tipo de datos.
* Es muy potente y rápido
* Tiene una gran capacidad gráfica.
* Es compatible con múltiples formatos de datos (.csv, .xls, .sav, .sas, .txt, etc.).
* Cuenta con una gran comunidad
### Instalación
Para comenzar es necesario instalar:

1. [`R`](http://mirror.fcaglp.unlp.edu.ar/CRAN/), el lenguaje y entorno de programación.
2. [`RStudio`](https://www.rstudio.com/products/RStudio/), un entorno de desarrollo integrado para trabajar con `R`.

Tanto `R` como `RStudio` están disponibles para Windows, Mac, y Linux. Se recomienda siempre instalar la versión más nueva. La instalación de `RStudio` no es un requisito para utilizar `R` pero sí es una muy buena ayuda, fundamentalmente para los nuevos usuarios.  

### RStudio
`RStudio` el principal entorno de desarrollo integrado para. Está disponible en ediciones *open source* y comercial, en una versión de escritorio y una versión web  a un servidor Linux que ejecuta RStudio Server o RStudio Server Pro. La interfaz de `Rstudio` incluye una consola, un editor de texto, un gestor del espacio de trabajo y un área de soporte al ususario (Ver [Figura 1](#Figura1)). El editor de texto provee herramientas útiles para la escritura de *scripts* como el resaltado de sintaxis que admite la ejecución directa de código. En el espacio de trabajo es posible explorar tanto los objetos que están actualmente cargados o definidos así como también el historial de funciones y codigo ejecutado en la consola. En la sección de gráficos y ayuda es posible consultar los archivos, gráficos, paquetes y toda la documentación para las diferentes funciones y métodos disponibles.

![Figura1](../Imagenes/Rstudio.png) ***Figura 1***: *Interfaz gráfica de `RStudio`.*

### Comencemos
Al abrir `RStudio` o `R` desde consola, se desplegará un breve mensaje donde se informa la versión instalada, seguido de un *prompt* `>`:

```
R version 3.5.0 (2018-04-23) -- "Joy in Playing"
Copyright (C) 2018 The R Foundation for Statistical Computing
Platform: x86_64-apple-darwin15.6.0 (64-bit)

R es un software libre y viene sin GARANTIA ALGUNA.
Usted puede redistribuirlo bajo ciertas circunstancias.
Escriba 'license()' o 'licence()' para detalles de distribucion.

R es un proyecto colaborativo con muchos contribuyentes.
Escriba 'contributors()' para obtener más información y
'citation()' para saber cómo citar R o paquetes de R en publicaciones.

Escriba 'demo()' para demostraciones, 'help()' para el sistema on-line de ayuda,
o 'help.start()' para abrir el sistema de ayuda HTML con su navegador.
Escriba 'q()' para salir de R.
>
```
En forma resumida, el programa evalúa los comándos escritos a continuación del *prompt* y devuelve los resultados de su ejecución:

```
> 2+4
[1] 6
```
O, una operación más compleja:

```
> x<-sqrt(16)+4
```
Esta órden implica que el intérprete de `R` calcule la raíz cuadrada (`sqrt`) de 16 y luego le sume 4. El resultado de esta operación es asignado a un objeto `R` llamado `x`. El operador de asignación `<-` vincula el valor de su lado derecho a la variable `x`, cuyo valor se puede inspeccionar haciendo:

```
> x
[1] 8
```

el cual implícitamente llama a la función `print`:

```
> print(x)
[1] 8
```

### Operaciones matemáticas básicas

Algunas de las operaciones matemáticas básicas que seguramente utilizaremos en cualquier código `R` están listadas a continuación.

| Expresión   | Código R          | Resultado |
|-------------|-------------------|-----------|
| $3+2$         | $3+2$               | 5         |
| $3-2$         | $3-2$               | 1         |
| $3\cdot2$         | $3*2$               | 6         |
| $\frac{3}{2}$         | $3/2$               | 1.5       |
| $3^2$         | $3$^$2$               | 9         |
| $2^{-3}$      | $2$^($-3$)           | 0.125     |
| $27^{1/3}$    | $27$^($1/3$)          | 3         |
| $100^{1/2}$   | $sqrt(100)$         | 10        |
| $ln(e)$       | $log(exp(1))$       | 1         |
| $log_{10}(1000)$ | $log10(1000)$      | 3         |
| $log_2$(8)     | $log2(8)$           | 3         |
| $log_4$(16)    | $log(16, base = 4)$ | 2         |
| $sen(0)$      | $sin(0)$            | 0         |
| $\cos(2\pi)$  | $cos(2*pi)$          | 1         |
