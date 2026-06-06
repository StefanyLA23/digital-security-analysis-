import streamlit as st
import pandas as pd
from database import query

st.set_page_config(
page_title="Explorador de Eventos",
layout="wide"
)

st.title("🔎 Explorador de Eventos")


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

ORDER BY e.ID_Evento
"""

df = query(sql)

df["Timestamp"] = pd.to_datetime(df["Timestamp"])



st.sidebar.header("Filtros")

usuario = st.sidebar.selectbox(
"Usuario",
["Todos"] + sorted(df["User_ID"].astype(str).unique().tolist())
)

clasificacion = st.sidebar.selectbox(
"Clasificación",
["Todas"] + sorted(df["Clasificacion"].dropna().unique().tolist())
)

anomalia = st.sidebar.selectbox(
"Anomalía",
["Todas"] + sorted(df["Anomalia"].dropna().unique().tolist())
)

actividad = st.sidebar.selectbox(
"Actividad",
["Todas"] + sorted(df["Nombre_Tipo"].dropna().unique().tolist())
)



if usuario != "Todos":
    df = df[df["User_ID"].astype(str) == usuario]

if clasificacion != "Todas":
    df = df[df["Clasificacion"] == clasificacion]

if anomalia != "Todas":
    df = df[df["Anomalia"] == anomalia]

if actividad != "Todas":
    df = df[df["Nombre_Tipo"] == actividad]



st.subheader("🔍 Búsqueda")

texto = st.text_input(
"Buscar por IP, Usuario, Acción o Actividad"
)

if texto:

    texto = texto.lower()

df = df[
    df.astype(str)
    .apply(
        lambda row:
        row.str.lower().str.contains(texto).any(),
        axis=1
    )
]

c1, c2, c3, c4 = st.columns(4)

c1.metric(
"Eventos",
len(df)
)

c2.metric(
"Usuarios",
df["User_ID"].nunique()
)

c3.metric(
"IPs",
df["IP_Address"].nunique()
)

c4.metric(
"Threat Score Promedio",
round(df["Threat_Score"].mean(), 2)
if len(df) > 0 else 0
)

st.divider()


st.subheader("📋 Eventos Encontrados")

st.dataframe(
df,
use_container_width=True,
hide_index=True
)



if len(df) > 0:

    st.divider()

st.subheader("📝 Detalle de Evento")

evento = st.selectbox(
    "Seleccione un Evento",
    df["ID_Evento"]
)

detalle = df[
    df["ID_Evento"] == evento
].iloc[0]

col1, col2 = st.columns(2)

with col1:

    st.write("### Información General")

    st.write(f"**Evento:** {detalle['ID_Evento']}")
    st.write(f"**Usuario:** {detalle['User_ID']}")
    st.write(f"**IP:** {detalle['IP_Address']}")
    st.write(f"**Fecha:** {detalle['Timestamp']}")

with col2:

    st.write("### Seguridad")

    st.write(f"**Anomalía:** {detalle['Anomalia']}")
    st.write(f"**Clasificación:** {detalle['Clasificacion']}")
    st.write(f"**Login Attempts:** {detalle['Login_Attempts']}")
    st.write(f"**Threat Score:** {detalle['Threat_Score']}")


st.divider()

csv = df.to_csv(
index=False
).encode("utf-8")

st.download_button(
label="📥 Descargar CSV",
data=csv,
file_name="eventos_filtrados.csv",
mime="text/csv"
)

st.divider()

st.subheader("📊 Estadísticas")

st.write("Total de registros:", len(df))

if len(df) > 0:

    st.write(
    "Threat Score Máximo:",
    round(df["Threat_Score"].max(), 2)
)

st.write(
    "Threat Score Mínimo:",
    round(df["Threat_Score"].min(), 2)
)

st.write(
    "Threat Score Promedio:",
    round(df["Threat_Score"].mean(), 2)
)