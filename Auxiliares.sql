--consulta 1 auxiliares
#ESTE ME TRAE TODOS LOS PARTIDOS CON SUS VOTOS TOTALES POR PARTIDO
(SELECT P.NOMBRE AS COUNTRY1, PAR.NOMBRE AS P_POLITCO1, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM ELECCION E, PAIS P, PARTIDO PAR, DETALLES_VOTOS DV
WHERE
DV.ID_ELECCION = E.ID_ELECCION AND
DV.ID_PARTIDO = PAR.ID_PARTIDO AND
E.ID_PAIS = P.ID_PAIS AND
PAR.ID_PAIS = P.ID_PAIS AND
P.NOMBRE IN (SELECT DISTINCT PAIS.NOMBRE FROM PAIS)
GROUP BY P.NOMBRE, PAR.NOMBRE) A


#ESTE ME TRAE EL MAXIMO POR PAIS
(SELECT SUB.COUNTRY2, MAX(SUB.VOTOS) AS MAXIMO FROM PARTIDO,
(SELECT P.NOMBRE AS COUNTRY2, PAR.NOMBRE AS P_POLITCO2, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM ELECCION E, PAIS P, PARTIDO PAR, DETALLES_VOTOS DV
WHERE
DV.ID_ELECCION = E.ID_ELECCION AND
DV.ID_PARTIDO = PAR.ID_PARTIDO AND
E.ID_PAIS = P.ID_PAIS AND
PAR.ID_PAIS = P.ID_PAIS AND
P.NOMBRE IN (SELECT DISTINCT PAIS.NOMBRE FROM PAIS)
GROUP BY P.NOMBRE, PAR.NOMBRE) SUB
WHERE PARTIDO.NOMBRE = SUB.P_POLITCO
GROUP BY SUB.COUNTRY) B;

#ESTA ME TRAE EL TOTAL DE LOS VOTOS POR PAIS
SELECT P.NOMBRE AS COUNTRY1, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_TOTAL FROM ELECCION E, PAIS P, PARTIDO PAR, DETALLES_VOTOS DV
WHERE
DV.ID_ELECCION = E.ID_ELECCION AND
DV.ID_PARTIDO = PAR.ID_PARTIDO AND
E.ID_PAIS = P.ID_PAIS AND
PAR.ID_PAIS = P.ID_PAIS AND
P.NOMBRE IN (SELECT DISTINCT PAIS.NOMBRE FROM PAIS)
GROUP BY P.NOMBRE;
-----------------------

--consulta 2 auxiliares
#TOTAL DE VOTOS DE TODAS LAS ELECCIONES
SELECT SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS TOTAL_VOTOS FROM DETALLES_VOTOS DV

#TOTAL DE VOTOS DE MUJERES ALFABETAS
SELECT SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV) AS MUJERES_ALFABETAS FROM DETALLES_VOTOS DV, ETNIA ET, SEXO S
WHERE S.NOMBRE = 'mujeres' AND ET.NOMBRE = 'INDIGENAS';
-----------------------

--consulta 3 auxiliares
#ESTE COMPRUEBA QUE SEA EL 100 PORCIENTO
SELECT PRINCIPAL.COUNTRY, SUM(PRINCIPAL.PORCENTAJE_MUNICIPIO) AS TOT FROM
(SELECT SEGUNDA.P_NOMBRE AS COUNTRY, SEGUNDA.TOTAL_VOTOS_PAIS, PRIMERA.MUNI, PRIMERA.TOTAL_MUN, (PRIMERA.TOTAL_MUN/SEGUNDA.TOTAL_VOTOS_PAIS)*100 AS PORCENTAJE_MUNICIPIO
FROM

#ME DEVUELVE EL TOTAL DE VOTOS DE MUJERES POR CADA MUNICIPIO DEL PAIS
(SELECT P.NOMBRE AS PAI, M.NOMBRE AS MUNI, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS TOTAL_MUN FROM DETALLES_VOTOS DV, SEXO S, PAIS P, MUNICIPIO M,
DEPARTAMENTO D, REGION R
WHERE M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND D.ID_REGION = R.ID_REGION AND R.ID_PAIS = P.ID_PAIS
AND S.NOMBRE = 'mujeres'
GROUP BY P.NOMBRE, M.NOMBRE) PRIMERA,

#ME DEVUELVE EL TOTAL DE VOTOS EN UN PAIS DONDE HAYA VOTADO UNA MUJER
(SELECT P.NOMBRE AS P_NOMBRE, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS TOTAL_VOTOS_PAIS FROM DETALLES_VOTOS DV, SEXO S, PAIS P, MUNICIPIO M,
DEPARTAMENTO D, REGION R
WHERE M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND D.ID_REGION = R.ID_REGION AND R.ID_PAIS = P.ID_PAIS
AND S.NOMBRE = 'mujeres'
GROUP BY P.NOMBRE
) SEGUNDA
WHERE SEGUNDA.P_NOMBRE = PRIMERA.PAI) PRINCIPAL
GROUP BY PRINCIPAL.COUNTRY;

