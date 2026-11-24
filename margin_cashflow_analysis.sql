-- ============================================================================
-- Sabah Micro-Merchant OPEX & Digital Payment Tracker
-- Skrip Analisis Margin Keuntungan, Aliran Tunai & Saluran Pembayaran
-- ============================================================================

-- 1. Cipta Jadual Utama Transaksi Harian
CREATE TABLE IF NOT EXISTS daily_transactions (
    tx_id INT PRIMARY KEY,
    tx_date DATE NOT NULL,
    category VARCHAR(20) NOT NULL,        -- 'SALES', 'STOCK', 'OPEX'
    payment_channel VARCHAR(30) NOT NULL, -- 'CASH', 'QR_EWALLET', 'DIGITAL_WALLET'
    description VARCHAR(150),
    amount_myr DECIMAL(10, 2) NOT NULL
);

-- 2. Ringkasan Aliran Tunai & Margin Keuntungan Harian
SELECT
    tx_date AS tarikh,
    SUM(CASE WHEN category = 'SALES' THEN amount_myr ELSE 0 END) AS jumlah_jualan_myr,
    SUM(CASE WHEN category = 'STOCK' THEN amount_myr ELSE 0 END) AS kos_stok_myr,
    SUM(CASE WHEN category = 'OPEX'  THEN amount_myr ELSE 0 END) AS kos_opex_myr,
    (
        SUM(CASE WHEN category = 'SALES' THEN amount_myr ELSE 0 END) -
        SUM(CASE WHEN category = 'STOCK' THEN amount_myr ELSE 0 END)
    ) AS untung_kasar_myr,
    (
        SUM(CASE WHEN category = 'SALES' THEN amount_myr ELSE 0 END) -
        SUM(CASE WHEN category IN ('STOCK', 'OPEX') THEN amount_myr ELSE 0 END)
    ) AS aliran_tunai_bersih_myr,
    ROUND(
        (
            SUM(CASE WHEN category = 'SALES' THEN amount_myr ELSE 0 END) -
            SUM(CASE WHEN category IN ('STOCK', 'OPEX') THEN amount_myr ELSE 0 END)
        ) / NULLIF(SUM(CASE WHEN category = 'SALES' THEN amount_myr ELSE 0 END), 0) * 100,
        2
    ) AS margin_bersih_peratus
FROM daily_transactions
GROUP BY tx_date
ORDER BY tx_date ASC;

-- 3. Pecahan Jualan Mengikut Saluran Pembayaran (Tunai vs QR vs Dompet Digital)
SELECT
    payment_channel AS saluran_pembayaran,
    COUNT(*) AS bilangan_transaksi,
    SUM(amount_myr) AS jumlah_kutipan_myr,
    ROUND(
        SUM(amount_myr) * 100.0 /
        NULLIF((SELECT SUM(amount_myr) FROM daily_transactions WHERE category = 'SALES'), 0),
        2
    ) AS peratus_sumbangan
FROM daily_transactions
WHERE category = 'SALES'
GROUP BY payment_channel
ORDER BY jumlah_kutipan_myr DESC;

-- 4. Amaran Nisbah Perbelanjaan Tinggi (OPEX + Stok > 60% daripada Jualan)
SELECT
    tx_date AS tarikh,
    ROUND(
        SUM(CASE WHEN category IN ('STOCK', 'OPEX') THEN amount_myr ELSE 0 END) * 100.0 /
        NULLIF(SUM(CASE WHEN category = 'SALES' THEN amount_myr ELSE 0 END), 0),
        2
    ) AS nisbah_kos_peratus,
    CASE
        WHEN SUM(CASE WHEN category IN ('STOCK', 'OPEX') THEN amount_myr ELSE 0 END) >
             0.60 * SUM(CASE WHEN category = 'SALES' THEN amount_myr ELSE 0 END)
        THEN 'AMARAN: Kos Harian Tinggi'
        ELSE 'SIHAT: Margin Terkawal'
    END AS status_kesihatan_kewangan
FROM daily_transactions
GROUP BY tx_date
ORDER BY tx_date ASC;
