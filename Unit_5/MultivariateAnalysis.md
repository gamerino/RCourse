# Unidad 5: Análisis Multivariado en R.

## 1. Introducción

### 1.1 Datos multivariados

En esta unidad se estudiarán algunas de las herramientas del análisis multivariado en el entorno `R`. La mayoría de los conjuntos de datos en todas las disciplinas son multivariados, es decir, continen medidas u observaciones de diferentes variables tomadas en las mismas unidades experimentales. Por lo general, las bases de datos multivariados estarán organizadas en lo que se conoce como *forma rectangular*, donde los elementos de cada fila se corresponden con los valores de las variables observadas para un caso particular. Es así que las columnas de estos conjuntos de datos representan las distintas variables observadas. En términos matriciales, podemos pensar a la *matriz de datos*, $\boldsymbol{X}$ como una matriz de dimensiones $n\times q$:

$$
\begin{equation}

\boldsymbol{X}=\begin{bmatrix}  x_{11} & ... & x_{1j} &...& x_{1q}\\ \vdots & & \vdots & & \vdots \\x_{i1} & ... & x_{ij} &...& x_{iq}\\ \vdots & & \vdots & & \vdots \\x_{n1} & ... & x_{nj} &...& x_{nq}\end{bmatrix}
\label{EC1}
\tag{1}
\end{equation}
$$

donde $n$ es el número de observaciones y $q$ es el número de variables registradas en cada observación. Ahora bien, en contraste con esta matriz de observaciones, las entidades teóricas que describen las distribuciones univariadas de cada una de las $q$ variables de interés son variables aleatorias $X_1$, $...$, $X_q$. Dado que el conjunto de variables es observado o medido en cada unidad, las variables suelen estar relacionadas por lo que, para revelar y comprender la estructura subyacente al conjunto de datos, resulta fundamental analizar estadísticamente todas las variables en simultáneo mediante el análisis multivariado. Las unidades en un conjunto de datos multivariado son muchas veces seleccionadas aleatoriamente de una población de interés.

Los métodos de análisis multivariado pueden estar dirigidos a la descripción, exploración e inferencia de los datos. Por un lado, la exploración de datos multivariados se utilizan herramientas que permiten la detección de patrones, novedosos o no, útiles para la caracterización o explicación de ciertas estructuras dentro de los datos. Estos métodos se suelen caracterizar por la importancia que cobran las herramientas gráficas y de visualización y la falta de modelos estadísticos o probabilísticos útiles para inferencias posteriores. Por el contrario, las técnicas de análisis multivariado más formales y rigurosas son útiles cuando el objetivo del estudio es la inferencia estadística sobre el comportamiento de cierta población a estudiar a partir de los datos observados. Sea cual fuera el caso, la aplicación de las técnicas de análisis multivariado requiere de herramientas informáticas potentes útiles además para la construcción de gráficos y diagramas apropiados para la comprensión de los resultados, como lo es el entorno `R`.

### 1.2 Covarianzas, correlaciones y distancias
La principal razón por la que queremos analizar datos multivariados usando métodos multivariados en vez de estudiar cada variable en forma individual es que, probablemente, cualquier estructura o patrón que exista entre los datos esté implícito ya sea en las *relaciones* entre las variables y/o en la *proximidad* entre distintas observaciones. En el primer caso, cualquier patrón o estructura que se descubre será tal que involucre o implique cierta relación entre dos o más variables. Mientras, en el segundo caso, nos referimos a cualquier estructura que pueda descubrirse a partir de la consideración de diferentes subconjuntos de datos u observaciones. La pregunta ahora es, ¿cómo medimos o cuantificamos las relaciones entre variables o las distancias entre las diferentes unidades observadas?

#### 1.2.1 Covarianza
La *covarianza* de dos variables aleatorias, $X_i$ y $X_j$, es una medida de su *dependencia lineal*. La covarianza poblacional se define mediante la [Ecuación 2](EC2),

$$
\begin{equation}

