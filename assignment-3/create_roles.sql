# Create an admin role 
CREATE ROLE 'admin';
GRANT ALL PRIVILEGES ON *.* TO 'admin';

# Create an auditor role
CREATE ROLE 'auditor';
GRANT SELECT, SHOW DATABASES, SHOW VIEW ON *.* TO 'auditor';

#Create a support role 
CREATE ROLE 'support';
GRANT SELECT, SHOW DATABASES, SHOW VIEW, PROCESS ON *.* TO 'support';

#Create a developer role 
CREATE ROLE 'developer';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX ON *.* TO 'developer';
