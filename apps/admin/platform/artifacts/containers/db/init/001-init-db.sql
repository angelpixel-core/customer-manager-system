SELECT 'CREATE DATABASE customers_manager_system_test'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'customers_manager_system_test')
\gexec