Cov(X_i,X_j)=\sigma_{ij}^2=E[(X_i-\mu_i)(X_j-\mu_j)]
\label{EC2}
\tag{2}
\end{equation}
$$
donde $\mu_i=E(X_i)$ y $\mu_j=E(X_j)$. Note que si $i=j$ entonces $Cov(X_i,X_i)=Var(X_i)=\sigma^2_i$. Por otro lado, si $X_i$ y $X_j$ son *independientes*, entonces $Cov(X_i,X_j)=0$, mientras que a medida que más aumenta el grado de dependencia entre $X_i$ y $X_j$ mayor es su covarianza.

En el caso de un conjunto de datos con $q$ variables observadas, es posible encontrar $q$ varianzas y $q(q-1)/2$ covarianzas, que en su conjunto definen la *Matriz de varianzas y covarianzas*, $\Sigma$:

$$
\begin{equation}

\boldsymbol{\Sigma}=\begin{bmatrix}  \sigma^2_{1} & ... & \sigma_{1i} &...& \sigma_{1q}\\ \vdots & & \vdots & & \vdots \\\sigma_{1i} & ... & \sigma^2_{i} &...& \sigma_{iq}\\ \vdots & & \vdots & & \vdots \\\sigma_{1q} & ... & \sigma_{iq} &...& \sigma^2_{q}\end{bmatrix}_{qxq}
\label{EC3}
\tag{3}
\end{equation}
$$

Note que $\boldsymbol{\Sigma}$ es una matriz simétrica, ya que $\sigma_{ij}=\sigma_{ji}$. A partir de un conjunto de observaciones, $\boldsymbol{X}$, $\boldsymbol{\Sigma}$ se estima según la [Ecuación 4](EC4),

$$
\begin{equation}
\boldsymbol{S}=\frac{1}{n-1}\sum\limits_{i=1}^n(\boldsymbol{x}_i-\overline{\boldsymbol{x}})(\boldsymbol{x}_i-\overline{\boldsymbol{x}})^T

\label{EC4}
\tag{4}
\end{equation}
$$

donde $\boldsymbol{x}_i^T=(x_{i1},...x_{ij},...,x_{iq})$ es el vector de observaciones (numéricas) para el *i-ésimo* individuo, y $\overline{\boldsymbol{x}}=n^{-1}\sum_{i=1}^n\boldsymbol{x}_i$ es el vector promedio de las observaciones. Note que la diagonal principal de $\boldsymbol{S}$ contiene las varianzas muestrales,$s^2_j$ de las $q$ variables numéricas.

En `R` es sencillo obtener la matriz de varianzas y covarianzas de un conjunto multivariado, mediante la función `cov()`:

```
> cov(iris[,-which(names(iris)=="Species")])

Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    0.6856935  -0.0424340    1.2743154   0.5162707
Sepal.Width    -0.0424340   0.1899794   -0.3296564  -0.1216394
Petal.Length    1.2743154  -0.3296564    3.1162779   1.2956094
Petal.Width     0.5162707  -0.1216394    1.2956094   0.5810063
```
**Nota**: Recuerde que la covarianza está definida para variables numéricas.

Si buscamos, por ejemplo, conocer la matriz de covarianzas para cada especie, entonces podemos usar

```
> by(iris[,1:4], iris$Species, var)
iris$Species: setosa
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length   0.12424898 0.099216327  0.016355102 0.010330612
Sepal.Width    0.09921633 0.143689796  0.011697959 0.009297959
Petal.Length   0.01635510 0.011697959  0.030159184 0.006069388
Petal.Width    0.01033061 0.009297959  0.006069388 0.011106122
---------------------------------------------------------------------
iris$Species: versicolor
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length   0.26643265  0.08518367   0.18289796  0.05577959
Sepal.Width    0.08518367  0.09846939   0.08265306  0.04120408
Petal.Length   0.18289796  0.08265306   0.22081633  0.07310204
Petal.Width    0.05577959  0.04120408   0.07310204  0.03910612
---------------------------------------------------------------------
iris$Species: virginica
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length   0.40434286  0.09376327   0.30328980  0.04909388
Sepal.Width    0.09376327  0.10400408   0.07137959  0.04762857
Petal.Length   0.30328980  0.07137959   0.30458776  0.04882449
Petal.Width    0.04909388  0.04762857   0.04882449  0.07543265
```
#### 1.2.2 Correlación

