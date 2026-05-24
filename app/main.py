import streamlit as st
import plotly.express as px

from services.database import load_table

st.set_page_config(
    page_title="DeliveryOps Intelligence",
    page_icon="🚚",
    layout="wide"
)

# ── Data ──────────────────────────────────────────────────────────────────────

@st.cache_data
def load_data():
    revenue   = load_table("select * from analytics.mart_revenue")
    shipping  = load_table("select * from analytics.mart_shipping_performance")
    customers = load_table("select * from analytics.mart_customer_orders")
    regional  = load_table("select * from analytics.mart_regional_performance")
    products  = load_table("select * from analytics.mart_product_performance")
    sla       = load_table("select * from analytics.mart_delivery_sla")
    return revenue, shipping, customers, regional, products, sla

revenue, shipping, customers, regional, products, sla = load_data()

# ── Sidebar ───────────────────────────────────────────────────────────────────

with st.sidebar:
    st.title("🔍 Filtros")
    st.divider()

    all_regions = sorted(revenue["order_region"].dropna().unique())
    selected_regions = st.multiselect(
        "Região",
        options=all_regions,
        default=all_regions,
    )

    all_segments = sorted(customers["customer_segment"].dropna().unique())
    selected_segments = st.multiselect(
        "Segmento de Cliente",
        options=all_segments,
        default=all_segments,
    )

    all_modes = sorted(shipping["shipping_mode"].dropna().unique())
    selected_modes = st.multiselect(
        "Modalidade de Envio",
        options=all_modes,
        default=all_modes,
    )

    st.divider()
    st.caption("DeliveryOps Intelligence v1.0")

# ── Filtered data ─────────────────────────────────────────────────────────────

rev_f  = revenue[revenue["order_region"].isin(selected_regions)]
reg_f  = regional[regional["order_region"].isin(selected_regions)]
ship_f = shipping[shipping["shipping_mode"].isin(selected_modes)]
cust_f = customers[customers["customer_segment"].isin(selected_segments)]

# ── Header ────────────────────────────────────────────────────────────────────

st.title("🚚 DeliveryOps Intelligence")
st.caption(
    "Plataforma de analytics para monitoramento de performance logística, "
    "receita e operações de entrega."
)

with st.expander("📖 Sobre este Dashboard", expanded=False):
    st.markdown("""
    ### Contexto de Negócio

    Operações de entrega são um dos maiores vetores de custo e satisfação do cliente em cadeias
    de suprimentos globais. Atrasos recorrentes elevam o custo logístico, corroem a margem e
    impactam diretamente a retenção de clientes.

    Este dashboard centraliza os principais indicadores operacionais e financeiros da cadeia de
    entrega, permitindo que gestores identifiquem rapidamente **onde estão os gargalos**,
    **quais regiões geram mais valor** e **quais modalidades de envio apresentam maior desvio
    de prazo**.

    ### Pipeline de Dados

    Os dados passam por um pipeline ELT moderno antes de chegar a este dashboard:

    | Etapa | Tecnologia | Função |
    |---|---|---|
    | Ingestão | PostgreSQL (Render) | Armazenamento da tabela bruta |
    | Transformação | dbt Core | Staging → Intermediate → Marts |
    | Orquestração | Apache Airflow | Execução diária automatizada |
    | Visualização | Streamlit + Plotly | Este dashboard |

    ### KPIs Monitorados

    - **Receita Total** — soma das vendas no período/região selecionados
    - **Lucro Total** — receita descontados os custos por pedido
    - **Margem de Lucro** — percentual de lucro sobre a receita
    - **Total de Pedidos** — volume operacional processado
    - **Atraso Médio** — diferença média (dias) entre prazo real e prazo programado de entrega
    """)

with st.expander("🏗️ Arquitetura do Pipeline", expanded=False):
    st.graphviz_chart("""
    digraph architecture {
        rankdir=LR
        node [shape=box, style="filled,rounded", fontname="Arial", fontsize=11]
        edge [fontname="Arial", fontsize=10]

        CSV  [label="CSV\\nSupply Chain",         fillcolor="#f39c12", fontcolor="white"]
        PG   [label="PostgreSQL\\nRender Cloud",   fillcolor="#3498db", fontcolor="white"]
        STG  [label="dbt Staging\\nstg_supply_chain",            fillcolor="#2ecc71", fontcolor="white"]
        INT  [label="dbt Intermediate\\nint_delivery_performance", fillcolor="#27ae60", fontcolor="white"]
        MART [label="dbt Marts\\n7 modelos analíticos",           fillcolor="#1e8449", fontcolor="white"]
        AF   [label="Airflow\\nDAG diária",        fillcolor="#e74c3c", fontcolor="white"]
        ST   [label="Streamlit\\nDashboard",        fillcolor="#9b59b6", fontcolor="white"]
        RC   [label="Render\\nCloud Deploy",        fillcolor="#1abc9c", fontcolor="white"]

        CSV  -> PG   [label="ingestão"]
        PG   -> STG  [label="dbt run"]
        STG  -> INT
        INT  -> MART
        MART -> ST   [label="SQL query"]
        ST   -> RC   [label="Docker"]
        AF   -> STG  [label="agenda"]
        AF   -> INT  [style=dashed]
        AF   -> MART [style=dashed]
    }
    """)