#ME DEVUELVE EL TOTAL DE VOTOS DE MUJERES POR CADA MUNICIPIO DEL PAIS
SELECT P.NOMBRE, M.NOMBRE, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS TOTAL_VOTOS_PAIS FROM DETALLES_VOTOS DV, SEXO S, PAIS P, MUNICIPIO M,
DEPARTAMENTO D, REGION R
WHERE M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND D.ID_REGION = R.ID_REGION AND R.ID_PAIS = P.ID_PAIS
AND S.NOMBRE = 'mujeres'
GROUP BY P.NOMBRE, M.NOMBRE

#ME DEVUELVE EL TOTAL DE VOTOS EN UN PAIS DONDE HAYA VOTADO UNA MUJER
SELECT P.NOMBRE AS P_NOMBRE, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS TOTAL_VOTOS_PAIS FROM DETALLES_VOTOS DV, SEXO S, PAIS P, MUNICIPIO M,
DEPARTAMENTO D, REGION R
WHERE M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND D.ID_REGION = R.ID_REGION AND R.ID_PAIS = P.ID_PAIS
AND S.NOMBRE = 'mujeres'
GROUP BY P.NOMBRE;
--------------------------------------------------

--consulta 4
#VOTOS DE ANALFABETOS POR PAIS
SELECT P.NOMBRE AS COUNTRY, SUM(DV.TOTAL_N_NAC) AS VOTOS_ANALFABETAS  FROM PAIS P, DETALLES_VOTOS DV, REGION R, DEPARTAMENTO D, MUNICIPIO M
WHERE DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND R.ID_REGION = D.ID_REGION AND P.ID_PAIS = R.ID_PAIS
GROUP BY P.NOMBRE;

#VOTOS DE ANALFABETAS TOTTAL
SELECT SUM(AUXILIAR.VOTOS_ANALFABETAS) AS TOTAL_VOTOS FROM
(SELECT P.NOMBRE AS COUNTRY, SUM(DV.TOTAL_N_NAC) AS VOTOS_ANALFABETAS  FROM PAIS P, DETALLES_VOTOS DV, REGION R, DEPARTAMENTO D, MUNICIPIO M
WHERE DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND R.ID_REGION = D.ID_REGION AND P.ID_PAIS = R.ID_PAIS
GROUP BY P.NOMBRE) AUXILIAR
------------------


