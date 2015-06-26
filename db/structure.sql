--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
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
    balance_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    agreement_id integer,
    external_ref character varying(255),
    collector_id integer,
    collector_type character varying(255),
    matching_entry_id integer,
    notes character varying(255)
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
    balance_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    synch_status integer
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
    id integer NOT NULL,
    namespace character varying(255),
    body text,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
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
    updated_at timestamp without time zone NOT NULL
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
    buyer_type character varying(255),
    creator_id integer,
    updater_id integer,
    provider_bom_id integer,
    subcon_bom_id integer,
    description character varying(255)
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
-- Name: comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    commentable_id integer DEFAULT 0,
    commentable_type character varying(255),
    title character varying(255),
    body text,
    subject character varying(255),
    user_id integer DEFAULT 0 NOT NULL,
    parent_id integer,
    lft integer,
    rgt integer,
    public boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


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
    updater_id integer,
    status integer,
    properties hstore,
    notes text
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
    description text,
    eventable_type character varying(255),
    eventable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer,
    reference_id integer,
    creator_id integer,
    updater_id integer,
    triggering_event_id integer,
    properties hstore
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
    id integer NOT NULL,
    message character varying(255),
    organization_id integer,
    affiliate_id integer,
    status integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    updater_id integer
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
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoice_items (
    id integer NOT NULL,
    invoice_id integer,
    invoiceable_id integer,
    invoiceable_type character varying(255)
);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoice_items_id_seq OWNED BY invoice_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invoices (
    id integer NOT NULL,
    account_id integer,
    invoiceable_id integer,
    organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    updater_id integer,
    notes text,
    total_cents integer,
    total_currency character varying(255),
    invoiceable_type character varying(255)
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoices_id_seq OWNED BY invoices.id;


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
    price_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    deleted_at timestamp without time zone
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
    type character varying(255),
    event_id integer
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
    updated_at timestamp without time zone NOT NULL,
    parent_org_id integer,
    industry character varying(255),
    other_industry character varying(255),
    properties hstore
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
-- Name: projects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying(255),
    status integer,
    description text,
    creator_id integer,
    updater_id integer,
    deleter_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    organization_id integer,
    customer_id integer,
    provider_id integer,
    provider_agreement_id integer,
    start_date date,
    end_date date,
    external_ref character varying(255)
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


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
-- Name: statements; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE statements (
    id integer NOT NULL,
    data json,
    creator_id integer,
    updater_id integer,
    statementable_id integer,
    statementable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: statements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE statements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: statements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE statements_id_seq OWNED BY statements.id;


--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE support_tickets (
    id integer NOT NULL,
    subject character varying(255),
    description text,
    status integer,
    organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    updater_id integer
);


--
-- Name: support_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE support_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE support_tickets_id_seq OWNED BY support_tickets.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(128),
    created_at timestamp without time zone
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
    id integer NOT NULL,
    name character varying(255),
    organization_id integer
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
    transferable boolean DEFAULT true,
    allow_collection boolean DEFAULT true,
    collector_id integer,
    collector_type character varying(255),
    provider_status integer,
    work_status integer,
    re_transfer boolean DEFAULT true,
    subcon_payment character varying(255),
    provider_payment character varying(255),
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
    subcon_agreement_id integer,
    provider_agreement_id integer,
    tax double precision DEFAULT 0.0,
    subcon_fee_cents integer DEFAULT 0 NOT NULL,
    subcon_fee_currency character varying(255) DEFAULT 'USD'::character varying NOT NULL,
    properties hstore,
    external_ref character varying(255),
    subcon_collection_status integer,
    prov_collection_status integer,
    project_id integer
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
    time_zone character varying(255),
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying(255),
    authentication_token character varying(255),
    status integer
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
    id integer NOT NULL,
    item_type character varying(255) NOT NULL,
    item_id integer NOT NULL,
    event character varying(255) NOT NULL,
    whodunnit character varying(255),
    object text,
    created_at timestamp without time zone,
    assoc_id integer
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

ALTER TABLE ONLY accounting_entries ALTER COLUMN id SET DEFAULT nextval('accounting_entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


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

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


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

ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_items ALTER COLUMN id SET DEFAULT nextval('invoice_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices ALTER COLUMN id SET DEFAULT nextval('invoices_id_seq'::regclass);


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

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY statements ALTER COLUMN id SET DEFAULT nextval('statements_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY support_tickets ALTER COLUMN id SET DEFAULT nextval('support_tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tickets ALTER COLUMN id SET DEFAULT nextval('tickets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


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
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


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
-- Name: invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


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
-- Name: projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


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
-- Name: statements_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY statements
    ADD CONSTRAINT statements_pkey PRIMARY KEY (id);


--
-- Name: support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


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
-- Name: customer_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customer_properties ON customers USING gin (properties);


--
-- Name: events_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX events_properties ON events USING gin (properties);


--
-- Name: index_accounts_on_accountable_id_and_accountable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_accountable_id_and_accountable_type ON accounts USING btree (accountable_id, accountable_type);


--
-- Name: index_accounts_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_accounts_on_organization_id ON accounts USING btree (organization_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_boms_on_material_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_boms_on_material_id ON boms USING btree (material_id);


--
-- Name: index_comments_on_commentable_id_and_commentable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_commentable_id_and_commentable_type ON comments USING btree (commentable_id, commentable_type);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_comments_on_user_id ON comments USING btree (user_id);


--
-- Name: index_customers_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_on_organization_id ON customers USING btree (organization_id);


--
-- Name: index_events_on_eventable_id_and_eventable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_events_on_eventable_id_and_eventable_type ON events USING btree (eventable_id, eventable_type);


--
-- Name: index_invoice_items_on_invoice_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invoice_items_on_invoice_id ON invoice_items USING btree (invoice_id);


--
-- Name: index_invoices_on_invoiceable_id_and_invoiceable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invoices_on_invoiceable_id_and_invoiceable_type ON invoices USING btree (invoiceable_id, invoiceable_type);


--
-- Name: index_invoices_on_ticket_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_invoices_on_ticket_id ON invoices USING btree (invoiceable_id);


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
-- Name: index_projects_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_name ON projects USING btree (name);


--
-- Name: index_projects_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_projects_on_organization_id ON projects USING btree (organization_id);


--
-- Name: index_service_calls_on_ref_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_service_calls_on_ref_id ON tickets USING btree (ref_id);


--
-- Name: index_support_tickets_on_creator_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_tickets_on_creator_id ON support_tickets USING btree (creator_id);


--
-- Name: index_support_tickets_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_support_tickets_on_organization_id ON support_tickets USING btree (organization_id);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_tags_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tags_on_organization_id ON tags USING btree (organization_id);


--
-- Name: index_tickets_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_organization_id ON tickets USING btree (organization_id);


--
-- Name: index_tickets_on_organization_id_and_external_ref; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_organization_id_and_external_ref ON tickets USING btree (organization_id, external_ref);


--
-- Name: index_tickets_on_project_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tickets_on_project_id ON tickets USING btree (project_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


--
-- Name: org_preferences; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX org_preferences ON organizations USING gin (properties);


--
-- Name: organization_company; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organization_company ON organizations USING gin (to_tsvector('english'::regconfig, (company)::text));


--
-- Name: organization_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organization_name ON organizations USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: posting_rule_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX posting_rule_properties ON posting_rules USING gin (properties);


--
-- Name: tickets_properties; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX tickets_properties ON tickets USING gin (properties);


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

SET search_path TO "$user",public;

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

INSERT INTO schema_migrations (version) VALUES ('20140125215407');

INSERT INTO schema_migrations (version) VALUES ('20140126025608');

INSERT INTO schema_migrations (version) VALUES ('20140126212619');

INSERT INTO schema_migrations (version) VALUES ('20140216195150');

INSERT INTO schema_migrations (version) VALUES ('20140301234659');

INSERT INTO schema_migrations (version) VALUES ('20140518213919');

INSERT INTO schema_migrations (version) VALUES ('20140519171406');

INSERT INTO schema_migrations (version) VALUES ('20140610111510');

INSERT INTO schema_migrations (version) VALUES ('20140610112820');

INSERT INTO schema_migrations (version) VALUES ('20140628193518');

INSERT INTO schema_migrations (version) VALUES ('20140702162338');

INSERT INTO schema_migrations (version) VALUES ('20140707225143');

INSERT INTO schema_migrations (version) VALUES ('20140711005442');

INSERT INTO schema_migrations (version) VALUES ('20140721221038');

INSERT INTO schema_migrations (version) VALUES ('20140727214318');

INSERT INTO schema_migrations (version) VALUES ('20140814011609');

INSERT INTO schema_migrations (version) VALUES ('20140816182238');

INSERT INTO schema_migrations (version) VALUES ('20140821173348');

INSERT INTO schema_migrations (version) VALUES ('20140821181139');

INSERT INTO schema_migrations (version) VALUES ('20140821182012');

INSERT INTO schema_migrations (version) VALUES ('20140829015934');

INSERT INTO schema_migrations (version) VALUES ('20140909193308');

INSERT INTO schema_migrations (version) VALUES ('20140915221955');

INSERT INTO schema_migrations (version) VALUES ('20140917174836');

INSERT INTO schema_migrations (version) VALUES ('20140917202020');

INSERT INTO schema_migrations (version) VALUES ('20140919160011');

INSERT INTO schema_migrations (version) VALUES ('20140927170153');

INSERT INTO schema_migrations (version) VALUES ('20140929121116');

INSERT INTO schema_migrations (version) VALUES ('20141003173847');

INSERT INTO schema_migrations (version) VALUES ('20141103223042');

INSERT INTO schema_migrations (version) VALUES ('20141205152411');

INSERT INTO schema_migrations (version) VALUES ('20141205173122');

INSERT INTO schema_migrations (version) VALUES ('20141209225427');

INSERT INTO schema_migrations (version) VALUES ('20141210173610');

INSERT INTO schema_migrations (version) VALUES ('20141211165059');

INSERT INTO schema_migrations (version) VALUES ('20141222222707');

INSERT INTO schema_migrations (version) VALUES ('20141226160730');

INSERT INTO schema_migrations (version) VALUES ('20141226202747');

INSERT INTO schema_migrations (version) VALUES ('20141230235139');

INSERT INTO schema_migrations (version) VALUES ('20150109042406');

INSERT INTO schema_migrations (version) VALUES ('20150109140256');

INSERT INTO schema_migrations (version) VALUES ('20150410222501');

INSERT INTO schema_migrations (version) VALUES ('20150617222722');

INSERT INTO schema_migrations (version) VALUES ('20150619114225');