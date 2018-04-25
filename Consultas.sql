# CONULTA 1
SELECT PRIMERA.NOMBRE_ELECCION, PRIMERA.ANIO_ELECCION, PRIMERA.PAIS_ELEC, PRIMERA.PARTIDO_ELEC, PRIMERA.MAYORES_VOTOS, SEGUNDA.VOTOS_TOTAL, (PRIMERA.MAYORES_VOTOS/SEGUNDA.VOTOS_TOTAL)*100 AS PORCENTAJE_VOTOS
FROM
#PRIMER SELECT
(SELECT A.ELEC AS NOMBRE_ELECCION, A.YEAR AS ANIO_ELECCION, A.COUNTRY1 AS PAIS_ELEC, A.P_POLITCO1 AS PARTIDO_ELEC, B.MAXIMO AS MAYORES_VOTOS
FROM (SELECT P.NOMBRE AS COUNTRY1, E.NOMBRE AS ELEC, E.ANIO AS YEAR, PAR.NOMBRE AS P_POLITCO1, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM ELECCION E, PAIS P, PARTIDO PAR, DETALLES_VOTOS DV
WHERE
DV.ID_ELECCION = E.ID_ELECCION AND
DV.ID_PARTIDO = PAR.ID_PARTIDO AND
E.ID_PAIS = P.ID_PAIS AND
PAR.ID_PAIS = P.ID_PAIS AND
P.NOMBRE IN (SELECT DISTINCT PAIS.NOMBRE FROM PAIS)
GROUP BY P.NOMBRE, E.NOMBRE, E.ANIO ,PAR.NOMBRE) A
JOIN (SELECT SUB.COUNTRY2, MAX(SUB.VOTOS) AS MAXIMO FROM PARTIDO,
(SELECT P.NOMBRE AS COUNTRY2, PAR.NOMBRE AS P_POLITCO2, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM ELECCION E, PAIS P, PARTIDO PAR, DETALLES_VOTOS DV
WHERE
DV.ID_ELECCION = E.ID_ELECCION AND
DV.ID_PARTIDO = PAR.ID_PARTIDO AND
E.ID_PAIS = P.ID_PAIS AND
PAR.ID_PAIS = P.ID_PAIS AND
P.NOMBRE IN (SELECT DISTINCT PAIS.NOMBRE FROM PAIS)
GROUP BY P.NOMBRE, PAR.NOMBRE) SUB
WHERE PARTIDO.NOMBRE = SUB.P_POLITCO2
GROUP BY SUB.COUNTRY2) B
ON A.VOTOS = B.MAXIMO) PRIMERA,
#SEGUNDO SELECT
(SELECT P.NOMBRE AS COUNTRY1, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS_TOTAL FROM ELECCION E, PAIS P, PARTIDO PAR, DETALLES_VOTOS DV
WHERE
DV.ID_ELECCION = E.ID_ELECCION AND
DV.ID_PARTIDO = PAR.ID_PARTIDO AND
E.ID_PAIS = P.ID_PAIS AND
PAR.ID_PAIS = P.ID_PAIS AND
P.NOMBRE IN (SELECT DISTINCT PAIS.NOMBRE FROM PAIS)
GROUP BY P.NOMBRE) SEGUNDA
WHERE PRIMERA.PAIS_ELEC = SEGUNDA.COUNTRY1;


#CONSULTA 2
SELECT PRIMERA.MUJERES_ALFABETAS AS VOTOS_MUJERES_INDIGENAS_ALFABETAS, (PRIMERA.MUJERES_ALFABETAS/SEGUNDA.TOTAL_VOTOS)*100 AS PORCENTAJE_SOBRE_TOTAL FROM
#PRIMER SELECT
(SELECT SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV) AS MUJERES_ALFABETAS FROM DETALLES_VOTOS DV, ETNIA ET, SEXO S
WHERE S.NOMBRE = 'mujeres' AND ET.NOMBRE = 'INDIGENAS') PRIMERA,
#SEGUNDO SELECT
(SELECT SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS TOTAL_VOTOS FROM DETALLES_VOTOS DV) SEGUNDA


#CONULTA 3
SELECT SEGUNDA.P_NOMBRE AS COUNTRY, SEGUNDA.TOTAL_VOTOS_PAIS, PRIMERA.MUNI, PRIMERA.TOTAL_MUN AS TOTAL_EN_MUNICIPIO, (PRIMERA.TOTAL_MUN/SEGUNDA.TOTAL_VOTOS_PAIS)*100 AS PORCENTAJE_MUNICIPIO
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
WHERE SEGUNDA.P_NOMBRE = PRIMERA.PAI;