A veces es difícil de interpretar la covarianza ya que depende de las escalas en las que se miden las variables de interés, por lo que comúnmente, se suele estandarizarla dividiendola por el producto de los desvíos estándars de las dos variables de interés. Esta cantidad es la que se conoce como *coeficiente de correlación*,

$$
\begin{equation}

r_{ij}=\frac{\sigma_{ij}}{\sigma_i\sigma_j}

\label{EC5}
\tag{5}
\end{equation}
$$
El coeficiente de correlación, también llamado coeficiente de correlación de Pearson, es una medida estandarizada que toma valores entre -1 y 1 y brinda información de la relación lineal entre dos variables $X_i$ y $X_j$. Si $r_{ij}$ es positivo, entonces los valores elevados de $X_i$ se asocian con valores elevados de $X_j$, mientras que si es negativo, valores elevados de $X_i$ se asocian con valores bajos de $X_j$ y viceversa. Si NO hay relación lineal entre estas variables, $r_{ij}=0$ y si la relación no es lineal, el valor de $r_{ij}$ puede ser engañoso.

Las $q(q-1)/2$ correlaciones entre $q$ variables se presentan en la *Matriz de correlación*, de dimensión $q$x$q$, cuya diagonal principal contiene sólo valores iguales a la unidad (1). A partir de un conjunto de datos observados, la forma de obtener la matriz de correlación, comúnmente denotada como $\boldsymbol{R}$ es a partir de las estimaciones de los $r_{ij}$. En términos de la matriz de varianzas y covarianzas muestrales,

$$
\begin{equation}
\boldsymbol{R}=\boldsymbol{D}^{-1/2}\boldsymbol{S}\boldsymbol{D}^{-1/2}
\label{EC6}
\tag{6}
\end{equation}
$$

donde $\boldsymbol{D}^{-1/2}=diag(1/s_1,..., 1/s_q)$ y $s_i=\sqrt{s^2_i}$
En `R` podemos obtener la matriz de correlaciones muestrales utilizando la función `cor()`:

```
> cor(iris[,-which(names(iris)=="Species")])
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000
> by(iris[,1:4], iris$Species, cor)
iris$Species: setosa
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000   0.7425467    0.2671758   0.2780984
Sepal.Width     0.7425467   1.0000000    0.1777000   0.2327520
Petal.Length    0.2671758   0.1777000    1.0000000   0.3316300
Petal.Width     0.2780984   0.2327520    0.3316300   1.0000000
---------------------------------------------------------------------
iris$Species: versicolor
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000   0.5259107    0.7540490   0.5464611
Sepal.Width     0.5259107   1.0000000    0.5605221   0.6639987
Petal.Length    0.7540490   0.5605221    1.0000000   0.7866681
Petal.Width     0.5464611   0.6639987    0.7866681   1.0000000
---------------------------------------------------------------------
iris$Species: virginica
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000   0.4572278    0.8642247   0.2811077
Sepal.Width     0.4572278   1.0000000    0.4010446   0.5377280
Petal.Length    0.8642247   0.4010446    1.0000000   0.3221082
Petal.Width     0.2811077   0.5377280    0.3221082   1.0000000
```
Como se mencionó anteriormente, el coeficiente de correlación de Pearson indica el grado de relación *lineal* entre dos variables. Hay otros coeficientes de correlación que son más indicados cuando las relaciones son no lineales, uno de los más populares el *coeficiente de correlación de Spearman*. Este coeficiente, usualmente denotado por $\rho_{X_i,X_j}, se obtiene calculando la correlación de Pearson de los vectores definidos según los rankings (ordenamientos) de las observaciones de las variables de interés.

