--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Debian 17.5-1.pgdg110+1)
-- Dumped by pg_dump version 17.5 (Debian 17.5-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: joueurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.joueurs (
    id_joueur integer NOT NULL,
    pseudo character varying(50) NOT NULL,
    date_creation timestamp without time zone DEFAULT now()
);


ALTER TABLE public.joueurs OWNER TO postgres;

--
-- Name: joueurs_id_joueur_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.joueurs_id_joueur_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.joueurs_id_joueur_seq OWNER TO postgres;

--
-- Name: joueurs_id_joueur_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.joueurs_id_joueur_seq OWNED BY public.joueurs.id_joueur;


--
-- Name: objets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.objets (
    id_objet integer NOT NULL,
    nom character varying(100) NOT NULL,
    description text,
    type_objet character varying(30),
    code_deverrouille character varying(20),
    id_objet_precedent integer,
    indice_precedent text,
    indice_propre text,
    indice_suivant text,
    trouve boolean DEFAULT false,
    visible boolean DEFAULT true,
    niveau_zoom_min integer,
    icone character varying(200),
    geom public.geometry(Point,4326),
    CONSTRAINT objets_type_objet_check CHECK (((type_objet)::text = ANY ((ARRAY['recuperable'::character varying, 'code'::character varying, 'bloque_objet'::character varying, 'bloque_code'::character varying, 'final_objet'::character varying])::text[])))
);


ALTER TABLE public.objets OWNER TO postgres;

--
-- Name: objets_id_objet_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.objets_id_objet_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.objets_id_objet_seq OWNER TO postgres;

--
-- Name: objets_id_objet_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.objets_id_objet_seq OWNED BY public.objets.id_objet;


--
-- Name: points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.points (
    id integer NOT NULL,
    name text,
    geom public.geometry(Point,4326)
);


ALTER TABLE public.points OWNER TO postgres;

--
-- Name: points_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.points_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.points_id_seq OWNER TO postgres;

--
-- Name: points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.points_id_seq OWNED BY public.points.id;


--
-- Name: scores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scores (
    id_score integer NOT NULL,
    id_joueur integer,
    temps_total integer,
    objets_trouves integer,
    score_total integer,
    date_partie timestamp without time zone DEFAULT now()
);


ALTER TABLE public.scores OWNER TO postgres;

--
-- Name: scores_id_score_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scores_id_score_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scores_id_score_seq OWNER TO postgres;

--
-- Name: scores_id_score_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scores_id_score_seq OWNED BY public.scores.id_score;


--
-- Name: joueurs id_joueur; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueurs ALTER COLUMN id_joueur SET DEFAULT nextval('public.joueurs_id_joueur_seq'::regclass);


--
-- Name: objets id_objet; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objets ALTER COLUMN id_objet SET DEFAULT nextval('public.objets_id_objet_seq'::regclass);


--
-- Name: points id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points ALTER COLUMN id SET DEFAULT nextval('public.points_id_seq'::regclass);


--
-- Name: scores id_score; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scores ALTER COLUMN id_score SET DEFAULT nextval('public.scores_id_score_seq'::regclass);


--
-- Data for Name: joueurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.joueurs VALUES (1, 'v', '2025-11-24 20:34:19.38144');
INSERT INTO public.joueurs VALUES (2, 'gabriel_top_1', '2025-11-24 20:37:23.989194');


--
-- Data for Name: objets; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.objets VALUES (1, 'Singe vietnamien', 'Tu as trouvé le singe vietnamien à Senlis ! Mouerf', 'recuperable', NULL, NULL, 'Tu es à la recherche des 4 singes de France afin de les ramener à leur zoo et débloquer LA banane 🍌!', 'Indice conduisant au singe vietnamien (Objet 1) : ville dans laquelle se trouvait la résidence principale d’Hugues Capet', 'Indice conduisant au singe normand (Objet 2) : ville des pruneaux de la Garonne', false, true, 13, 'img/singe_vietnamien.png', '0101000020E6100000931804560EAD044043AD69DE719A4840');
INSERT INTO public.objets VALUES (2, 'Singe normand', 'Tu as trouvé le singe normand et son code à Agen ! ', 'code', '76470', 1, 'Indice conduisant au singe vietnamien (Objet 1) : ville dans laquelle se trouvait la résidence principale d’Hugues Capet', 'Indice conduisant au singe normand (Objet 2) : ville des pruneaux de la Garonne', 'Indice conduisant au singe portugais (Objet 3) : ville entre deux lacs en altitude (74)', false, true, 15, 'img/singe_normand.png', '0101000020E6100000E09C11A5BDC1E33F7DD0B359F5194640');
INSERT INTO public.objets VALUES (3, 'Singe portugais', 'Tu as trouvé le singe portugais à Rumilly !', 'bloque_code', NULL, 2, 'Pas trop vite ! Tu as oublié le code du singe normand. Indice conduisant au singe normand et au code (Objet 2) : ville des pruneaux de la Garonne', 'Indice conduisant au singe portugais (Objet 3) : ville entre deux lacs en altitude (74)', 'Indice conduisant au singe ukrainien (Objet 4) : ville située du côté ouest de Versailles', false, true, 15, 'img/singe_portugais.png', '0101000020E61000001283C0CAA1C51740AC8BDB6800EF4640');
INSERT INTO public.objets VALUES (4, 'Singe ukrainien', 'Tu as trouvé le singe ukrainien à Fontenay-le Fleury ! ', 'bloque_objet', NULL, 3, 'Pas trop vite ! Tu as oublié le singe portugais. Indice conduisant au singe portugais (Objet 3) : ville entre deux lacs en altitude (74)', 'Indice conduisant au singe ukrainien (Objet 4) : ville située du côté ouest de Versailles', 'Indice conduisant à LA banane (Objet 5) : Zoo situé dans une ville du nord de la France, célèbre pour sa cathédrale sur la Somme', false, true, 15, 'img/singe_ukrainien.png', '0101000020E610000091ED7C3F355E0040F241CF66D5674840');
INSERT INTO public.objets VALUES (5, 'LA banane', 'Objet 5 au Zoo d’Amiens. Vérifie possession de tous les objets précédents.', 'final_objet', NULL, 4, 'Il te faut les 4 singes pour débloquer cet objet !
     Indice conduisant au singe vietnamien (Objet 1) : Senlis
     Indice conduisant au singe normand (Objet 2) : Agen
     Indice conduisant au singe portugais (Objet 3) : Rumilly
     Indice conduisant au singe ukrainien (Objet 4) : Fontenay-le-Fleury', 'Indice conduisant à LA banane (Objet 5) : Zoo situé dans une ville du nord de la France, célèbre pour sa cathédrale sur la Somme', 'pas indice suivant', false, true, 16, 'img/banane.png', '0101000020E61000009EEFA7C64B370240C1A8A44E40F34840');


--
-- Data for Name: points; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.points VALUES (1, 'Paris', '0101000020E6100000A835CD3B4ED1024076E09C11A56D4840');
INSERT INTO public.points VALUES (2, 'Lyon', '0101000020E61000009D11A5BDC15713406F1283C0CAE14640');
INSERT INTO public.points VALUES (3, 'Marseille', '0101000020E6100000423EE8D9AC7A1540CBA145B6F3A54540');


--
-- Data for Name: scores; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.scores VALUES (1, 1, 89, 4, 4110, '2025-11-24 20:35:48.835363');
INSERT INTO public.scores VALUES (2, 2, 98, 4, 4020, '2025-11-24 20:39:30.152882');


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--



--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--



--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--



--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--



--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--



--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--



--
-- Name: joueurs_id_joueur_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.joueurs_id_joueur_seq', 2, true);


--
-- Name: objets_id_objet_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.objets_id_objet_seq', 1, false);


--
-- Name: points_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.points_id_seq', 3, true);


--
-- Name: scores_id_score_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scores_id_score_seq', 2, true);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: joueurs joueurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueurs
    ADD CONSTRAINT joueurs_pkey PRIMARY KEY (id_joueur);


--
-- Name: joueurs joueurs_pseudo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.joueurs
    ADD CONSTRAINT joueurs_pseudo_key UNIQUE (pseudo);


--
-- Name: objets objets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objets
    ADD CONSTRAINT objets_pkey PRIMARY KEY (id_objet);


--
-- Name: points points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.points
    ADD CONSTRAINT points_pkey PRIMARY KEY (id);


--
-- Name: scores scores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scores
    ADD CONSTRAINT scores_pkey PRIMARY KEY (id_score);


--
-- Name: objets objets_id_objet_precedent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.objets
    ADD CONSTRAINT objets_id_objet_precedent_fkey FOREIGN KEY (id_objet_precedent) REFERENCES public.objets(id_objet);


--
-- Name: scores scores_id_joueur_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scores
    ADD CONSTRAINT scores_id_joueur_fkey FOREIGN KEY (id_joueur) REFERENCES public.joueurs(id_joueur) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