#CONSULTA 4
SELECT PRIMERA.COUNTRY AS P_PAIS, ROUND((PRIMERA.VOTOS_ANALFABETAS/SEGUNDA.TOTAL_VOTOS)*100,2) AS PORCENTAJE_VOTOS_ANALFABETAS_PAIS FROM
(SELECT SUM(AUXILIAR.VOTOS_ANALFABETAS) AS TOTAL_VOTOS FROM
(SELECT P.NOMBRE AS COUNTRY, SUM(DV.TOTAL_N_NAC) AS VOTOS_ANALFABETAS  FROM PAIS P, DETALLES_VOTOS DV, REGION R, DEPARTAMENTO D, MUNICIPIO M
WHERE DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND R.ID_REGION = D.ID_REGION AND P.ID_PAIS = R.ID_PAIS
GROUP BY P.NOMBRE) AUXILIAR) SEGUNDA,
(SELECT P.NOMBRE AS COUNTRY, SUM(DV.TOTAL_N_NAC) AS VOTOS_ANALFABETAS  FROM PAIS P, DETALLES_VOTOS DV, REGION R, DEPARTAMENTO D, MUNICIPIO M
WHERE DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND R.ID_REGION = D.ID_REGION AND P.ID_PAIS = R.ID_PAIS
GROUP BY P.NOMBRE) PRIMERA ORDER BY ROUND((PRIMERA.VOTOS_ANALFABETAS/SEGUNDA.TOTAL_VOTOS)*100,2) DESC LIMIT 0,1


#CONSULTA 5
SELECT MAIN_1.PAIS, MAIN_1.PARTIDO_GANADOR AS PARTIDO_CON_MAYOR_ALCALDIAS, MAIN_2.MAXI AS ALCALDIAS_GANADAS FROM
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
ORDER BY PRINCIPAL.CON, COUNT(PRINCIPAL.PARTI) DESC ) MAIN_1
JOIN
(SELECT MAIN.PAIS AS PE, MAX(MAIN.NUMERO_ALCALDIAS_GANADAS) AS MAXI FROM
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
GROUP BY MAIN.PAIS) MAIN_2
ON MAIN_1.PAIS = MAIN_2.PE AND MAIN_1.NUMERO_ALCALDIAS_GANADAS = MAIN_2.MAXI;


#CONSULTA 6
SELECT PRIMERA.PAIS, PRIMERA.REGI, PRIMERA.ET, SEGUNDA.MAXI FROM
(SELECT P.NOMBRE AS PAIS, R.NOMBRE AS REGI, ET.NOMBRE AS ET, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM PAIS P, REGION R, DEPARTAMENTO D, MUNICIPIO M, DETALLES_VOTOS DV, ETNIA ET
WHERE
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
P.ID_PAIS = R.ID_PAIS AND
ET.ID_ETNIA = DV.ID_ETNIA
GROUP BY P.NOMBRE, R.NOMBRE, ET.NOMBRE
ORDER BY P.NOMBRE , VOTOS DESC) PRIMERA
JOIN
(SELECT AUXILIAR.PAIS, MAX(AUXILIAR.VOTOS) AS MAXI FROM
(SELECT P.NOMBRE AS PAIS, R.NOMBRE AS REG, ET.NOMBRE AS ET, SUM(DV.TOTAL_N_PRIMARIO+DV.TOTAL_N_MEDIO+DV.TOTAL_N_UNIV+DV.TOTAL_N_NAC) AS VOTOS FROM PAIS P, REGION R, DEPARTAMENTO D, MUNICIPIO M, DETALLES_VOTOS DV, ETNIA ET
WHERE
DV.ID_MUNICIPIO = M.ID_MUNICIPIO AND
M.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO AND
D.ID_REGION = R.ID_REGION AND
P.ID_PAIS = R.ID_PAIS AND
ET.ID_ETNIA = DV.ID_ETNIA
GROUP BY P.NOMBRE, R.NOMBRE, ET.NOMBRE
ORDER BY P.NOMBRE , VOTOS DESC) AUXILIAR
GROUP BY AUXILIAR.PAIS) SEGUNDA
WHERE PRIMERA.PAIS = SEGUNDA.PAIS AND PRIMERA.VOTOS = SEGUNDA.MAXI AND PRIMERA.ET = 'INDIGENAS';