```
> by(iris[,1:4], iris$Species, cor, method='spearman')
iris$Species: setosa
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000   0.7553375    0.2788849   0.2994989
Sepal.Width     0.7553375   1.0000000    0.1799110   0.2865359
Petal.Length    0.2788849   0.1799110    1.0000000   0.2711414
Petal.Width     0.2994989   0.2865359    0.2711414   1.0000000
---------------------------------------------------------------------
iris$Species: versicolor
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000   0.5176060    0.7366251   0.5486791
Sepal.Width     0.5176060   1.0000000    0.5747272   0.6599826
Petal.Length    0.7366251   0.5747272    1.0000000   0.7870096
Petal.Width     0.5486791   0.6599826    0.7870096   1.0000000
---------------------------------------------------------------------
iris$Species: virginica
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000   0.4265165    0.8243234   0.3157721
Sepal.Width     0.4265165   1.0000000    0.3873587   0.5443098
Petal.Length    0.8243234   0.3873587    1.0000000   0.3629133
Petal.Width     0.3157721   0.5443098    0.3629133   1.0000000
```
Al tener en cuenta los rankings, la correlación de Spearman evalúa la relación monotónica entre dos variables continuas. En una relación monotónica, las variables tienden a cambiar juntas, no necesariamente a una tasa constante (lineal). El coeficiente $\rho$ es utilizado a menudo para evaluar relaciones con variables ordinales.

#### 1.2.3 Distancia

El concepto de *distancia* cobra importancia en el caso de aquellos métodos multivariados que determinan evaluar la similaridad entre distintas obaservaciones. La medida más común de distancia es la que ustedes seguramente han utilizado en diversos campos, y es la *distancia Euclidea*:

$$
\begin{equation}
d_{ij}=\sqrt{\sum\limits_{k=1}^q(x_{ik}-x_{jk})^2}
\label{EC7}
\tag{7}
\end{equation}
$$

donde $x_{ik}$ y $x_{jk}$, con $k=1,...,q$ son los valores de las variables para las observaciones $i$ y $j$, respectivamente. En `R`, la función `dist()` permite obtener la distancia Euclidea. Por ejemplo,

```
> dist(iris[1:4,1:4])
          1         2         3
2 0.5385165                    
3 0.5099020 0.3000000          
4 0.6480741 0.3316625 0.2449490
```

permite obtener la matriz de distancias Euclideas entre las primeras cuatro observaciones de las variables numéricas del conjunto de datos `iris`.
**Nota**: La distancia no es una medida estandarizada, por lo que su valor puede estar influenciado por las escalas en que se miden las variables. Es por ello que en ocasiones conviene calcular las distancias sobre conjuntos de datos *escalados*
**Ejercicio**: explore la función `scale()`

### 1.3 Función de densidad normal multivariada
Así como gran parte de las técincas de análisis univariado se basan en la distribución normal univariada, en el campo del análisis multivariado, muchos métodos asumen distribución normal multivariada de los datos. Sea un vector de $q$ variables, $\boldsymbol{x}^T=(x_1, x_2,...x_q)$, la *función de densidad normal multivariada* es

$$
\begin{equation}
f(\boldsymbol{x};\boldsymbol{\mu}, \boldsymbol{\Sigma})=(2\pi)^{-\frac{q}{2}}det(\Sigma)^{-\frac{q}{2}}e^{\{-\frac{1}{2}(\boldsymbol{x}-\boldsymbol{\,u})^T\boldsymbol{\Sigma}^{-1}(\boldsymbol{x}-\boldsymbol{\,u})\}}
\label{EC8}
\tag{8}
\end{equation}
$$

donde $\boldsymbol{\mu}$ y $\boldsymbol{\Sigma}$ son el vector de medias y la matriz de varianzas y covarianzas, poblacionales, de las $q$ variables.
Una propiedad importante de una función de densidad normal multivariada es que la combinación lineal de variables es también normalmente distribuída. Es así que, si por ejemplo $y=a_1X_1+a_2X_2+...+a_qX_q$,  donde $\{a_i\}_q$ son esacalares, entonces $E(y)=\boldsymbol{a}^T\boldsymbol{\mu}$ y $Var(y)=\boldsymbol{a}^T\boldsymbol{\Sigma}\boldsymbol{a}$.


## Herramientas del análisis multivariado

En la Unidad 2 hemos estado trabajando con datos multivariados (recuerda la base de datos `USmelanoma`), aunque solo hemos analizado algunas de las posibilidades de exporación multivariada, en la sección 2.4.4.

### Análisis de Componentes Principales (Zelterman)

El *Análisis de Componentes Principales* (*Principal Component Analysis, PCA*)



### Análisis en conglomerados (clustering) (wehrens, sino Zelterman)

### Discriminante Lineal (Wehrens,Zelterman)

### árboles de decisión (both, datacamp (marcador Google), clasif fischetti)
