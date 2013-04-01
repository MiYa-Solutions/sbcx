--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounting_entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounting_entries (
    id integer NOT NULL,
    status integer,
    event_id integer,
    amount_cents integer DEFAULT 0 NOT NULL,
    amount_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    ticket_id integer,
    account_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type character varying(255),
    description character varying(255),
    balance_cents integer DEFAULT 0 NOT NULL,
    balance_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL
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
    id integer NOT NULL,
    organization_id integer NOT NULL,
    accountable_id integer NOT NULL,
    accountable_type character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    balance_cents integer DEFAULT 0 NOT NULL,
    balance_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL
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
-- Name: agreements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE agreements (
    id integer NOT NULL,
    name character varying(255),
    counterparty_id integer,
    organization_id integer,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer,
    counterparty_type character varying(255),
    type character varying(255),
    creator_id integer,
    updater_id integer,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    payment_terms character varying(255)
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
    id integer NOT NULL,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    title character varying(255),
    description text,
    all_day boolean,
    recurring boolean,
    appointable_id integer,
    appointable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    updater_id integer,
    organization_id integer
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
    id integer NOT NULL,
    user_id integer,
    role_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    id integer NOT NULL,
    ticket_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quantity numeric,
    material_id integer,
    cost_cents integer DEFAULT 0 NOT NULL,
    cost_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    price_cents integer DEFAULT 0 NOT NULL,
    price_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    buyer_id integer,
    buyer_type character varying(255)
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
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    categorizable_type character varying(255),
    categorizable_id integer,
    name character varying(255),
    description character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
    id integer NOT NULL,
    name character varying(255),
    organization_id integer,
    company character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    country character varying(255),
    phone character varying(255),
    mobile_phone character varying(255),
    work_phone character varying(255),
    email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    updater_id integer
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
    id integer NOT NULL,
    name character varying(255),
    type character varying(255),
    description character varying(255),
    eventable_type character varying(255),
    eventable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    reference_id integer,
    creator_id integer,
    updater_id integer,
    triggering_event_id integer
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
-- Name: materials; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE materials (
    id integer NOT NULL,
    organization_id integer,
    supplier_id integer,
    name character varying(255),
    description text,
    creator_id integer,
    updater_id integer,
    status integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cost_cents integer DEFAULT 0 NOT NULL,
    cost_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    price_cents integer DEFAULT 0 NOT NULL,
    price_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL
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
    id integer NOT NULL,
    subject character varying(255),
    content text,
    status integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notifiable_id integer,
    notifiable_type character varying(255),
    type character varying(255)
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
    id integer NOT NULL,
    organization_id integer,
    organization_role_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    id integer NOT NULL,
    name character varying(255),
    phone character varying(255),
    website character varying(255),
    company character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    country character varying(255),
    mobile character varying(255),
    work_phone character varying(255),
    email character varying(255),
    subcontrax_member boolean,
    status integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    id integer NOT NULL,
    agreement_id integer,
    type character varying(255),
    rate double precision,
    rate_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    id integer NOT NULL,
    agreement_id integer,
    type character varying(255),
    rate numeric,
    rate_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    properties hstore,
    time_bound boolean DEFAULT false,
    sunday boolean DEFAULT false,
    monday boolean DEFAULT false,
    tuesday boolean DEFAULT false,
    wednesday boolean DEFAULT false,
    thursday boolean DEFAULT false,
    friday boolean DEFAULT false,
    saturday boolean DEFAULT false,
    sunday_from time without time zone,
    monday_from time without time zone,
    tuesday_from time without time zone,
    wednesday_from time without time zone,
    thursday_from time without time zone,
    friday_from time without time zone,
    saturday_from time without time zone,
    sunday_to time without time zone,
    monday_to time without time zone,
    tuesday_to time without time zone,
    wednesday_to time without time zone,
    thursday_to time without time zone,
    friday_to time without time zone,
    saturday_to time without time zone
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
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    version character varying(255) NOT NULL
);


--
-- Name: tickets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tickets (
    id integer NOT NULL,
    customer_id integer,
    notes text,
    started_on timestamp without time zone,
    organization_id integer,
    completed_on timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer,
    subcontractor_id integer,
    technician_id integer,
    provider_id integer,
    subcontractor_status integer,
    type character varying(255),
    ref_id integer,
    creator_id integer,
    updater_id integer,
    settled_on timestamp without time zone,
    billing_status integer,
    settlement_date timestamp without time zone,
    name character varying(255),
    scheduled_for timestamp without time zone,
    transferable boolean DEFAULT false,
    allow_collection boolean DEFAULT true,
    collector_id integer,
    collector_type character varying(255),
    provider_status integer,
    work_status integer,
    re_transfer boolean,
    payment_type character varying(255),
    subcon_payment character varying(255),
    provider_payment character varying(255)
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
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id integer,
    first_name character varying(255),
    last_name character varying(255),
    phone character varying(255),
    company character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    country character varying(255),
    state character varying(255),
    city character varying(255),
    zip character varying(255),
    mobile_phone character varying(255),
    work_phone character varying(255),
    preferences hstore,
    time_zone character varying(255)
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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounting_entries ALTER COLUMN id SET DEFAULT nextval('accounting_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY agreements ALTER COLUMN id SET DEFAULT nextval('agreements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY appointments ALTER COLUMN id SET DEFAULT nextval('appointments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assignments ALTER COLUMN id SET DEFAULT nextval('assignments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY boms ALTER COLUMN id SET DEFAULT nextval('boms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY materials ALTER COLUMN id SET DEFAULT nextval('materials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY org_to_roles ALTER COLUMN id SET DEFAULT nextval('org_to_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posting_rules ALTER COLUMN id SET DEFAULT nextval('posting_rules_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets ALTER COLUMN id SET DEFAULT nextval('tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


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
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


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
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_accountable_id_and_accountable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_accountable_id_and_accountable_type ON accounts USING btree (accountable_id, accountable_type);


--
-- Name: index_accounts_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_organization_id ON accounts USING btree (organization_id);


--
-- Name: index_boms_on_material_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_boms_on_material_id ON boms USING btree (material_id);


--
-- Name: index_events_on_eventable_id_and_eventable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_eventable_id_and_eventable_type ON events USING btree (eventable_id, eventable_type);


--
-- Name: index_materials_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_materials_on_name ON materials USING btree (name);


--
-- Name: index_materials_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_materials_on_organization_id ON materials USING btree (organization_id);


--
-- Name: index_materials_on_supplier_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_materials_on_supplier_id ON materials USING btree (supplier_id);


--
-- Name: index_org_to_roles_on_organization_id_and_organization_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_org_to_roles_on_organization_id_and_organization_role_id ON org_to_roles USING btree (organization_id, organization_role_id);


--
-- Name: index_service_calls_on_ref_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_service_calls_on_ref_id ON tickets USING btree (ref_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: posting_rule_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX posting_rule_properties ON posting_rules USING gin (properties);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: users_preferences; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_preferences ON users USING gin (preferences);


--
-- PostgreSQL database dump complete
--

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

INSERT INTO schema_migrations (version) VALUES ('20130113015506');

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