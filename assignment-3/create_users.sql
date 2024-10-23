CREATE USER "admin@localhost" IDENTIFIED BY "123456789";
CREATE USER "developer@localhost" IDENTIFIED BY "123456789";
CREATE USER "auditor@localhost" IDENTIFIED BY "123456789";
CREATE USER "support@localhost" IDENTIFIED BY "123456789";

GRANT 'admin' TO "admin@localhost";
GRANT 'developer' TO "developer@localhost";
GRANT 'auditor' TO "auditor@localhost";
GRANT 'support' TO "support@localhost";
