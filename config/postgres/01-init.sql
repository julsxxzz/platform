\set ON_ERROR_STOP on

\getenv ledger_pw     LEDGER_DB_PASSWORD
\getenv transfer_pw   TRANSFER_DB_PASSWORD
\getenv keycloak_pw   KEYCLOAK_DB_PASSWORD
\getenv apicurio_pw   APICURIO_DB_PASSWORD
\getenv pactbroker_pw PACT_BROKER_DB_PASSWORD

CREATE USER ledger     WITH PASSWORD :'ledger_pw';
CREATE USER transfer   WITH PASSWORD :'transfer_pw';
CREATE USER keycloak   WITH PASSWORD :'keycloak_pw';
CREATE USER apicurio   WITH PASSWORD :'apicurio_pw';
CREATE USER pactbroker WITH PASSWORD :'pactbroker_pw';

CREATE DATABASE keycloak   OWNER keycloak;
CREATE DATABASE apicurio   OWNER apicurio;
CREATE DATABASE pactbroker OWNER pactbroker;

CREATE DATABASE payments;
\connect payments
REVOKE ALL ON SCHEMA public FROM PUBLIC;

CREATE SCHEMA ledger AUTHORIZATION ledger;
ALTER ROLE ledger IN DATABASE payments SET search_path = ledger;

CREATE SCHEMA transfer AUTHORIZATION transfer;
ALTER ROLE transfer IN DATABASE payments SET search_path = transfer;