# Performance Notes

## Problemas encontrados

- Queries lentas em subqueries correlacionadas
- Full table scans em `analytics.delivery_performance`
- Consultas com `ORDER BY`, `GROUP BY` e subconsultas demorando muito no DBeaver

## Melhorias aplicadas

Foram criados índices em:

- `order_id`
- `customer_id`
- `product_card_id`
- `sla_status`
- `order_date`
- `sales`
- `order_region`

Também foi executado:

```sql
ANALYZE analytics.delivery_performance;
```
