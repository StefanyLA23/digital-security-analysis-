import streamlit as st
import pandas as pd
import plotly.express as px
from database import query

st.set_page_config(
page_title="Análisis de Anomalías",
layout="wide"
)

st.title("🚨 Análisis de Anomalías")


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

df["Timestamp"] = pd.to_datetime(df["Timestamp"])


total_eventos = len(df)

eventos_anomalos = len(
df[df["Anomalia"] != "Normal"]
)

threat_promedio = round(
df["Threat_Score"].mean(),
2
)

threat_maximo = round(
df["Threat_Score"].max(),
2
)

c1, c2, c3, c4 = st.columns(4)

c1.metric(
"Eventos Analizados",
total_eventos
)

c2.metric(
"Eventos con Anomalía",
eventos_anomalos
)

c3.metric(
"Threat Score Promedio",
threat_promedio
)

c4.metric(
"Threat Score Máximo",
threat_maximo
)

st.divider()


st.subheader("📊 Distribución de Anomalías")

anomalias = (
df.groupby("Anomalia")
.size()
.reset_index(name="Total")
)

fig_anomalias = px.bar(
anomalias,
x="Anomalia",
y="Total",
text="Total",
title="Frecuencia de Anomalías"
)

st.plotly_chart(
fig_anomalias,
use_container_width=True
)

st.subheader("⚠️ Riesgo Asociado")

riesgo = (
df.groupby("Clasificacion")
.size()
.reset_index(name="Total")
)

fig_riesgo = px.pie(
riesgo,
names="Clasificacion",
values="Total",
title="Clasificación de Riesgo"
)

st.plotly_chart(
fig_riesgo,
use_container_width=True
)

st.divider()


st.subheader("📁 Anomalías por Actividad")

actividad = (
df.groupby(
["Nombre_Tipo", "Anomalia"]
)
.size()
.reset_index(name="Total")
)

fig_actividad = px.bar(
actividad,
x="Nombre_Tipo",
y="Total",
color="Anomalia",
barmode="group",
title="Anomalías según Actividad"
)

st.plotly_chart(
fig_actividad,
use_container_width=True
)

st.divider()


st.subheader("🔐 Intentos de Login")

fig_login = px.scatter(
df,
x="Login_Attempts",
y="Threat_Score",
color="Clasificacion",
size="File_Size",
hover_data=[
"User_ID",
"Anomalia"
],
title="Intentos de Login vs Threat Score"
)

st.plotly_chart(
fig_login,
use_container_width=True
)

st.divider()

st.subheader("🚨 Top Eventos Más Riesgosos")

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
"Threat_Score"
]
],
use_container_width=True,
hide_index=True
)

st.divider()


st.subheader("📋 Detalle de Eventos")

filtro = st.selectbox(
"Filtrar por Anomalía",
["Todas"] + sorted(
df["Anomalia"].unique().tolist()
)
)

if filtro != "Todas":
    df = df[
df["Anomalia"] == filtro
]

st.dataframe(
df,
use_container_width=True,
hide_index=True
)