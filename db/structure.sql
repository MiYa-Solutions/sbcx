--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = ON;
SET check_function_bodies = FALSE;
SET client_min_messages = WARNING;

--
-- Name: postgres; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = PUBLIC, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = FALSE;

--
-- Name: queue_classic_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE queue_classic_jobs (
  id        BIGINT NOT NULL,
  q_name    TEXT   NOT NULL,
  method    TEXT   NOT NULL,
  args      JSON   NOT NULL,
  locked_at TIMESTAMP WITH TIME ZONE,
  CONSTRAINT queue_classic_jobs_method_check CHECK ((length(method) > 0)),
  CONSTRAINT queue_classic_jobs_q_name_check CHECK ((length(q_name) > 0))
);


--
-- Name: lock_head(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lock_head(tname CHARACTER VARYING)
  RETURNS SETOF queue_classic_jobs
LANGUAGE plpgsql
AS $_$
BEGIN
  RETURN QUERY EXECUTE 'SELECT * FROM lock_head($1,10)'
  USING tname;
END;
$_$;


--
-- Name: lock_head(character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION lock_head(q_name CHARACTER VARYING, top_boundary INTEGER)
  RETURNS SETOF queue_classic_jobs
LANGUAGE plpgsql
AS $_$
DECLARE
  unlocked     BIGINT;
  relative_top INTEGER;
  job_count    INTEGER;
BEGIN
-- The purpose is to release contention for the first spot in the table.
-- The select count(*) is going to slow down dequeue performance but allow
-- for more workers. Would love to see some optimization here...

  EXECUTE 'SELECT count(*) FROM '
          || '(SELECT * FROM queue_classic_jobs WHERE q_name = '
          || quote_literal(q_name)
          || ' LIMIT '
          || quote_literal(top_boundary)
          || ') limited'
  INTO job_count;

  SELECT
    TRUNC(random() * (top_boundary - 1))
  INTO relative_top;

  IF job_count < top_boundary
  THEN
    relative_top = 0;
  END IF;

  LOOP
  BEGIN
    EXECUTE 'SELECT id FROM queue_classic_jobs '
            || ' WHERE locked_at IS NULL'
            || ' AND q_name = '
            || quote_literal(q_name)
            || ' ORDER BY id ASC'
            || ' LIMIT 1'
            || ' OFFSET ' || quote_literal(relative_top)
            || ' FOR UPDATE NOWAIT'
    INTO unlocked;
    EXIT;
    EXCEPTION
    WHEN lock_not_available
      THEN
-- do nothing. loop again and hope we get a lock
  END;
  END LOOP;

  RETURN QUERY EXECUTE 'UPDATE queue_classic_jobs '
                       || ' SET locked_at = (CURRENT_TIMESTAMP)'
                       || ' WHERE id = $1'
                       || ' AND locked_at is NULL'
                       || ' RETURNING *'
  USING unlocked;

  RETURN;
END;
$_$;


--
-- Name: queue_classic_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION queue_classic_notify()
  RETURNS TRIGGER
LANGUAGE plpgsql
AS $$ BEGIN
    PERFORM pg_notify(new.q_name, '');
  RETURN null;
END $$;


--
-- Name: accounting_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounting_entries (
  id               INTEGER                                                   NOT NULL,
  status           INTEGER,
  event_id         INTEGER,
  amount_cents     INTEGER DEFAULT 0                                         NOT NULL,
  amount_currency  CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  ticket_id        INTEGER,
  account_id       INTEGER,
  created_at       TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  updated_at       TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  type             CHARACTER VARYING(255),
  description      CHARACTER VARYING(255),
  balance_cents    INTEGER DEFAULT 0                                         NOT NULL,
  balance_currency CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  agreement_id     INTEGER,
  external_ref     CHARACTER VARYING(255),
  collector_id     INTEGER,
  collector_type   CHARACTER VARYING(255)
);


--
-- Name: accounting_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounting_entries_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: accounting_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounting_entries_id_seq OWNED BY accounting_entries.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
  id               INTEGER                                                   NOT NULL,
  organization_id  INTEGER                                                   NOT NULL,
  accountable_id   INTEGER                                                   NOT NULL,
  accountable_type CHARACTER VARYING(255)                                    NOT NULL,
  created_at       TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  updated_at       TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  balance_cents    INTEGER DEFAULT 0                                         NOT NULL,
  balance_currency CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  synch_status     INTEGER
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE active_admin_comments (
  id            INTEGER                     NOT NULL,
  namespace     CHARACTER VARYING(255),
  body          TEXT,
  resource_id   CHARACTER VARYING(255)      NOT NULL,
  resource_type CHARACTER VARYING(255)      NOT NULL,
  author_id     INTEGER,
  author_type   CHARACTER VARYING(255),
  created_at    TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at    TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE active_admin_comments_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_users (
  id                     INTEGER                                                NOT NULL,
  email                  CHARACTER VARYING(255) DEFAULT '' :: CHARACTER VARYING NOT NULL,
  encrypted_password     CHARACTER VARYING(255) DEFAULT '' :: CHARACTER VARYING NOT NULL,
  reset_password_token   CHARACTER VARYING(255),
  reset_password_sent_at TIMESTAMP WITHOUT TIME ZONE,
  remember_created_at    TIMESTAMP WITHOUT TIME ZONE,
  sign_in_count          INTEGER DEFAULT 0,
  current_sign_in_at     TIMESTAMP WITHOUT TIME ZONE,
  last_sign_in_at        TIMESTAMP WITHOUT TIME ZONE,
  current_sign_in_ip     CHARACTER VARYING(255),
  last_sign_in_ip        CHARACTER VARYING(255),
  created_at             TIMESTAMP WITHOUT TIME ZONE                            NOT NULL,
  updated_at             TIMESTAMP WITHOUT TIME ZONE                            NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_users_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: agreements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE agreements (
  id                INTEGER                     NOT NULL,
  name              CHARACTER VARYING(255),
  counterparty_id   INTEGER,
  organization_id   INTEGER,
  description       TEXT,
  created_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  status            INTEGER,
  counterparty_type CHARACTER VARYING(255),
  type              CHARACTER VARYING(255),
  creator_id        INTEGER,
  updater_id        INTEGER,
  starts_at         TIMESTAMP WITHOUT TIME ZONE,
  ends_at           TIMESTAMP WITHOUT TIME ZONE,
  payment_terms     CHARACTER VARYING(255)
);


--
-- Name: agreements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE agreements_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: agreements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE agreements_id_seq OWNED BY agreements.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE appointments (
  id               INTEGER                     NOT NULL,
  starts_at        TIMESTAMP WITHOUT TIME ZONE,
  ends_at          TIMESTAMP WITHOUT TIME ZONE,
  title            CHARACTER VARYING(255),
  description      TEXT,
  all_day          BOOLEAN,
  recurring        BOOLEAN,
  appointable_id   INTEGER,
  appointable_type CHARACTER VARYING(255),
  created_at       TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at       TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  creator_id       INTEGER,
  updater_id       INTEGER,
  organization_id  INTEGER
);


--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE appointments_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE appointments_id_seq OWNED BY appointments.id;


--
-- Name: assignments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assignments (
  id         INTEGER                     NOT NULL,
  user_id    INTEGER,
  role_id    INTEGER,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assignments_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assignments_id_seq OWNED BY assignments.id;


--
-- Name: boms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE boms (
  id             INTEGER                                                   NOT NULL,
  ticket_id      INTEGER,
  created_at     TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  updated_at     TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  quantity       NUMERIC,
  material_id    INTEGER,
  cost_cents     INTEGER DEFAULT 0                                         NOT NULL,
  cost_currency  CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  price_cents    INTEGER DEFAULT 0                                         NOT NULL,
  price_currency CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  buyer_id       INTEGER,
  buyer_type     CHARACTER VARYING(255),
  creator_id     INTEGER,
  updater_id     INTEGER
);


--
-- Name: boms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE boms_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: boms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE boms_id_seq OWNED BY boms.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
  id              INTEGER                     NOT NULL,
  name            CHARACTER VARYING(255),
  organization_id INTEGER,
  company         CHARACTER VARYING(255),
  address1        CHARACTER VARYING(255),
  address2        CHARACTER VARYING(255),
  city            CHARACTER VARYING(255),
  state           CHARACTER VARYING(255),
  zip             CHARACTER VARYING(255),
  country         CHARACTER VARYING(255),
  phone           CHARACTER VARYING(255),
  mobile_phone    CHARACTER VARYING(255),
  work_phone      CHARACTER VARYING(255),
  email           CHARACTER VARYING(255),
  created_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  creator_id      INTEGER,
  updater_id      INTEGER
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE events (
  id                  INTEGER                     NOT NULL,
  name                CHARACTER VARYING(255),
  type                CHARACTER VARYING(255),
  description         TEXT,
  eventable_type      CHARACTER VARYING(255),
  eventable_id        INTEGER,
  created_at          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at          TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  user_id             INTEGER,
  reference_id        INTEGER,
  creator_id          INTEGER,
  updater_id          INTEGER,
  triggering_event_id INTEGER,
  properties          hstore
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE events_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: invites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invites (
  id              INTEGER                     NOT NULL,
  message         CHARACTER VARYING(255),
  organization_id INTEGER,
  affiliate_id    INTEGER,
  status          INTEGER,
  created_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  creator_id      INTEGER,
  updater_id      INTEGER
);


--
-- Name: invites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invites_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invites_id_seq OWNED BY invites.id;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE materials (
  id              INTEGER                                                   NOT NULL,
  organization_id INTEGER,
  supplier_id     INTEGER,
  name            CHARACTER VARYING(255),
  description     TEXT,
  creator_id      INTEGER,
  updater_id      INTEGER,
  status          INTEGER,
  created_at      TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  updated_at      TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  cost_cents      INTEGER DEFAULT 0                                         NOT NULL,
  cost_currency   CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  price_cents     INTEGER DEFAULT 0                                         NOT NULL,
  price_currency  CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  deleted_at      TIMESTAMP WITHOUT TIME ZONE
);


--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE materials_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE materials_id_seq OWNED BY materials.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
  id              INTEGER                     NOT NULL,
  subject         CHARACTER VARYING(255),
  content         TEXT,
  status          INTEGER,
  user_id         INTEGER,
  created_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at      TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  notifiable_id   INTEGER,
  notifiable_type CHARACTER VARYING(255),
  type            CHARACTER VARYING(255),
  event_id        INTEGER
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: org_to_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE org_to_roles (
  id                   INTEGER                     NOT NULL,
  organization_id      INTEGER,
  organization_role_id INTEGER,
  created_at           TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at           TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: org_to_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE org_to_roles_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: org_to_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE org_to_roles_id_seq OWNED BY org_to_roles.id;


--
-- Name: organization_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organization_roles (
  id         INTEGER                     NOT NULL,
  name       CHARACTER VARYING(255),
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
  id                INTEGER                     NOT NULL,
  name              CHARACTER VARYING(255),
  phone             CHARACTER VARYING(255),
  website           CHARACTER VARYING(255),
  company           CHARACTER VARYING(255),
  address1          CHARACTER VARYING(255),
  address2          CHARACTER VARYING(255),
  city              CHARACTER VARYING(255),
  state             CHARACTER VARYING(255),
  zip               CHARACTER VARYING(255),
  country           CHARACTER VARYING(255),
  mobile            CHARACTER VARYING(255),
  work_phone        CHARACTER VARYING(255),
  email             CHARACTER VARYING(255),
  subcontrax_member BOOLEAN,
  status            INTEGER,
  created_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at        TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  parent_org_id     INTEGER,
  industry          CHARACTER VARYING(255),
  other_industry    CHARACTER VARYING(255)
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE payments (
  id           INTEGER                     NOT NULL,
  agreement_id INTEGER,
  type         CHARACTER VARYING(255),
  rate         DOUBLE PRECISION,
  rate_type    CHARACTER VARYING(255),
  created_at   TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at   TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payments_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: posting_rules; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posting_rules (
  id             INTEGER                     NOT NULL,
  agreement_id   INTEGER,
  type           CHARACTER VARYING(255),
  rate           NUMERIC,
  rate_type      CHARACTER VARYING(255),
  created_at     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  properties     hstore,
  time_bound     BOOLEAN DEFAULT FALSE,
  sunday         BOOLEAN DEFAULT FALSE,
  monday         BOOLEAN DEFAULT FALSE,
  tuesday        BOOLEAN DEFAULT FALSE,
  wednesday      BOOLEAN DEFAULT FALSE,
  thursday       BOOLEAN DEFAULT FALSE,
  friday         BOOLEAN DEFAULT FALSE,
  saturday       BOOLEAN DEFAULT FALSE,
  sunday_from    TIME WITHOUT TIME ZONE,
  monday_from    TIME WITHOUT TIME ZONE,
  tuesday_from   TIME WITHOUT TIME ZONE,
  wednesday_from TIME WITHOUT TIME ZONE,
  thursday_from  TIME WITHOUT TIME ZONE,
  friday_from    TIME WITHOUT TIME ZONE,
  saturday_from  TIME WITHOUT TIME ZONE,
  sunday_to      TIME WITHOUT TIME ZONE,
  monday_to      TIME WITHOUT TIME ZONE,
  tuesday_to     TIME WITHOUT TIME ZONE,
  wednesday_to   TIME WITHOUT TIME ZONE,
  thursday_to    TIME WITHOUT TIME ZONE,
  friday_to      TIME WITHOUT TIME ZONE,
  saturday_to    TIME WITHOUT TIME ZONE
);


--
-- Name: posting_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posting_rules_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: posting_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posting_rules_id_seq OWNED BY posting_rules.id;


--
-- Name: queue_classic_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE queue_classic_jobs_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: queue_classic_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE queue_classic_jobs_id_seq OWNED BY queue_classic_jobs.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
  id         INTEGER                     NOT NULL,
  name       CHARACTER VARYING(255),
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
  version CHARACTER VARYING(255) NOT NULL
);


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
  id            INTEGER NOT NULL,
  tag_id        INTEGER,
  taggable_id   INTEGER,
  taggable_type CHARACTER VARYING(255),
  tagger_id     INTEGER,
  tagger_type   CHARACTER VARYING(255),
  context       CHARACTER VARYING(128),
  created_at    TIMESTAMP WITHOUT TIME ZONE
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
  id              INTEGER NOT NULL,
  name            CHARACTER VARYING(255),
  organization_id INTEGER
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tickets (
  id                    INTEGER                                                   NOT NULL,
  customer_id           INTEGER,
  notes                 TEXT,
  started_on            TIMESTAMP WITHOUT TIME ZONE,
  organization_id       INTEGER,
  completed_on          TIMESTAMP WITHOUT TIME ZONE,
  created_at            TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  updated_at            TIMESTAMP WITHOUT TIME ZONE                               NOT NULL,
  status                INTEGER,
  subcontractor_id      INTEGER,
  technician_id         INTEGER,
  provider_id           INTEGER,
  subcontractor_status  INTEGER,
  type                  CHARACTER VARYING(255),
  ref_id                INTEGER,
  creator_id            INTEGER,
  updater_id            INTEGER,
  settled_on            TIMESTAMP WITHOUT TIME ZONE,
  billing_status        INTEGER,
  settlement_date       TIMESTAMP WITHOUT TIME ZONE,
  name                  CHARACTER VARYING(255),
  scheduled_for         TIMESTAMP WITHOUT TIME ZONE,
  transferable          BOOLEAN DEFAULT TRUE,
  allow_collection      BOOLEAN DEFAULT TRUE,
  collector_id          INTEGER,
  collector_type        CHARACTER VARYING(255),
  provider_status       INTEGER,
  work_status           INTEGER,
  re_transfer           BOOLEAN DEFAULT TRUE,
  payment_type          CHARACTER VARYING(255),
  subcon_payment        CHARACTER VARYING(255),
  provider_payment      CHARACTER VARYING(255),
  company               CHARACTER VARYING(255),
  address1              CHARACTER VARYING(255),
  address2              CHARACTER VARYING(255),
  city                  CHARACTER VARYING(255),
  state                 CHARACTER VARYING(255),
  zip                   CHARACTER VARYING(255),
  country               CHARACTER VARYING(255),
  phone                 CHARACTER VARYING(255),
  mobile_phone          CHARACTER VARYING(255),
  work_phone            CHARACTER VARYING(255),
  email                 CHARACTER VARYING(255),
  subcon_agreement_id   INTEGER,
  provider_agreement_id INTEGER,
  tax                   DOUBLE PRECISION DEFAULT 0.0,
  subcon_fee_cents      INTEGER DEFAULT 0                                         NOT NULL,
  subcon_fee_currency   CHARACTER VARYING(255) DEFAULT 'USD' :: CHARACTER VARYING NOT NULL,
  properties            hstore,
  external_ref          CHARACTER VARYING(255)
);


--
-- Name: tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tickets_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tickets_id_seq OWNED BY tickets.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
  id                     INTEGER                                                NOT NULL,
  email                  CHARACTER VARYING(255) DEFAULT '' :: CHARACTER VARYING NOT NULL,
  encrypted_password     CHARACTER VARYING(255) DEFAULT '' :: CHARACTER VARYING NOT NULL,
  reset_password_token   CHARACTER VARYING(255),
  reset_password_sent_at TIMESTAMP WITHOUT TIME ZONE,
  remember_created_at    TIMESTAMP WITHOUT TIME ZONE,
  sign_in_count          INTEGER DEFAULT 0,
  current_sign_in_at     TIMESTAMP WITHOUT TIME ZONE,
  last_sign_in_at        TIMESTAMP WITHOUT TIME ZONE,
  current_sign_in_ip     CHARACTER VARYING(255),
  last_sign_in_ip        CHARACTER VARYING(255),
  created_at             TIMESTAMP WITHOUT TIME ZONE                            NOT NULL,
  updated_at             TIMESTAMP WITHOUT TIME ZONE                            NOT NULL,
  organization_id        INTEGER,
  first_name             CHARACTER VARYING(255),
  last_name              CHARACTER VARYING(255),
  phone                  CHARACTER VARYING(255),
  company                CHARACTER VARYING(255),
  address1               CHARACTER VARYING(255),
  address2               CHARACTER VARYING(255),
  country                CHARACTER VARYING(255),
  state                  CHARACTER VARYING(255),
  city                   CHARACTER VARYING(255),
  zip                    CHARACTER VARYING(255),
  mobile_phone           CHARACTER VARYING(255),
  work_phone             CHARACTER VARYING(255),
  preferences            hstore,
  time_zone              CHARACTER VARYING(255),
  confirmation_token     CHARACTER VARYING(255),
  confirmed_at           TIMESTAMP WITHOUT TIME ZONE,
  confirmation_sent_at   TIMESTAMP WITHOUT TIME ZONE,
  unconfirmed_email      CHARACTER VARYING(255)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE versions (
  id         INTEGER                NOT NULL,
  item_type  CHARACTER VARYING(255) NOT NULL,
  item_id    INTEGER                NOT NULL,
  event      CHARACTER VARYING(255) NOT NULL,
  whodunnit  CHARACTER VARYING(255),
  object     TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  assoc_id   INTEGER
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounting_entries ALTER COLUMN id SET DEFAULT nextval('accounting_entries_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY agreements ALTER COLUMN id SET DEFAULT nextval('agreements_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointments ALTER COLUMN id SET DEFAULT nextval('appointments_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY boms ALTER COLUMN id SET DEFAULT nextval('boms_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY materials ALTER COLUMN id SET DEFAULT nextval('materials_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY org_to_roles ALTER COLUMN id SET DEFAULT nextval('org_to_roles_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posting_rules ALTER COLUMN id SET DEFAULT nextval('posting_rules_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY queue_classic_jobs ALTER COLUMN id SET DEFAULT nextval('queue_classic_jobs_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets ALTER COLUMN id SET DEFAULT nextval('tickets_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq' :: REGCLASS);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq' :: REGCLASS);


--
-- Name: accounting_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounting_entries
ADD CONSTRAINT accounting_entries_pkey PRIMARY KEY (id);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_users
ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: agreements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY agreements
ADD CONSTRAINT agreements_pkey PRIMARY KEY (id);


--
-- Name: assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assignments
ADD CONSTRAINT assignments_pkey PRIMARY KEY (id);


--
-- Name: boms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY boms
ADD CONSTRAINT boms_pkey PRIMARY KEY (id);


--
-- Name: calendar_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appointments
ADD CONSTRAINT calendar_events_pkey PRIMARY KEY (id);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers
ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: invites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invites
ADD CONSTRAINT invites_pkey PRIMARY KEY (id);


--
-- Name: materials_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY materials
ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: org_to_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY org_to_roles
ADD CONSTRAINT org_to_roles_pkey PRIMARY KEY (id);


--
-- Name: organization_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organization_roles
ADD CONSTRAINT organization_roles_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY payments
ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: posting_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posting_rules
ADD CONSTRAINT posting_rules_pkey PRIMARY KEY (id);


--
-- Name: queue_classic_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY queue_classic_jobs
ADD CONSTRAINT queue_classic_jobs_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: service_calls_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tickets
ADD CONSTRAINT service_calls_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY versions
ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: events_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX events_properties ON events USING GIN (properties);


--
-- Name: idx_qc_on_name_only_unlocked; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX idx_qc_on_name_only_unlocked ON queue_classic_jobs USING BTREE (q_name, id)
  WHERE (locked_at IS NULL);


--
-- Name: index_accounts_on_accountable_id_and_accountable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_accountable_id_and_accountable_type ON accounts USING BTREE (accountable_id, accountable_type);


--
-- Name: index_accounts_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_organization_id ON accounts USING BTREE (organization_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING BTREE (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING BTREE (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING BTREE (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING BTREE (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING BTREE (reset_password_token);


--
-- Name: index_boms_on_material_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_boms_on_material_id ON boms USING BTREE (material_id);


--
-- Name: index_events_on_eventable_id_and_eventable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_eventable_id_and_eventable_type ON events USING BTREE (eventable_id, eventable_type);


--
-- Name: index_materials_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_materials_on_name ON materials USING BTREE (name);


--
-- Name: index_materials_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_materials_on_organization_id ON materials USING BTREE (organization_id);


--
-- Name: index_materials_on_supplier_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_materials_on_supplier_id ON materials USING BTREE (supplier_id);


--
-- Name: index_org_to_roles_on_organization_id_and_organization_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_org_to_roles_on_organization_id_and_organization_role_id ON org_to_roles USING BTREE (organization_id, organization_role_id);


--
-- Name: index_service_calls_on_ref_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_service_calls_on_ref_id ON tickets USING BTREE (ref_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING BTREE (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING BTREE (taggable_id, taggable_type, context);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING BTREE (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING BTREE (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING BTREE (reset_password_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING BTREE (item_type, item_id);


--
-- Name: posting_rule_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX posting_rule_properties ON posting_rules USING GIN (properties);


--
-- Name: tickets_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX tickets_properties ON tickets USING GIN (properties);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING BTREE (version);


--
-- Name: users_preferences; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_preferences ON users USING GIN (preferences);


--
-- Name: queue_classic_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER queue_classic_notify AFTER INSERT ON queue_classic_jobs FOR EACH ROW EXECUTE PROCEDURE queue_classic_notify();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", PUBLIC;

INSERT INTO schema_migrations (version) VALUES ('20120704151322');

INSERT INTO schema_migrations (version) VALUES ('20120704181734');

INSERT INTO schema_migrations (version) VALUES ('20120704190621');

INSERT INTO schema_migrations (version) VALUES ('20120704223926');

INSERT INTO schema_migrations (version) VALUES ('20120705230229');

INSERT INTO schema_migrations (version) VALUES ('20120708222603');

INSERT INTO schema_migrations (version) VALUES ('20120710230555');

INSERT INTO schema_migrations (version) VALUES ('20120713004949');

INSERT INTO schema_migrations (version) VALUES ('20120721211352');

INSERT INTO schema_migrations (version) VALUES ('20120723001336');

INSERT INTO schema_migrations (version) VALUES ('20120723001729');

INSERT INTO schema_migrations (version) VALUES ('20120728234635');

INSERT INTO schema_migrations (version) VALUES ('20120729004145');

INSERT INTO schema_migrations (version) VALUES ('20120826165628');

INSERT INTO schema_migrations (version) VALUES ('20120903170416');

INSERT INTO schema_migrations (version) VALUES ('20120913012228');

INSERT INTO schema_migrations (version) VALUES ('20120922191407');

INSERT INTO schema_migrations (version) VALUES ('20120922203321');

INSERT INTO schema_migrations (version) VALUES ('20120922222159');

INSERT INTO schema_migrations (version) VALUES ('20120924135352');

INSERT INTO schema_migrations (version) VALUES ('20120924181422');

INSERT INTO schema_migrations (version) VALUES ('20120924223626');

INSERT INTO schema_migrations (version) VALUES ('20120930003700');

INSERT INTO schema_migrations (version) VALUES ('20121006193521');

INSERT INTO schema_migrations (version) VALUES ('20121007000257');

INSERT INTO schema_migrations (version) VALUES ('20121007001106');

INSERT INTO schema_migrations (version) VALUES ('20121008215845');

INSERT INTO schema_migrations (version) VALUES ('20121014024705');

INSERT INTO schema_migrations (version) VALUES ('20121014025517');

INSERT INTO schema_migrations (version) VALUES ('20121112203500');

INSERT INTO schema_migrations (version) VALUES ('20121117234531');

INSERT INTO schema_migrations (version) VALUES ('20121118203752');

INSERT INTO schema_migrations (version) VALUES ('20121118205934');

INSERT INTO schema_migrations (version) VALUES ('20121118210833');

INSERT INTO schema_migrations (version) VALUES ('20121210210935');

INSERT INTO schema_migrations (version) VALUES ('20121210212038');

INSERT INTO schema_migrations (version) VALUES ('20121210223753');

INSERT INTO schema_migrations (version) VALUES ('20121210231615');

INSERT INTO schema_migrations (version) VALUES ('20121213020959');

INSERT INTO schema_migrations (version) VALUES ('20121213023608');

INSERT INTO schema_migrations (version) VALUES ('20121215190033');

INSERT INTO schema_migrations (version) VALUES ('20121221212034');

INSERT INTO schema_migrations (version) VALUES ('20121221213004');

INSERT INTO schema_migrations (version) VALUES ('20121223160904');

INSERT INTO schema_migrations (version) VALUES ('20121225213720');

INSERT INTO schema_migrations (version) VALUES ('20130104150624');

INSERT INTO schema_migrations (version) VALUES ('20130113000418');

INSERT INTO schema_migrations (version) VALUES ('20130113015616');

INSERT INTO schema_migrations (version) VALUES ('20130113015617');

INSERT INTO schema_migrations (version) VALUES ('20130113204230');

INSERT INTO schema_migrations (version) VALUES ('20130113204959');

INSERT INTO schema_migrations (version) VALUES ('20130126202409');

INSERT INTO schema_migrations (version) VALUES ('20130126212838');

INSERT INTO schema_migrations (version) VALUES ('20130126222702');

INSERT INTO schema_migrations (version) VALUES ('20130126224854');

INSERT INTO schema_migrations (version) VALUES ('20130126224950');

INSERT INTO schema_migrations (version) VALUES ('20130127161311');

INSERT INTO schema_migrations (version) VALUES ('20130127190806');

INSERT INTO schema_migrations (version) VALUES ('20130202173614');

INSERT INTO schema_migrations (version) VALUES ('20130204224230');

INSERT INTO schema_migrations (version) VALUES ('20130204225944');

INSERT INTO schema_migrations (version) VALUES ('20130206161804');

INSERT INTO schema_migrations (version) VALUES ('20130207021229');

INSERT INTO schema_migrations (version) VALUES ('20130207211940');

INSERT INTO schema_migrations (version) VALUES ('20130210220518');

INSERT INTO schema_migrations (version) VALUES ('20130220234449');

INSERT INTO schema_migrations (version) VALUES ('20130221011908');

INSERT INTO schema_migrations (version) VALUES ('20130221021230');

INSERT INTO schema_migrations (version) VALUES ('20130221022202');

INSERT INTO schema_migrations (version) VALUES ('20130221200612');

INSERT INTO schema_migrations (version) VALUES ('20130221224346');

INSERT INTO schema_migrations (version) VALUES ('20130223155928');

INSERT INTO schema_migrations (version) VALUES ('20130228034538');

INSERT INTO schema_migrations (version) VALUES ('20130303025912');

INSERT INTO schema_migrations (version) VALUES ('20130303030100');

INSERT INTO schema_migrations (version) VALUES ('20130303232630');

INSERT INTO schema_migrations (version) VALUES ('20130317032112');

INSERT INTO schema_migrations (version) VALUES ('20130318012745');

INSERT INTO schema_migrations (version) VALUES ('20130326145646');

INSERT INTO schema_migrations (version) VALUES ('20130412030121');

INSERT INTO schema_migrations (version) VALUES ('20130413135821');

INSERT INTO schema_migrations (version) VALUES ('20130414143212');

INSERT INTO schema_migrations (version) VALUES ('20130427164241');

INSERT INTO schema_migrations (version) VALUES ('20130427203818');

INSERT INTO schema_migrations (version) VALUES ('20130505140727');

INSERT INTO schema_migrations (version) VALUES ('20130601172948');

INSERT INTO schema_migrations (version) VALUES ('20130601183526');

INSERT INTO schema_migrations (version) VALUES ('20130601183731');

INSERT INTO schema_migrations (version) VALUES ('20130908213000');

INSERT INTO schema_migrations (version) VALUES ('20130908213106');

INSERT INTO schema_migrations (version) VALUES ('20130922221253');

INSERT INTO schema_migrations (version) VALUES ('20130929170831');

INSERT INTO schema_migrations (version) VALUES ('20130929210440');

INSERT INTO schema_migrations (version) VALUES ('20131020200548');

INSERT INTO schema_migrations (version) VALUES ('20131103211129');

INSERT INTO schema_migrations (version) VALUES ('20131103214024');

INSERT INTO schema_migrations (version) VALUES ('20131103214326');

INSERT INTO schema_migrations (version) VALUES ('20131126151013');

INSERT INTO schema_migrations (version) VALUES ('20131128162923');

INSERT INTO schema_migrations (version) VALUES ('20131212150135');

INSERT INTO schema_migrations (version) VALUES ('20131215030926');

INSERT INTO schema_migrations (version) VALUES ('20131215150115');

INSERT INTO schema_migrations (version) VALUES ('20131222211257');

INSERT INTO schema_migrations (version) VALUES ('20131226183502');

INSERT INTO schema_migrations (version) VALUES ('20131226221754');

INSERT INTO schema_migrations (version) VALUES ('20131227192918');

INSERT INTO schema_migrations (version) VALUES ('20131229193157');

INSERT INTO schema_migrations (version) VALUES ('20131230231007');

INSERT INTO schema_migrations (version) VALUES ('20131230231018');

INSERT INTO schema_migrations (version) VALUES ('20131231165209');

INSERT INTO schema_migrations (version) VALUES ('20140119185047');

INSERT INTO schema_migrations (version) VALUES ('20140125215407');

INSERT INTO schema_migrations (version) VALUES ('20140126025608');

INSERT INTO schema_migrations (version) VALUES ('20140126212619');