# ── KPIs ──────────────────────────────────────────────────────────────────────

total_revenue = rev_f["total_revenue"].sum()
total_profit  = rev_f["total_profit"].sum()
total_orders  = rev_f["total_orders"].sum()
avg_delay     = sla["avg_shipping_delay"].iloc[0]
profit_margin = (total_profit / total_revenue * 100) if total_revenue > 0 else 0

k1, k2, k3, k4, k5 = st.columns(5)
k1.metric("Receita Total",    f"${total_revenue:,.0f}")
k2.metric("Lucro Total",      f"${total_profit:,.0f}")
k3.metric("Margem de Lucro",  f"{profit_margin:.1f}%")
k4.metric("Total de Pedidos", f"{total_orders:,.0f}")
k5.metric("Atraso Médio",     f"{avg_delay:.1f} dias")

# ── Insights automáticos ──────────────────────────────────────────────────────

if not rev_f.empty and not ship_f.empty:
    top_region     = rev_f.loc[rev_f["total_revenue"].idxmax(), "order_region"]
    top_region_pct = rev_f["total_revenue"].max() / rev_f["total_revenue"].sum() * 100
    worst_mode     = ship_f.loc[ship_f["avg_delay"].idxmax(), "shipping_mode"]
    worst_delay    = ship_f["avg_delay"].max()
    best_mode      = ship_f.loc[ship_f["avg_delay"].idxmin(), "shipping_mode"]
    top_product    = products.loc[products["total_sales"].idxmax(), "product_name"]

    st.info(
        f"**Destaque:** A região **{top_region}** concentra **{top_region_pct:.0f}%** da receita total. "
        f"A modalidade **{worst_mode}** apresenta o maior atraso médio ({worst_delay:.1f} dias), "
        f"enquanto **{best_mode}** é a mais pontual. "
        f"O produto mais vendido é **{top_product}**."
    )

st.divider()

# ── Receita & Lucro ───────────────────────────────────────────────────────────

st.subheader("💰 Receita & Lucro por Região")
st.caption("Comparativo de receita total e lucro gerado por cada região de operação.")

if rev_f.empty:
    st.info("Nenhuma região selecionada.")
else:
    top_r   = rev_f.loc[rev_f["total_revenue"].idxmax(), "order_region"]
    top_rev = rev_f["total_revenue"].max()
    st.caption(f"💡 **{top_r}** lidera em receita com **${top_rev:,.0f}** — use os filtros para comparar regiões individualmente.")

    col_left, col_right = st.columns(2)

    with col_left:
        fig_rev = px.bar(
            rev_f.sort_values("total_revenue", ascending=False),
            x="order_region",
            y="total_revenue",
            color="order_region",
            labels={"order_region": "Região", "total_revenue": "Receita ($)"},
            color_discrete_sequence=px.colors.qualitative.Set2,
        )
        fig_rev.update_layout(showlegend=False, xaxis_title="", yaxis_title="Receita ($)")
        st.plotly_chart(fig_rev, use_container_width=True)

    with col_right:
        fig_profit = px.bar(
            rev_f.sort_values("total_profit", ascending=False),
            x="order_region",
            y="total_profit",
            color="order_region",
            labels={"order_region": "Região", "total_profit": "Lucro ($)"},
            color_discrete_sequence=px.colors.qualitative.Set2,
        )
        fig_profit.update_layout(showlegend=False, xaxis_title="", yaxis_title="Lucro ($)")
        st.plotly_chart(fig_profit, use_container_width=True)

st.divider()

# ── Logística ─────────────────────────────────────────────────────────────────

st.subheader("🚛 Performance Logística")
st.caption(
    "Atraso médio e comparativo entre prazo programado e prazo real por modalidade de envio. "
    "Valores positivos de atraso indicam entrega após o prazo acordado."
)

if ship_f.empty:
    st.info("Nenhuma modalidade de envio selecionada.")