-- consulta 5
#ME CUENTA TODAS LAS ALCALDIAS POR PARTIDO
SELECT PRINCIPAL.CON AS PAIS, PRINCIPAL.PARTI AS PARTIDO_GANADOR, COUNT(PRINCIPAL.PARTI) AS NUMERO_ALCALDIAS_GANADAS FROM
(SELECT PRIMERA.PAIS AS CON, PRIMERA.MUNI AS MUNIC, PRIMERA.PARTIDO AS PARTI, SEGUNDA.MAXIMO_MUN AS MAX_NUM FROM
(SELECT AUXILIAR.PAIS_EN_CUESTION AS PAIS, AUXILIAR.MUNICIPIO AS MUNI , AUXILIAR.PARTIDO AS PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) AS TOTAL_POR_PARTIDO FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC) PRIMERA
JOIN
(SELECT AUXILIAR.PAIS_EN_CUESTION AS PA, AUXILIAR.MUNICIPIO AS MUN, MAX(AUXILIAR.VOTOS_PARTIDO) MAXIMO_MUN FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC) SEGUNDA
ON PRIMERA.TOTAL_POR_PARTIDO = SEGUNDA.MAXIMO_MUN AND PRIMERA.PAIS = SEGUNDA.PA AND PRIMERA.MUNI = SEGUNDA.MUN) AS PRINCIPAL
GROUP BY PRINCIPAL.CON, PRINCIPAL.PARTI
ORDER BY PRINCIPAL.CON, COUNT(PRINCIPAL.PARTI) DESC ;

#ME SACA POR PAIS EL MAYOR NUMERO DE ALCALDIAS GANADAS NO EL PARTIDO
SELECT MAIN.PAIS, MAX(MAIN.NUMERO_ALCALDIAS_GANADAS) FROM
(SELECT PRINCIPAL.CON AS PAIS, PRINCIPAL.PARTI AS PARTIDO_GANADOR, COUNT(PRINCIPAL.PARTI) AS NUMERO_ALCALDIAS_GANADAS FROM
(SELECT PRIMERA.PAIS AS CON, PRIMERA.MUNI AS MUNIC, PRIMERA.PARTIDO AS PARTI, SEGUNDA.MAXIMO_MUN AS MAX_NUM FROM
(SELECT AUXILIAR.PAIS_EN_CUESTION AS PAIS, AUXILIAR.MUNICIPIO AS MUNI , AUXILIAR.PARTIDO AS PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) AS TOTAL_POR_PARTIDO FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC) PRIMERA
JOIN
(SELECT AUXILIAR.PAIS_EN_CUESTION AS PA, AUXILIAR.MUNICIPIO AS MUN, MAX(AUXILIAR.VOTOS_PARTIDO) MAXIMO_MUN FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC) SEGUNDA
ON PRIMERA.TOTAL_POR_PARTIDO = SEGUNDA.MAXIMO_MUN AND PRIMERA.PAIS = SEGUNDA.PA AND PRIMERA.MUNI = SEGUNDA.MUN) AS PRINCIPAL
GROUP BY PRINCIPAL.CON, PRINCIPAL.PARTI
ORDER BY PRINCIPAL.CON, COUNT(PRINCIPAL.PARTI) DESC) AS MAIN
GROUP BY MAIN.PAIS;

#CUENTA EN INDIVIDUAL POR MUNICIPIO EL PARTIDO GANADOR
SELECT PRIMERA.PAIS, PRIMERA.MUNI, PRIMERA.PARTIDO, SEGUNDA.MAXIMO_MUN FROM
(SELECT AUXILIAR.PAIS_EN_CUESTION AS PAIS, AUXILIAR.MUNICIPIO AS MUNI , AUXILIAR.PARTIDO AS PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) AS TOTAL_POR_PARTIDO FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC) PRIMERA
JOIN
(SELECT AUXILIAR.PAIS_EN_CUESTION AS PA, AUXILIAR.MUNICIPIO AS MUN, MAX(AUXILIAR.VOTOS_PARTIDO) MAXIMO_MUN FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC) SEGUNDA
ON PRIMERA.TOTAL_POR_PARTIDO = SEGUNDA.MAXIMO_MUN AND PRIMERA.PAIS = SEGUNDA.PA AND PRIMERA.MUNI = SEGUNDA.MUN;

#ME DEVUELVE LA SUMA DE TODOS LOS VOTOS DE CADA PARTIDO
SELECT AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) AS TOTAL_POR_PARTIDO FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, AUXILIAR.PARTIDO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC

