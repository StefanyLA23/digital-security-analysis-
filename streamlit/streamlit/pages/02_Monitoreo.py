import streamlit as st
import pandas as pd
import plotly.express as px
from database import query

st.set_page_config(
page_title="Centro de Monitoreo",
layout="wide"
)

st.title("🖥️ Centro de Monitoreo")

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

ORDER BY e.Timestamp
"""

df = query(sql)

df["Timestamp"] = pd.to_datetime(df["Timestamp"])


st.sidebar.header("Filtros")

clasificaciones = st.sidebar.multiselect(
"Clasificación",
options=sorted(df["Clasificacion"].dropna().unique()),
default=sorted(df["Clasificacion"].dropna().unique())
)

anomalias = st.sidebar.multiselect(
"Anomalía",
options=sorted(df["Anomalia"].dropna().unique()),
default=sorted(df["Anomalia"].dropna().unique())
)

actividades = st.sidebar.multiselect(
"Actividad",
options=sorted(df["Nombre_Tipo"].dropna().unique()),
default=sorted(df["Nombre_Tipo"].dropna().unique())
)

df_filtrado = df[
(df["Clasificacion"].isin(clasificaciones))
&
(df["Anomalia"].isin(anomalias))
&
(df["Nombre_Tipo"].isin(actividades))
]

st.subheader("📊 Estado Actual")

c1, c2, c3, c4 = st.columns(4)

c1.metric(
"Eventos",
len(df_filtrado)
)

c2.metric(
"Usuarios",
df_filtrado["User_ID"].nunique()
)

c3.metric(
"IPs",
df_filtrado["IP_Address"].nunique()
)

c4.metric(
"Threat Score Promedio",
round(df_filtrado["Threat_Score"].mean(), 2)
)

st.divider()

st.subheader("📈 Línea Temporal de Eventos")

timeline = (
df_filtrado
.groupby("Timestamp")
.size()
.reset_index(name="Eventos")
)

fig_timeline = px.line(
timeline,
x="Timestamp",
y="Eventos",
markers=True,
title="Eventos Registrados en el Tiempo"
)

st.plotly_chart(
fig_timeline,
use_container_width=True
)

col1, col2 = st.columns(2)

with col1:

    actividades_chart = (
    df_filtrado
    .groupby("Nombre_Tipo")
    .size()
    .reset_index(name="Total")
)

fig_actividad = px.bar(
    actividades_chart,
    x="Nombre_Tipo",
    y="Total",
    title="Eventos por Actividad"
)

st.plotly_chart(
    fig_actividad,
    use_container_width=True
)

with col2:
    acciones_chart = (
    df_filtrado
    .groupby("Nombre_Accion")
    .size()
    .reset_index(name="Total")
)

fig_accion = px.bar(
    acciones_chart,
    x="Nombre_Accion",
    y="Total",
    title="Eventos por Acción"
)

st.plotly_chart(
    fig_accion,
    use_container_width=True
)

st.divider()

st.subheader("🔐 Intentos de Inicio de Sesión")

fig_login = px.bar(
df_filtrado,
x="ID_Evento",
y="Login_Attempts",
color="Clasificacion",
title="Intentos de Login por Evento"
)

st.plotly_chart(
fig_login,
use_container_width=True
)


st.subheader("📁 Transferencia de Archivos")

fig_files = px.bar(
df_filtrado,
x="ID_Evento",
y="File_Size",
color="Clasificacion",
title="Tamaño de Archivo por Evento"
)

st.plotly_chart(
fig_files,
use_container_width=True
)

st.divider()


st.subheader("🚨 Eventos de Mayor Riesgo")

top_riesgo = (
df_filtrado
.sort_values(
by="Threat_Score",
ascending=False
)
.head(10)
)

st.dataframe(
top_riesgo[
[
"ID_Evento",
"User_ID",
"IP_Address",
"Nombre_Tipo",
"Anomalia",
"Clasificacion",
"Login_Attempts",
"Threat_Score"
]
],
use_container_width=True,
hide_index=True
)


st.subheader("📋 Eventos Registrados")

st.dataframe(
df_filtrado,
use_container_width=True,
hide_index=True
)