else:
    worst = ship_f.loc[ship_f["avg_delay"].idxmax()]
    best  = ship_f.loc[ship_f["avg_delay"].idxmin()]
    st.caption(
        f"💡 **{worst['shipping_mode']}** tem o maior atraso médio ({worst['avg_delay']:.1f} dias). "
        f"**{best['shipping_mode']}** é a modalidade mais pontual ({best['avg_delay']:.1f} dias de atraso médio)."
    )

    col_left, col_right = st.columns(2)

    with col_left:
        fig_delay = px.bar(
            ship_f.sort_values("avg_delay", ascending=False),
            x="shipping_mode",
            y="avg_delay",
            color="shipping_mode",
            labels={"shipping_mode": "Modalidade", "avg_delay": "Atraso Médio (dias)"},
            color_discrete_sequence=px.colors.qualitative.Pastel,
        )
        fig_delay.update_layout(showlegend=False, xaxis_title="", yaxis_title="Atraso Médio (dias)")
        st.plotly_chart(fig_delay, use_container_width=True)

    with col_right:
        fig_sla = px.bar(
            ship_f.sort_values("avg_real_shipping_days", ascending=False),
            x="shipping_mode",
            y=["avg_scheduled_shipping_days", "avg_real_shipping_days"],
            barmode="group",
            labels={"shipping_mode": "Modalidade", "value": "Dias", "variable": "Tipo"},
            color_discrete_map={
                "avg_scheduled_shipping_days": "#2ecc71",
                "avg_real_shipping_days":      "#e74c3c",
            },
        )
        fig_sla.for_each_trace(lambda t: t.update(name={
            "avg_scheduled_shipping_days": "Prazo Programado",
            "avg_real_shipping_days":      "Prazo Real",
        }.get(t.name, t.name)))
        fig_sla.update_layout(xaxis_title="", yaxis_title="Dias", legend_title="")
        st.plotly_chart(fig_sla, use_container_width=True)

st.divider()

# ── Mercados ──────────────────────────────────────────────────────────────────

st.subheader("🌍 Performance por País")
st.caption("Top 15 países por volume de vendas, agrupados por região geográfica.")

if reg_f.empty:
    st.info("Nenhuma região selecionada.")
else:
    top_country     = reg_f.loc[reg_f["total_sales"].idxmax(), "order_country"]
    top_country_rev = reg_f["total_sales"].max()
    st.caption(f"💡 **{top_country}** é o país com maior volume de vendas (${top_country_rev:,.0f}).")

    fig_region = px.bar(
        reg_f.sort_values("total_sales", ascending=False).head(15),
        x="order_country",
        y="total_sales",
        color="order_region",
        labels={
            "order_country": "País",
            "total_sales":   "Vendas ($)",
            "order_region":  "Região",
        },
        color_discrete_sequence=px.colors.qualitative.Set2,
    )
    fig_region.update_layout(xaxis_title="", yaxis_title="Vendas ($)", legend_title="Região")
    st.plotly_chart(fig_region, use_container_width=True)

st.divider()

# ── Produtos ──────────────────────────────────────────────────────────────────

st.subheader("📦 Top 15 Produtos por Vendas")
st.caption("Produtos com maior volume de vendas, classificados por categoria.")

top_prod      = products.loc[products["total_sales"].idxmax(), "product_name"]
top_prod_cat  = products.loc[products["total_sales"].idxmax(), "category_name"]
top_prod_rev  = products["total_sales"].max()
st.caption(f"💡 **{top_prod}** ({top_prod_cat}) lidera com **${top_prod_rev:,.0f}** em vendas.")

fig_products = px.bar(
    products.sort_values("total_sales", ascending=False).head(15),
    x="product_name",
    y="total_sales",
    color="category_name",
    labels={
        "product_name":  "Produto",
        "total_sales":   "Vendas ($)",
        "category_name": "Categoria",
    },
    color_discrete_sequence=px.colors.qualitative.Pastel,
)
fig_products.update_xaxes(tickangle=-35)
fig_products.update_layout(xaxis_title="", yaxis_title="Vendas ($)", legend_title="Categoria")
st.plotly_chart(fig_products, use_container_width=True)

st.divider()

# ── Clientes ──────────────────────────────────────────────────────────────────

st.subheader("👤 Top 15 Clientes por Receita")
st.caption("Clientes com maior receita acumulada, segmentados por perfil comercial.")

if cust_f.empty:
    st.info("Nenhum segmento de cliente selecionado.")
else:
    top_seg     = cust_f.groupby("customer_segment")["total_customer_revenue"].sum().idxmax()
    top_seg_rev = cust_f.groupby("customer_segment")["total_customer_revenue"].sum().max()
    st.caption(f"💡 O segmento **{top_seg}** representa a maior receita acumulada (${top_seg_rev:,.0f}).")

    top_customers = cust_f.sort_values("total_customer_revenue", ascending=False).head(15)

    fig_customers = px.bar(
        top_customers,
        x="customer_id",
        y="total_customer_revenue",
        color="customer_segment",
        labels={
            "customer_id":             "ID Cliente",
            "total_customer_revenue":  "Receita ($)",
            "customer_segment":        "Segmento",
        },
        color_discrete_sequence=px.colors.qualitative.Set2,
    )
    fig_customers.update_layout(xaxis_title="", yaxis_title="Receita ($)", legend_title="Segmento")
    st.plotly_chart(fig_customers, use_container_width=True)