#ME DEVUELVE EL MAXIMO DE CADA MUNICIPIO
SELECT AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, MAX(AUXILIAR.VOTOS_PARTIDO) MAXIMO_MUN FROM
(SELECT P.NOMBRE AS PAIS_EN_CUESTION, M.NOMBRE AS MUNICIPIO, PAR.NOMBRE AS PARTIDO, PAR.ID_PARTIDO AS ID_P, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_PARTIDO
FROM PAIS P, PARTIDO PAR, DETALLES_VOTOS DV, MUNICIPIO M
WHERE DV.ID_PARTIDO = PAR.ID_PARTIDO AND P.ID_PAIS = PAR.ID_PAIS AND M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND M.ID_MUNICIPIO IN (SELECT ID_MUNICIPIO FROM MUNICIPIO)
GROUP BY P.NOMBRE, M.NOMBRE, PAR.NOMBRE, PAR.ID_PARTIDO) AUXILIAR
GROUP BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO
ORDER BY AUXILIAR.PAIS_EN_CUESTION, AUXILIAR.MUNICIPIO, MAX(AUXILIAR.VOTOS_PARTIDO) DESC
---------------------------------------------------------------------------

--consulta 6
#CUENTA LOS VOTOS POR ETNIA
SELECT P.NOMBRE, R.NOMBRE, ET.NOMBRE, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM PAIS P, REGION R, DEPARTAMENTO D, MUNICIPIO M, DETALLES_VOTOS DV, ETNIA ET
WHERE
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
P.ID_PAIS = R.ID_PAIS AND
ET.ID_ETNIA = DV.ID_ETNIA
GROUP BY P.NOMBRE, R.NOMBRE, ET.NOMBRE
ORDER BY P.NOMBRE , VOTOS DESC;

#SACA EL MAXIMO POR PAIS
SELECT AUXILIAR.PAIS, MAX(AUXILIAR.VOTOS) FROM
(SELECT P.NOMBRE AS PAIS, R.NOMBRE AS REG, ET.NOMBRE AS ET, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM PAIS P, REGION R, DEPARTAMENTO D, MUNICIPIO M, DETALLES_VOTOS DV, ETNIA ET
WHERE
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
P.ID_PAIS = R.ID_PAIS AND
ET.ID_ETNIA = DV.ID_ETNIA
GROUP BY P.NOMBRE, R.NOMBRE, ET.NOMBRE
ORDER BY P.NOMBRE , VOTOS DESC) AUXILIAR
GROUP BY AUXILIAR.PAIS;
------------------------------------------

--consulta 7
#ESTE ES EL NUMERO DE MUJERES UNIVERSITARIOS POR DEPARTAMENTO
SELECT P.NOMBRE AS PAIS, D.NOMBRE AS DEPARTAMENTO, S.NOMBRE AS SEXO, SUM(DV.TOTAL_N_UNIV) AS MUJER_TOTAL  FROM DEPARTAMENTO D, SEXO S, DETALLES_VOTOS DV, PAIS P, MUNICIPIO M, REGION R
WHERE
DV.ID_SEXO = S.ID_SEXO AND
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS AND
S.NOMBRE = 'mujeres'
GROUP BY P.NOMBRE, D.NOMBRE;


#ESTE ES EL NUMERO DE HOMBRES UNIVERSITARIOS POR DEPARTAMENTO
SELECT P.NOMBRE AS PAIS, D.NOMBRE AS DEPARTAMENTO, S.NOMBRE AS SEXO, SUM(DV.TOTAL_N_UNIV) AS HOMBRE_TOTAL  FROM DEPARTAMENTO D, SEXO S, DETALLES_VOTOS DV, PAIS P, MUNICIPIO M, REGION R
WHERE
DV.ID_SEXO = S.ID_SEXO AND
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS AND
S.NOMBRE = 'hombres'
GROUP BY P.NOMBRE, D.NOMBRE;

#ESTE ES EL NUMERO DE VOTOS UNIVERSITARIOS POR DEPARTAMENTO
SELECT P.NOMBRE AS PAIS, D.NOMBRE AS DEPARTAMENTO, SUM(DV.TOTAL_N_UNIV) AS TOTAL_UNIVERSITARIOS  FROM DEPARTAMENTO D, SEXO S, DETALLES_VOTOS DV, PAIS P, MUNICIPIO M, REGION R
WHERE
DV.ID_SEXO = S.ID_SEXO AND
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS
GROUP BY P.NOMBRE, D.NOMBRE;
-------------

