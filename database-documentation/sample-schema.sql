-- EveShield MVP – Complete Database Schema with ERD-Ready Definitions
-- This schema reflects both the USSD and Offline Android App requirements,
-- with relationships, constraints, and appropriate datatypes clearly defined.
-- USERS TABLE
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    device_type VARCHAR(20) CHECK (device_type IN ('feature_phone', 'smartphone')),
    location GEOGRAPHY(POINT),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- SOS ALERTS TABLE
CREATE TABLE sos_alerts (
    alert_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    alert_type VARCHAR(30) CHECK (
        alert_type IN (
            'panic_button',
            'menu_triggered',
            'bluetooth_triggered'
        )
    ),
    status VARCHAR(30) CHECK (
        status IN ('sent', 'pending', 'offline_stored', 'retried')
    ),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    location GEOGRAPHY(POINT),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
-- SUPPORT RESOURCES TABLE
CREATE TABLE support_resources (
    resource_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(100) NOT NULL,
    body TEXT NOT NULL,
    region VARCHAR(50) NOT NULL,
    access_method VARCHAR(10) CHECK (access_method IN ('USSD', 'App', 'Both'))
);
-- BLUETOOTH RELAY LOG (App Only)
CREATE TABLE bluetooth_relay_logs (
    relay_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_id UUID NOT NULL,
    source_user UUID NOT NULL,
    target_user UUID NOT NULL,
    hop_count INTEGER CHECK (hop_count >= 0),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (alert_id) REFERENCES sos_alerts(alert_id) ON DELETE CASCADE,
    FOREIGN KEY (source_user) REFERENCES users(user_id) ON DELETE
    SET NULL,
        FOREIGN KEY (target_user) REFERENCES users(user_id) ON DELETE
    SET NULL
);
-- USSD SESSION LOGS TABLE
CREATE TABLE ussd_session_logs (
    session_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    menu_path TEXT NOT NULL,
    duration INTEGER CHECK (duration >= 0),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
-- LINK TABLE (USER RESOURCE ACCESS LOGS)
CREATE TABLE user_resource_access_log (
    access_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    resource_id UUID NOT NULL,
    access_method VARCHAR(10) CHECK (access_method IN ('USSD', 'App')),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (resource_id) REFERENCES support_resources(resource_id) ON DELETE CASCADE
);
-- Optional: Indexes for query performance
CREATE INDEX idx_user_phone ON users(phone_number);
CREATE INDEX idx_sos_alerts_user ON sos_alerts(user_id);
CREATE INDEX idx_support_region ON support_resources(region);
CREATE INDEX idx_ussd_user ON ussd_session_logs(user_id);
-- Notes:
-- - Ensure `gen_random_uuid()` is supported (PostgreSQL pgcrypto or uuid-ossp).
-- - Use PostGIS for `GEOGRAPHY(POINT)` if location features are required.
-- - Phone numbers should be hashed or encrypted before production.
-- - Consider separate mobile and backend DB schemas if logic diverges.