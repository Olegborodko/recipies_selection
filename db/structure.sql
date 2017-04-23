--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: favorite_recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE favorite_recipes (
    id integer NOT NULL,
    user_id integer,
    recipe_id integer,
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: favorite_recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE favorite_recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorite_recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE favorite_recipes_id_seq OWNED BY favorite_recipes.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: ingredient_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ingredient_categories (
    id integer NOT NULL,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: ingredient_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ingredient_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ingredient_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ingredient_categories_id_seq OWNED BY ingredient_categories.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ingredients (
    id integer NOT NULL,
    name character varying,
    content text,
    href character varying,
    ingredient_category_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    calories integer,
    protein integer,
    fat integer,
    carbohydrate integer
);


--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ingredients_id_seq OWNED BY ingredients.id;


--
-- Name: ingredients_recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ingredients_recipes (
    recipe_id integer NOT NULL,
    ingredient_id integer NOT NULL
);


--
-- Name: recipe_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recipe_categories (
    id integer NOT NULL,
    title character varying
);


--
-- Name: recipe_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recipe_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipe_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recipe_categories_id_seq OWNED BY recipe_categories.id;


--
-- Name: recipe_ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recipe_ingredients (
    id integer NOT NULL,
    recipe_id integer,
    ingredient_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    number_of_ingredient character varying
);


--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recipe_ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipe_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recipe_ingredients_id_seq OWNED BY recipe_ingredients.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE recipes (
    id integer NOT NULL,
    name character varying,
    content text,
    recipe_category_id integer,
    cooking_time character varying,
    calories integer,
    protein integer,
    fat integer,
    carbohydrate integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE recipes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE recipes_id_seq OWNED BY recipes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    name character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rid character varying,
    slug character varying
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

ALTER TABLE ONLY favorite_recipes ALTER COLUMN id SET DEFAULT nextval('favorite_recipes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ingredient_categories ALTER COLUMN id SET DEFAULT nextval('ingredient_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ingredients ALTER COLUMN id SET DEFAULT nextval('ingredients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_categories ALTER COLUMN id SET DEFAULT nextval('recipe_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_ingredients ALTER COLUMN id SET DEFAULT nextval('recipe_ingredients_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes ALTER COLUMN id SET DEFAULT nextval('recipes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: favorite_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY favorite_recipes
    ADD CONSTRAINT favorite_recipes_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: ingredient_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ingredient_categories
    ADD CONSTRAINT ingredient_categories_pkey PRIMARY KEY (id);


--
-- Name: ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipe_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_categories
    ADD CONSTRAINT recipe_categories_pkey PRIMARY KEY (id);


--
-- Name: recipe_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipe_ingredients
    ADD CONSTRAINT recipe_ingredients_pkey PRIMARY KEY (id);


--
-- Name: recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_favorite_recipes_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorite_recipes_on_recipe_id ON favorite_recipes USING btree (recipe_id);


--
-- Name: index_favorite_recipes_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_favorite_recipes_on_user_id ON favorite_recipes USING btree (user_id);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_ingredients_on_ingredient_category_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ingredients_on_ingredient_category_id_and_created_at ON ingredients USING btree (ingredient_category_id, created_at);


--
-- Name: index_ingredients_recipes_on_ingredient_id_and_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ingredients_recipes_on_ingredient_id_and_recipe_id ON ingredients_recipes USING btree (ingredient_id, recipe_id);


--
-- Name: index_ingredients_recipes_on_recipe_id_and_ingredient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ingredients_recipes_on_recipe_id_and_ingredient_id ON ingredients_recipes USING btree (recipe_id, ingredient_id);


--
-- Name: index_recipe_ingredients_on_ingredient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipe_ingredients_on_ingredient_id ON recipe_ingredients USING btree (ingredient_id);


--
-- Name: index_recipe_ingredients_on_recipe_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipe_ingredients_on_recipe_id ON recipe_ingredients USING btree (recipe_id);


--
-- Name: index_recipes_on_recipe_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_recipes_on_recipe_category_id ON recipes USING btree (recipe_category_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_rid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_rid ON users USING btree (rid);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: index_users_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_status ON users USING btree (status);


--
-- Name: recipes_content; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX recipes_content ON recipes USING gin (to_tsvector('russian'::regconfig, content));


--
-- Name: recipes_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX recipes_name ON recipes USING gin (to_tsvector('russian'::regconfig, (name)::text));


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170212133004'),
('20170212133432'),
('20170217225233'),
('20170222124837'),
('20170222125003'),
('20170223153409'),
('20170223171716'),
('20170223174252'),
('20170223202547'),
('20170223205513'),
('20170302132802'),
('20170303204657'),
('20170304181200'),
('20170304204631'),
('20170306195818'),
('20170306201622'),
('20170315121656'),
('20170323102236'),
('20170323111527'),
('20170404142938'),
('20170404152439'),
('20170423173932');