--consulta 8
#DESPLEGAR LOS DEPARTAMENTOS DE GUATEMALA CON SUS VOTOS
SELECT P.NOMBRE AS PAIS, D.NOMBRE AS DEPARTAMENTO, SUM(DV.TOTAL_N_PRIMARIO + DV.TOTAL_N_MEDIO + DV.TOTAL_N_UNIV + DV.TOTAL_N_NAC) AS TOTAL_VOTOS
FROM DETALLES_VOTOS DV, MUNICIPIO M, PAIS P, REGION R, DEPARTAMENTO D
WHERE
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS AND
P.NOMBRE = 'GUATEMALA'
GROUP BY P.NOMBRE, D.NOMBRE
ORDER BY PAIS DESC;

#DESPLEGAR LA CANTIDAD DE GUATEMALA
SELECT P.NOMBRE AS PAIS, D.NOMBRE AS DEPARTAMENTO, SUM(DV.TOTAL_N_PRIMARIO + DV.TOTAL_N_MEDIO + DV.TOTAL_N_UNIV + DV.TOTAL_N_NAC) AS TOTAL_VOTOS
FROM DETALLES_VOTOS DV, MUNICIPIO M, PAIS P, REGION R, DEPARTAMENTO D
WHERE
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS AND
P.NOMBRE = 'GUATEMALA' AND
D.NOMBRE = 'Guatemala'
GROUP BY P.NOMBRE, D.NOMBRE
ORDER BY PAIS DESC;
----------------------\\


--consulta 10
set @p_rank := 1, @current_p := '';
SELECT P.NOMBRE AS PAIS,  M.NOMBRE AS MUNICIPIO,
PA.NOMBRE AS PARTIDO, SUM(DV.TOTAL_N_PRIMARIO + DV.TOTAL_N_MEDIO + DV.TOTAL_N_UNIV + DV.TOTAL_N_NAC )
AS TOTAL_VOTOS,
@p_rank := IF(@current_p = M.NOMBRE, @p_rank + 1, 1) AS RANK,
@current_p := M.NOMBRE AS DUMMY
FROM MUNICIPIO M, DETALLES_VOTOS DV, REGION R, DEPARTAMENTO D, PAIS P, PARTIDO PA
WHERE
M.ID_MUNICIPIO = DV.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS AND
PA.ID_PARTIDO = DV.ID_PARTIDO AND
PA.ID_PAIS = P.ID_PAIS
GROUP BY PAIS, MUNICIPIO, PARTIDO
ORDER BY PAIS, MUNICIPIO, PARTIDO, TOTAL_VOTOS DESC
--------------

--consulta 13
#VOTOS POR ETNIA
SELECT P.NOMBRE AS PAIS, E.NOMBRE AS ETNIA, SUM(DV.TOTAL_N_PRIMARIO + DV.TOTAL_N_MEDIO + DV.TOTAL_N_UNIV + DV.TOTAL_N_NAC)  AS VOTOS
FROM PAIS P, REGION R, DEPARTAMENTO D, MUNICIPIO M, ETNIA E, DETALLES_VOTOS DV
WHERE
DV.ID_ETNIA = E.ID_ETNIA AND
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS
GROUP BY PAIS, ETNIA
ORDER BY PAIS, ETNIA DESC;

#VOTOS POR PAIS
SELECT P.NOMBRE AS PAIS, SUM(DV.TOTAL_N_PRIMARIO + DV.TOTAL_N_MEDIO + DV.TOTAL_N_UNIV + DV.TOTAL_N_NAC)  AS VOTOS
FROM PAIS P, REGION R, DEPARTAMENTO D, MUNICIPIO M, DETALLES_VOTOS DV
WHERE
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
R.ID_PAIS = P.ID_PAIS
GROUP BY PAIS
ORDER BY PAIS DESC;

SELECT T.PAIS, SUM(T.ANALFABETOS + T.ALFABETOS) AS VOTOS FROM TEMPORAL T
GROUP BY T.PAIS;
--------------------
