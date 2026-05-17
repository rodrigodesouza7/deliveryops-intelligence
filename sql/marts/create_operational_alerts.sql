CREATE TABLE IF NOT EXISTS marts.operational_alerts (
    alert_id SERIAL PRIMARY KEY,
    alert_code VARCHAR(50) UNIQUE NOT NULL,
    alert_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) CHECK (severity IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    active BOOLEAN DEFAULT true
);

CREATE OR REPLACE VIEW marts.vw_active_operational_alerts AS
SELECT
    alert_id,
    alert_code,
    alert_type,
    severity,
    description,
    created_at
FROM marts.operational_alerts
WHERE active = true;

INSERT INTO marts.operational_alerts (
    alert_code,
    alert_type,
    severity,
    description
)
VALUES
    ('SLA_DELAY_HIGH', 'SLA', 'HIGH', 'High volume of delayed deliveries detected'),
    ('CANCELED_ORDERS', 'ORDER_STATUS', 'MEDIUM', 'Canceled orders require monitoring'),
    ('REGIONAL_DELAY', 'REGION', 'HIGH', 'Regional delivery delays detected'),
    ('LOW_MARGIN_ORDER', 'FINANCE', 'LOW', 'Orders with low profit margin detected'),
    ('CRITICAL_SLA', 'SLA', 'CRITICAL', 'Critical SLA breach detected')
ON CONFLICT (alert_code) DO NOTHING;