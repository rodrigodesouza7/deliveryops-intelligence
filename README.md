# 🚚 DeliveryOps Intelligence — Pipeline End-to-End de Analytics Engineering

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)
![dbt](https://img.shields.io/badge/dbt-1.10.0-orange)
![Streamlit](https://img.shields.io/badge/Streamlit-1.57.0-red)
![Airflow](https://img.shields.io/badge/Airflow-2.9.3-green)
![CI](https://img.shields.io/badge/CI-passing-brightgreen)
![Python](https://img.shields.io/badge/Python-3.11-yellow)
![License](https://img.shields.io/badge/License-MIT-green)

**Sistema completo de analytics engineering aplicando arquitetura multicamadas (raw → staging → intermediate → marts) para análise de performance logística, SLA de entregas e eficiência operacional com orquestração automatizada via Airflow e visualizações executivas em Streamlit.**

**Tecnologias:** PostgreSQL | dbt | Apache Airflow | Streamlit | Plotly | GitHub Actions | Docker | Render

**Objetivo:** Construir pipeline de dados end-to-end que transforma dados operacionais de supply chain em insights de negócio através de camadas de transformação dbt, orquestração Airflow e dashboard executivo interativo.

---

## 📊 Visão Geral

### Problema de Negócio

Empresas de logística e e-commerce enfrentam desafios críticos:

- **Onde estão os gargalos operacionais?**
- **Quais regiões têm maior atraso nas entregas?**
- **Qual modalidade de envio é mais eficiente?**
- **Quais clientes geram mais receita mas têm maior taxa de atraso?**

### Solução

Pipeline multicamadas com transformações dbt, orquestração Airflow e análise de SLA (Service Level Agreement) para:
- Identificar padrões de atraso por região e modalidade de envio
- Segmentar clientes por valor e performance de entrega
- Monitorar KPIs operacionais em tempo real

**Volume:** 180.519 registros | 7 data marts analíticos | 28 testes automatizados | Deploy cloud (Render)

---

## 🛠️ Tech Stack

### Backend
- **PostgreSQL 15** — Banco transacional (raw data)
- **dbt 1.10.0** — Orquestração do pipeline de transformação
- **Pandas 3.0.3** — Manipulação de dados

### Orquestração
- **Apache Airflow 2.9.3** — Agendamento e execução automatizada do pipeline dbt

### Frontend
- **Streamlit 1.57.0** — Dashboard interativo
- **Plotly 6.7.0** — Visualizações avançadas

### DevOps
- **GitHub Actions** — CI/CD automatizado (dbt run + dbt test)
- **Docker** — Containerização (Airflow + Streamlit)
- **Render** — Deploy cloud
- **Git** — Versionamento com Conventional Commits

### Modelagem
- **Pipeline Multicamadas** — raw → staging → intermediate → marts
- **Modelo Dimensional** — Fatos (vendas, entregas) + Dimensões (região, produto, cliente)

---

## 🏗️ Arquitetura do Sistema
┌─────────────────────────────────────────────┐
│         ARQUITETURA DO PIPELINE             │
└─────────────────────────────────────────────┘
┌──────────────────┐
│   Kaggle CSV     │
│  Supply Chain    │
│   (180k rows)    │
└────────┬─────────┘
│
│ ingestão
▼
┌──────────────────┐
│   PostgreSQL     │
│  Render Cloud    │
│                  │
│  raw.supply_    │
│  chain_raw       │
└────────┬─────────┘
│
│ dbt run
▼
┌──────────────────┐
│  dbt Pipeline    │
│                  │
│  staging/        │
│  └─ stg_supply   │
│                  │
│  intermediate/   │
│  └─ int_delivery │
│                  │
│  marts/          │
│  ├─ mart_revenue │
│  ├─ mart_shipping│
│  ├─ mart_customer│
│  ├─ mart_regional│
│  ├─ mart_product │
│  ├─ mart_sla     │
│  └─ mart_exec    │
└────────┬─────────┘
│
│ analytics
▼
┌──────────────────┐
│   Streamlit      │
│   Dashboard      │
│                  │
│  • 5 KPIs        │
│  • 6 seções      │
│  • Filtros       │
└────────┬─────────┘
│
▼
┌──────────────────┐
│ Apache Airflow   │
│   (DAG diária)   │
│                  │
│  dbt_run         │
│      ↓           │
│  dbt_test        │
│      ↓           │
│  dbt_docs        │
└────────┬─────────┘
│
▼
┌──────────────────┐
│ GitHub Actions   │
│    (CI/CD)       │
│                  │
│  • dbt run       │
│  • dbt test      │
│  • validations   │
└──────────────────┘

---

## 📦 Modelo de Dados

### Camadas do Pipeline

#### 🔹 RAW (PostgreSQL)
```sql
raw.supply_chain_raw — 180.519 registros brutos do Kaggle
```

#### 🔹 STAGING (dbt)
```sql
stg_supply_chain — Limpeza e padronização de nomes de colunas
```
- Renomeia 50 colunas para snake_case
- Remove espaços e caracteres especiais
- 8 testes not_null

#### 🔹 INTERMEDIATE (dbt)
```sql
int_delivery_performance — Cálculo de métricas operacionais
```
- `shipping_delay` — dias de atraso (real - scheduled)
- `is_late` — flag booleana de atraso
- Join de todas as dimensões relevantes

#### 🔹 MARTS (dbt)
```sql
mart_revenue              — Receita e lucro por região
mart_shipping_performance — SLA e atrasos por modalidade de envio
mart_customer_orders      — Pedidos e receita por cliente
mart_regional_performance — Vendas por país/região
mart_product_performance  — Performance de produtos/categorias
mart_delivery_sla         — Métricas de SLA consolidadas
mart_delivery_executive   — KPIs executivos
```

### Decisões Técnicas

- **Materialização:** Views em staging, Tables em intermediate/marts
- **Testes de qualidade:** 28 testes dbt (not_null, unique, relationships)
- **Naming convention:** snake_case para todos os objetos SQL
- **Lineage tracking:** dbt docs com grafo de dependências completo

---

## ✨ Features

### 📊 Pipeline de Dados

✅ Arquitetura multicamadas (raw → staging → intermediate → marts)  
✅ Transformações SQL via dbt  
✅ 28 testes automatizados de qualidade  
✅ 7 data marts analíticos especializados  
✅ Orquestração Airflow (DAG diária: dbt run → test → docs)  
✅ Lineage graph completo (dbt docs)  

### 📈 Dashboard Interativo

✅ **5 KPIs principais:**
- Total de receita (formato BR: R$ 1.234.567,89)
- Total de lucro
- Margem de lucro (%)
- Total de pedidos
- Atraso médio (dias)

✅ **6 seções analíticas:**
1. Receita & Lucro por Região (2 gráficos de barras)
2. Performance Logística (atraso médio + SLA por modalidade)
3. Performance por País (top 15 países, agrupados por região)
4. Top 15 Produtos por Vendas (classificados por categoria)
5. Top 15 Clientes por Receita (segmentados por perfil)
6. Insights automáticos gerados dinamicamente

✅ **Recursos interativos:**
- Filtro por região (multiselect)
- Filtro por segmento de cliente (multiselect)
- Filtro por modalidade de envio (multiselect)
- Atualização dinâmica de todos os gráficos
- Expanders informativos (contexto de negócio + arquitetura técnica)

### 🚀 DevOps

✅ CI/CD via GitHub Actions  
✅ Testes automatizados em cada push  
✅ Conventional Commits  
✅ Docker Compose (Airflow + Streamlit)  
✅ Deploy cloud (Render)  

### 📚 Documentação

✅ README completo  
✅ Diagramas de arquitetura (Mermaid + Graphviz)  
✅ Screenshots do dashboard  
✅ dbt docs gerado (lineage graph)  
✅ Comentários em SQL  

---

## 🌐 Demo Online

**Dashboard disponível em:** [https://deliveryops-intelligence.onrender.com](https://deliveryops-intelligence.onrender.com)

> ⚠️ **Nota:** Plano gratuito do Render — primeira carga pode levar ~50s (cold start).

---

## 📸 Dashboard — Screenshots

### Visão Geral — KPIs e Insights
![Dashboard Overview](docs/images/deliveryops-dashboard-overview.png)

### Receita & Lucro por Região
![Revenue Analysis](docs/images/deliveryops-revenue-profit-analysis.png)

### Performance Logística
![Logistics Performance](docs/images/deliveryops-logistics-performance.png)

### Performance por País
![Country Performance](docs/images/deliveryops-country-performance.png)

### Top 15 Produtos
![Top Products](docs/images/deliveryops-top-products.png)

### Top 15 Clientes
![Top Customers](docs/images/deliveryops-top-customers.png)

### Arquitetura do Pipeline
![Pipeline Architecture](docs/images/deliveryops-pipeline-architecture.png)

---

## 🚀 Como Reproduzir

### Pré-requisitos

- PostgreSQL 15 ou superior
- Python 3.11+
- Git
- Docker (opcional, para Airflow local)

### 1. Clonar repositório

```bash
git clone https://github.com/rodrigodesouza7/deliveryops-intelligence.git
cd deliveryops-intelligence
```

### 2. Criar ambiente virtual

```bash
python3 -m venv .venv
source .venv/bin/activate  # Linux/Mac
# ou
.venv\Scripts\activate  # Windows
```

### 3. Instalar dependências

```bash
pip install -r requirements.txt
```

### 4. Configurar banco de dados

#### Opção A: PostgreSQL Render (Cloud)

1. Crie uma conta no [Render](https://render.com)
2. Crie um PostgreSQL database (free tier)
3. Copie a **External Database URL**

#### Opção B: PostgreSQL Local

```bash
createdb deliveryops_db
```

### 5. Configurar variáveis de ambiente

Crie arquivo `.env` na raiz:

```bash
DATABASE_URL=postgresql://user:password@host:port/database
```

### 6. Ingerir dados brutos

```bash
# Baixar CSV do Kaggle e carregar no PostgreSQL
# (ou usar dump SQL se disponível)
psql $DATABASE_URL -c "\COPY raw.supply_chain_raw FROM 'data/DataCoSupplyChainDataset.csv' CSV HEADER"
```

### 7. Executar pipeline dbt

```bash
cd deliveryops_dbt

# Validar conexão
dbt debug

# Executar transformações
dbt run

# Rodar testes de qualidade
dbt test

# Gerar documentação
dbt docs generate
dbt docs serve
```

### 8. Rodar dashboard Streamlit

```bash
streamlit run app/main.py
```

Acesse: **http://localhost:8501**

### 9. (Opcional) Rodar Airflow localmente

```bash
docker-compose up -d
```

Acesse: **http://localhost:8080**  
Login: `admin` / `admin`

Ative a DAG `deliveryops_dbt_pipeline` e dispare manualmente.

---

## 🔄 CI/CD Pipeline

### GitHub Actions

Workflow automatizado que executa em todo push/PR:

```yaml
1. Setup PostgreSQL (container)
2. Criar schema do banco
3. Instalar dbt-postgres
4. Configurar profiles.yml dinamicamente
5. Executar dbt run
6. Executar dbt test
```

**Status:** ✅ CI passing

---

## 📁 Estrutura do Projeto
deliveryops-intelligence/
├── .github/
│   └── workflows/
│       └── ci.yml              # CI/CD pipeline
├── airflow/
│   ├── dags/
│   │   └── deliveryops_dbt_pipeline.py  # DAG principal
│   ├── Dockerfile              # Airflow + dbt
│   └── airflow.cfg
├── app/
│   ├── main.py                 # Dashboard Streamlit
│   └── services/
│       └── database.py         # Conexão PostgreSQL
├── deliveryops_dbt/
│   ├── models/
│   │   ├── staging/
│   │   │   ├── stg_supply_chain.sql
│   │   │   └── stg_supply_chain.yml
│   │   ├── intermediate/
│   │   │   ├── int_delivery_performance.sql
│   │   │   └── int_delivery_performance.yml
│   │   └── marts/
│   │       ├── mart_revenue.sql
│   │       ├── mart_shipping_performance.sql
│   │       ├── mart_customer_orders.sql
│   │       ├── mart_regional_performance.sql
│   │       ├── mart_product_performance.sql
│   │       ├── mart_delivery_sla.sql
│   │       ├── mart_delivery_executive.sql
│   │       └── [schemas .yml para cada mart]
│   └── dbt_project.yml
├── docs/
│   ├── images/                 # Screenshots
│   └── architecture.md         # Diagramas Mermaid
├── sql/
│   ├── staging/
│   ├── analytics/
│   └── reports/
├── .env.example
├── .gitignore
├── Dockerfile                  # Streamlit
├── docker-compose.yml          # Airflow + Streamlit
├── render.yaml                 # Deploy Render
├── requirements.txt
└── README.md

---

## 🎓 Aprendizados Técnicos

### Analytics Engineering

✅ Modelagem dimensional (fatos + dimensões)  
✅ Pipeline dbt multicamadas (staging → intermediate → marts)  
✅ Testes de qualidade de dados automatizados  
✅ Lineage tracking e documentação técnica  

### Data Engineering

✅ ETL/ELT via dbt  
✅ Orquestração com Apache Airflow  
✅ Integração PostgreSQL + dbt + Streamlit  
✅ CI/CD para pipelines de dados  

### BI & Visualização

✅ Streamlit para dashboards executivos  
✅ Plotly para gráficos interativos avançados  
✅ UX com filtros dinâmicos e insights automáticos  
✅ Formatação padrão brasileiro (moeda + datas)  

### DevOps

✅ Infraestrutura como código (Docker Compose)  
✅ GitHub Actions para CI/CD  
✅ Deploy cloud (Render)  
✅ Conventional Commits para histórico limpo  

---

## ✅ Status do Projeto

✅ Modelagem de dados (raw → staging → intermediate → marts)  
✅ Pipeline dbt completo (9 modelos + 28 testes)  
✅ Dashboard Streamlit com 6 seções analíticas  
✅ Orquestração Airflow (DAG diária)  
✅ CI/CD funcional (GitHub Actions)  
✅ Deploy cloud (Render)  
✅ Documentação completa  
✅ Screenshots do dashboard  
✅ Diagramas de arquitetura  

---

## 👤 Sobre o Autor

**Rodrigo de Souza Silva**

Profissional de Tecnologia da Informação com formação em Sistemas de Informação e pós-graduação em Data Science, Machine Learning e IA.

- **LinkedIn:** [linkedin.com/in/rodrigodesouzasilva](https://linkedin.com/in/rodrigodesouzasilva)
- **GitHub:** [github.com/rodrigodesouza7](https://github.com/rodrigodesouza7)

---

## 📄 Licença

MIT License — Projeto de portfólio profissional
