import streamlit as st
import plotly.express as px

from services.database import load_table

st.set_page_config(
    page_title="DeliveryOps Intelligence",
    page_icon="🚚",
    layout="wide"
)

st.title("🚚 DeliveryOps Intelligence")
st.caption("Dashboard executivo de performance logística, receita e operações")

# =========================
# Load data
# =========================

@st.cache_data
def load_data():
    revenue = load_table("select * from analytics.mart_revenue")
    shipping = load_table("select * from analytics.mart_shipping_performance")
    customers = load_table("select * from analytics.mart_customer_orders")
    regional = load_table("select * from analytics.mart_regional_performance")
    products = load_table("select * from analytics.mart_product_performance")
    sla = load_table("select * from analytics.mart_delivery_sla")

    return revenue, shipping, customers, regional, products, sla


revenue, shipping, customers, regional, products, sla = load_data()

# =========================
# KPIs
# =========================

total_revenue = revenue["total_revenue"].sum()
total_profit = revenue["total_profit"].sum()
total_orders = sla["total_orders"].iloc[0]
avg_delay = sla["avg_shipping_delay"].iloc[0]

col1, col2, col3, col4 = st.columns(4)

col1.metric("Receita Total", f"${total_revenue:,.2f}")
col2.metric("Lucro Total", f"${total_profit:,.2f}")
col3.metric("Total de Pedidos", f"{total_orders:,.0f}")
col4.metric("Atraso Médio", f"{avg_delay:.2f} dias")

st.divider()

# =========================
# Revenue
# =========================

st.subheader("Receita por Região")

fig_revenue = px.bar(
    revenue.sort_values("total_revenue", ascending=False),
    x="order_region",
    y="total_revenue",
    title="Receita Total por Região"
)

st.plotly_chart(fig_revenue, use_container_width=True)

# =========================
# Regional performance
# =========================

st.subheader("Performance Regional")

fig_region = px.bar(
    regional.sort_values("total_sales", ascending=False).head(15),
    x="order_country",
    y="total_sales",
    color="order_region",
    title="Top Países por Vendas"
)

st.plotly_chart(fig_region, use_container_width=True)

# =========================
# Shipping
# =========================

st.subheader("Performance de Entrega")

fig_shipping = px.bar(
    shipping,
    x="shipping_mode",
    y="avg_delay",
    title="Atraso Médio por Modo de Envio"
)

st.plotly_chart(fig_shipping, use_container_width=True)

# =========================
# Products
# =========================

st.subheader("Top Produtos")

top_products = products.sort_values("total_sales", ascending=False).head(15)

fig_products = px.bar(
    top_products,
    x="product_name",
    y="total_sales",
    color="category_name",
    title="Top 15 Produtos por Vendas"
)

st.plotly_chart(fig_products, use_container_width=True)

# =========================
# Customers
# =========================

st.subheader("Clientes por Receita")

top_customers = customers.sort_values("total_customer_revenue", ascending=False).head(15)

fig_customers = px.bar(
    top_customers,
    x="customer_id",
    y="total_customer_revenue",
    color="customer_segment",
    title="Top 15 Clientes por Receita"
)

st.plotly_chart(fig_customers, use_container_width=True)