import streamlit as st
import pandas as pd
import plotly.express as px
from database import query

st.set_page_config(
page_title="Análisis de Riesgo",
layout="wide"
)

st.title("⚠️ Análisis de Riesgo")

sql = """
SELECT

e.ID_Evento,
e.Timestamp,

u.User_ID,
u.IP_Address,

ta.Nombre_Tipo,
a.Nombre_Accion,

an.Descripcion AS Anomalia,

c.Etiqueta AS Clasificacion,

e.Login_Attempts,
e.File_Size,

(
    (e.ID_Clasificacion * 30)
    +
    (e.ID_Anomalia * 20)
    +
    (e.Login_Attempts * 5)
) AS Threat_Score

FROM Evento e

LEFT JOIN Usuario u
ON e.ID_Usuario = u.ID_Usuario

LEFT JOIN TipoActividad ta
ON e.ID_TipoActividad = ta.ID_TipoActividad

LEFT JOIN Accion a
ON e.ID_Accion = a.ID_Accion

LEFT JOIN Anomalia an
ON e.ID_Anomalia = an.ID_Anomalia

LEFT JOIN Clasificacion c
ON e.ID_Clasificacion = c.ID_Clasificacion
"""

df = query(sql)

def nivel_riesgo(score):

    if score < 60:
        return "Bajo"

    elif score < 100:
        return "Medio"

    return "Alto"

df["Nivel_Riesgo"] = df["Threat_Score"].apply(
nivel_riesgo
)

total = len(df)

riesgo_alto = len(
df[df["Nivel_Riesgo"] == "Alto"]
)

riesgo_medio = len(
df[df["Nivel_Riesgo"] == "Medio"]
)

riesgo_bajo = len(
df[df["Nivel_Riesgo"] == "Bajo"]
)

c1, c2, c3, c4 = st.columns(4)

c1.metric(
"Eventos Analizados",
total
)

c2.metric(
"Riesgo Alto",
riesgo_alto
)

c3.metric(
"Riesgo Medio",
riesgo_medio
)

c4.metric(
"Riesgo Bajo",
riesgo_bajo
)

st.divider()


st.subheader("📊 Distribución del Riesgo")

riesgo = (
df.groupby("Nivel_Riesgo")
.size()
.reset_index(name="Total")
)

fig_riesgo = px.pie(
riesgo,
names="Nivel_Riesgo",
values="Total",
hole=0.4,
title="Distribución de Eventos por Riesgo"
)

st.plotly_chart(
fig_riesgo,
use_container_width=True
)


st.subheader("🎯 Threat Score por Evento")

fig_score = px.bar(
df,
x="ID_Evento",
y="Threat_Score",
color="Nivel_Riesgo",
text="Threat_Score",
title="Puntaje de Amenaza"
)

st.plotly_chart(
fig_score,
use_container_width=True
)

st.divider()

st.subheader("👤 Riesgo por Usuario")

riesgo_usuario = (
df.groupby("User_ID")
.agg({
"Threat_Score": "mean"
})
.reset_index()
.sort_values(
by="Threat_Score",
ascending=False
)
)

fig_usuario = px.bar(
riesgo_usuario,
x="User_ID",
y="Threat_Score",
title="Promedio de Riesgo por Usuario"
)

st.plotly_chart(
fig_usuario,
use_container_width=True
)

st.divider()


st.subheader("🔐 Login Attempts y Riesgo")

fig_login = px.scatter(
df,
x="Login_Attempts",
y="Threat_Score",
color="Nivel_Riesgo",
size="File_Size",
hover_data=[
"User_ID",
"Anomalia",
"Clasificacion"
],
title="Intentos de Login vs Riesgo"
)

st.plotly_chart(
fig_login,
use_container_width=True
)

st.divider()


st.subheader("📁 Tamaño de Archivos y Riesgo")

fig_files = px.scatter(
df,
x="File_Size",
y="Threat_Score",
color="Nivel_Riesgo",
hover_data=[
"User_ID",
"Anomalia"
],
title="File Size vs Threat Score"
)

st.plotly_chart(
fig_files,
use_container_width=True
)

st.divider()


st.subheader("🚨 Top Eventos de Mayor Riesgo")

top = (
df.sort_values(
by="Threat_Score",
ascending=False
)
.head(10)
)

st.dataframe(
top[
[
"ID_Evento",
"User_ID",
"IP_Address",
"Anomalia",
"Clasificacion",
"Login_Attempts",
"File_Size",
"Threat_Score",
"Nivel_Riesgo"
]
],
use_container_width=True,
hide_index=True
)

st.subheader("💡 Recomendaciones")

if riesgo_alto > 0:

    st.error(
    f"Se detectaron {riesgo_alto} eventos de riesgo alto que requieren revisión inmediata."
)

if riesgo_medio > 0:

    st.warning(
    f"Se detectaron {riesgo_medio} eventos de riesgo medio que deben ser monitoreados."
)

if riesgo_alto == 0 and riesgo_medio == 0:

    st.success(
    "No se detectaron eventos de riesgo significativo."
)