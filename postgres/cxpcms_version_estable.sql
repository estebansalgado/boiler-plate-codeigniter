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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: replace_into_role_perms(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION replace_into_role_perms(_roleid integer, _permid integer, _value integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    LOOP
        -- first try to update the key
        -- note that "a" must be unique
        UPDATE role_perms SET value =_value WHERE roleid = _roleid and permid=_permid;
        IF found THEN
            RETURN;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
            INSERT INTO role_perms(roleid, permid,value) VALUES (_roleid,_permid,_value);
            RETURN;
        EXCEPTION WHEN unique_violation THEN
            -- do nothing, and loop to try the UPDATE again
             UPDATE role_perms SET value =_value WHERE roleid = _roleid and permid=_permid;
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION public.replace_into_role_perms(_roleid integer, _permid integer, _value integer) OWNER TO postgres;

--
-- Name: replace_into_user_perms(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION replace_into_user_perms(_userid integer, _permid integer, _value integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    LOOP
        -- first try to update the key
        -- note that "a" must be unique
        UPDATE user_perms SET value =_value WHERE userid = _userid and permid=_permid;
        IF found THEN
            RETURN;
        END IF;
        -- not there, so try to insert the key
        -- if someone else inserts the same key concurrently,
        -- we could get a unique-key failure
        BEGIN
            INSERT INTO user_perms(userid, permid,value) VALUES (_userid,_permid,_value);
            RETURN;
        EXCEPTION WHEN unique_violation THEN
            -- do nothing, and loop to try the UPDATE again
             UPDATE user_perms SET value =_value WHERE userid = _userid and permid=_permid;
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION public.replace_into_user_perms(_userid integer, _permid integer, _value integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE events (
    id integer NOT NULL,
    title character varying(255),
    user_id integer DEFAULT 0 NOT NULL,
    addtime integer DEFAULT 0 NOT NULL,
    start timestamp without time zone,
    _end timestamp without time zone,
    url character varying(255) DEFAULT NULL::character varying,
    backgroundcolor character varying(255) DEFAULT NULL::character varying,
    bordercolor character varying(255) DEFAULT NULL::character varying,
    allday numeric(1,0) DEFAULT 1
);


ALTER TABLE events OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE events_id_seq OWNER TO postgres;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE events_id_seq OWNED BY events.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE permissions (
    id integer NOT NULL,
    permkey character varying(255) NOT NULL,
    permname character varying(255) NOT NULL,
    parent_id integer DEFAULT 0 NOT NULL,
    lft integer DEFAULT 0,
    rgt integer DEFAULT 0,
    root_id integer DEFAULT 0 NOT NULL,
    addtime timestamp without time zone DEFAULT now() NOT NULL,
    sortid integer DEFAULT 0 NOT NULL,
    issys integer DEFAULT 0 NOT NULL,
    permtype integer DEFAULT 0,
    rel_id integer DEFAULT 0
);


ALTER TABLE permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE permissions_id_seq OWNED BY permissions.id;


--
-- Name: permissions_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE permissions_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE permissions_seq OWNER TO postgres;

--
-- Name: role_perms; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE role_perms (
    id integer NOT NULL,
    roleid bigint DEFAULT 0 NOT NULL,
    permid bigint DEFAULT 0 NOT NULL,
    value numeric(1,0) DEFAULT 0 NOT NULL,
    adddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE role_perms OWNER TO postgres;

--
-- Name: role_perms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE role_perms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE role_perms_id_seq OWNER TO postgres;

--
-- Name: role_perms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE role_perms_id_seq OWNED BY role_perms.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    rolename character varying(60) NOT NULL,
    issys integer DEFAULT 0 NOT NULL,
    company_id integer DEFAULT 0
);


ALTER TABLE roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: user_perms; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_perms (
    id integer NOT NULL,
    userid bigint DEFAULT 0 NOT NULL,
    permid bigint DEFAULT 0 NOT NULL,
    value numeric(1,0) DEFAULT 0 NOT NULL,
    adddate timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE user_perms OWNER TO postgres;

--
-- Name: user_perms_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_perms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_perms_id_seq OWNER TO postgres;

--
-- Name: user_perms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_perms_id_seq OWNED BY user_perms.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE user_roles (
    userid integer DEFAULT 0 NOT NULL,
    roleid bigint DEFAULT 0 NOT NULL,
    adddate timestamp without time zone DEFAULT now() NOT NULL,
    id integer NOT NULL
);


ALTER TABLE user_roles OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_roles_id_seq OWNER TO postgres;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: users_a_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_a_seq
    START WITH 23215
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_a_seq OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_a_seq'::regclass) NOT NULL,
    username character varying(255),
    password character varying(255),
    email character varying(255),
    cur_login_time timestamp without time zone,
    cur_login_ip character varying(255),
    cur_login_area character varying(255),
    last_login_ip character varying(255),
    last_login_area character varying(255),
    last_login_time timestamp without time zone,
    reg_time timestamp without time zone DEFAULT now(),
    reg_ip character varying(255),
    reg_area character varying(255),
    status integer,
    login_times integer,
    owner_sites text,
    parent_user_id integer,
    company_id integer,
    photo character varying(255),
    user_type integer,
    issys integer
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: COLUMN users.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN users.id IS 'Numero de usuario';


--
-- Name: COLUMN users.username; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN users.username IS 'Nombre de usuario';


--
-- Name: COLUMN users.password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN users.password IS 'password';


--
-- Name: COLUMN users.cur_login_time; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN users.cur_login_time IS 'Hora de inicio de sesión actual';


--
-- Name: COLUMN users.cur_login_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN users.cur_login_ip IS 'ip desde donde esta conectado actualmente';


--
-- Name: COLUMN users.cur_login_area; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN users.cur_login_area IS 'area de inicio de sesión actual';


--
-- Name: COLUMN users.last_login_ip; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN users.last_login_ip IS 'ip de la ultima sesion ';


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY events ALTER COLUMN id SET DEFAULT nextval('events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY permissions ALTER COLUMN id SET DEFAULT nextval('permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY role_perms ALTER COLUMN id SET DEFAULT nextval('role_perms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_perms ALTER COLUMN id SET DEFAULT nextval('user_perms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY events (id, title, user_id, addtime, start, _end, url, backgroundcolor, bordercolor, allday) FROM stdin;
3	sdfsdfsdf	23207	1447208656	2015-11-12 00:00:00	2015-11-13 00:00:00		rgb(221, 75, 57)	rgb(221, 75, 57)	1
4	sdfvsdfsdf	23207	1447208700	2015-11-14 00:00:00	2015-11-15 00:00:00		rgb(255, 133, 27)		1
16	sdfdsfgdf	23207	1447210716	2015-07-28 00:00:00	2015-07-29 00:00:00	\N	#3c8dbc	#3c8dbc	1
11	xvfvdfv	23207	1447209687	2015-11-10 20:00:00	2015-11-11 00:00:00	\N	#3c8dbc	#3c8dbc	0
13	sdfsdfsdfsdf	23207	1447209888	2015-11-11 02:00:00	2015-11-11 06:30:00	\N	#3c8dbc	#3c8dbc	0
14	zdcsdvsgfbvsdfgb	23207	1447209899	2015-11-14 00:00:00	2015-11-14 03:30:00	\N	rgb(96, 92, 168)	rgb(96, 92, 168)	0
15	sdvsdgsfg	23207	1447209906	2015-11-13 19:00:00	2015-11-14 00:00:00	\N	#3c8dbc	#3c8dbc	0
1	prueba	3	1539362022	2018-10-16 01:30:00	2018-10-16 02:00:00	\N	rgb(0, 115, 183)	rgb(0, 115, 183)	0
2	prueba	3	1539362083	2018-10-16 01:30:00	2018-10-16 02:00:00	\N	rgb(0, 115, 183)	rgb(0, 115, 183)	0
3	prueba2	3	1539362156	2018-10-02 00:00:00	2018-10-03 00:00:00	\N	rgb(243, 156, 18)	rgb(243, 156, 18)	0
4	fgdgdfsg	3	1539362927	2018-10-12 00:00:00	2018-10-13 00:00:00	\N	rgb(0, 31, 63)	rgb(0, 31, 63)	0
5	dfgsdfgs	3	1539362964	2018-10-13 00:00:00	2018-10-14 00:00:00	\N	#3c8dbc	#3c8dbc	1
6	gfdsg	3	1539363122	2018-10-10 00:00:00	2018-10-11 00:00:00	\N	#3c8dbc	#3c8dbc	0
7	prueba	23215	1539480671	2018-10-10 00:00:00	2018-10-11 00:00:00	\N	rgb(0, 192, 239)	rgb(0, 192, 239)	0
\.


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('events_id_seq', 7, true);


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY permissions (id, permkey, permname, parent_id, lft, rgt, root_id, addtime, sortid, issys, permtype, rel_id) FROM stdin;
125	admin_manage	Admin Manage	0	0	0	0	2015-11-21 20:12:58	0	0	0	0
782	admin-permissions	Permissions	125	0	0	0	2015-11-23 13:46:27	0	0	0	0
783	admin-add-permission	Add Permission	782	0	0	0	2015-11-23 13:46:40	0	0	0	0
784	admin-del-permission	Delete Permission	782	0	0	0	2015-11-23 13:46:55	0	0	0	0
785	admin-edit-permission	Edit Permission	782	0	0	0	2015-11-23 13:47:07	0	0	0	0
821	admin-events	Calendar	125	0	0	0	2015-11-24 14:41:40	0	0	0	0
822	admin-add-event	Add Event	821	0	0	0	2015-11-24 14:41:54	0	0	0	0
823	admin-del-event	Delete Event	821	0	0	0	2015-11-24 14:42:08	0	0	0	0
824	admin-edit-event	Edit Event	821	0	0	0	2015-11-24 14:42:23	0	0	0	0
833	admin-users	Users	125	0	0	0	2015-11-24 14:49:07	0	0	0	0
834	admin-add-user	Add User	833	0	0	0	2015-11-24 14:49:22	0	0	0	0
835	admin-del-user	Delete User	833	0	0	0	2015-11-24 14:49:37	0	0	0	0
836	admin-edit-user	Edit User	833	0	0	0	2015-11-24 14:49:50	0	0	0	0
837	admin-roles	Roles	125	0	0	0	2015-11-24 14:50:07	0	0	0	0
838	admin-add-role	Add Role	837	0	0	0	2015-11-24 14:50:20	0	0	0	0
839	admin-del-role	Delete Role	837	0	0	0	2015-11-24 14:50:39	0	0	0	0
840	admin-edit-role	Edit Role	837	0	0	0	2015-11-24 14:50:54	0	0	0	0
841	admin-login-log	Login Log	125	0	0	0	2015-11-24 14:51:28	0	0	0	0
858	admin-login-log1	log	0	0	0	0	2018-09-17 16:49:25	0	0	0	0
\.


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('permissions_id_seq', 1, false);


--
-- Name: permissions_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('permissions_seq', 862, true);


--
-- Data for Name: role_perms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY role_perms (id, roleid, permid, value, adddate) FROM stdin;
5287	5	125	1	2015-11-29 01:53:18
5288	5	782	1	2015-11-29 01:53:18
5289	5	783	1	2015-11-29 01:53:18
5290	5	784	1	2015-11-29 01:53:18
5291	5	785	1	2015-11-29 01:53:18
5292	5	821	1	2015-11-29 01:53:18
5293	5	822	1	2015-11-29 01:53:18
5294	5	823	1	2015-11-29 01:53:18
5295	5	824	1	2015-11-29 01:53:18
5296	5	833	1	2015-11-29 01:53:18
5297	5	834	1	2015-11-29 01:53:18
5298	5	835	1	2015-11-29 01:53:18
5299	5	836	1	2015-11-29 01:53:18
5300	5	837	1	2015-11-29 01:53:18
5301	5	838	1	2015-11-29 01:53:18
5302	5	839	1	2015-11-29 01:53:18
5303	5	840	1	2015-11-29 01:53:18
5304	5	841	1	2015-11-29 01:53:18
5311	4	822	0	2015-11-29 01:53:40
5312	4	823	0	2015-11-29 01:53:40
5313	4	824	0	2015-11-29 01:53:40
5315	4	834	0	2015-11-29 01:53:40
5316	4	835	0	2015-11-29 01:53:40
5317	4	836	0	2015-11-29 01:53:40
5319	4	838	0	2015-11-29 01:53:40
5320	4	839	0	2015-11-29 01:53:40
5321	4	840	0	2015-11-29 01:53:40
5323	5	858	1	2018-09-17 16:49:25
1	3	821	1	2018-10-13 20:28:54.252
2	3	822	1	2018-10-13 20:28:54.252
5305	4	125	1	2015-11-29 01:53:40
5306	4	782	1	2015-11-29 01:53:40
5307	4	783	1	2015-11-29 01:53:40
5308	4	784	1	2015-11-29 01:53:40
5309	4	785	1	2015-11-29 01:53:40
5310	4	821	0	2015-11-29 01:53:40
5314	4	833	0	2015-11-29 01:53:40
5318	4	837	0	2015-11-29 01:53:40
5322	4	841	0	2015-11-29 01:53:40
3	1	782	1	2018-10-15 11:15:33.609
4	1	783	1	2018-10-15 11:15:33.609
5	1	784	1	2018-10-15 11:15:33.609
6	1	785	1	2018-10-15 11:15:33.609
7	1	833	1	2018-10-15 11:15:33.609
8	1	834	1	2018-10-15 11:15:33.609
9	1	835	1	2018-10-15 11:15:33.609
10	1	836	1	2018-10-15 11:15:33.609
\.


--
-- Name: role_perms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('role_perms_id_seq', 10, true);


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY roles (id, rolename, issys, company_id) FROM stdin;
5	Super Admin	1	0
3	Admin	1	0
4	Register User	1	0
1	estudiantes	1	0
\.


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('roles_id_seq', 1, true);


--
-- Data for Name: user_perms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user_perms (id, userid, permid, value, adddate) FROM stdin;
10	23214	8336	0	2018-10-13 14:29:36.635
5	23214	833	1	2018-10-12 18:13:46.319492
4	23214	834	1	2018-10-12 18:12:44.138168
\.


--
-- Name: user_perms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_perms_id_seq', 10, true);


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user_roles (userid, roleid, adddate, id) FROM stdin;
3	5	2015-11-29 02:09:33	79
23214	4	2018-10-12 17:57:31.659058	7
23215	3	2018-10-13 19:43:00.16	8
23216	5	2018-10-14 22:43:05.591	9
23216	3	2018-10-14 22:43:05.591	10
23218	5	2018-10-15 00:45:18.448	18
23217	1	2018-10-15 11:16:15.153	19
23219	5	2018-10-15 23:38:56.45	20
\.


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('user_roles_id_seq', 20, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, username, password, email, cur_login_time, cur_login_ip, cur_login_area, last_login_ip, last_login_area, last_login_time, reg_time, reg_ip, reg_area, status, login_times, owner_sites, parent_user_id, company_id, photo, user_type, issys) FROM stdin;
3	admin	$2y$10$xHMQKNYwEkhGwGIDM9rKo.lu2ZDUypqgv4oOi2DF2cTzH5n5sR2r.	chaegumi@qq.com	2018-10-16 04:15:28	127.0.0.1		127.0.0.1		2018-10-16 01:33:03	2013-09-18 17:33:48	::1		1	804	a:6:{i:0;s:2:\\"52\\";i:1;s:2:\\"53\\";i:2;s:2:\\"55\\";i:3;s:2:\\"56\\";i:4;s:2:\\"57\\";i:5;s:2:\\"58\\";}	0	0	\N	1	1
23219	hoy	$2y$10$T4xb/KLsMsrR.GcYeERvfuSw2Ms/Xs.qz3BtlJXwUPw5haZajpEGS	hoy@gmail.com	\N	\N	\N	\N	\N	\N	2018-10-15 23:38:56.45	\N	\N	1	\N	\N	\N	\N	\N	\N	\N
23215	lina	$2y$10$65oG7OW1eKlAeuLUsRnof.zMXJ1AA6ePN9e8VF25TY82a1g3vKqdG	linacordoba7@gmail.com	2018-10-14 01:30:42	127.0.0.1		\N	\N	\N	\N	\N	\N	1	1	\N	\N	\N	\N	\N	\N
23214	esteban	$2y$10$TNexZ8Lf26KzDBilaXnaN.IzVmr8dZnV7wn6w2DFI6Z2y24.3aLOi	esteban.salgado.silva@gmail.com	2018-10-15 04:21:56	127.0.0.1		127.0.0.1		2018-10-15 02:51:15	2018-10-09 19:46:54			1	9	\N	0	0	\N	0	0
23218	ghdfh	$2y$10$CFe.jnxkGzwpq3BcTpICU.Z7X3yivAdjhAk/CxyqzcIBW0hLZzVJK	dfhgdf@gmail.com	\N	\N	\N	\N	\N	\N	2018-10-14 23:26:07.105	\N	\N	1	\N	\N	\N	\N	\N	\N	\N
23216	isabell	$2y$10$BLhy3bTtixew9dKodNVs6OPRWrYjNRh11Cez4/XSB.v9NdSzPd05y	isabell@gmail.com	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	\N	\N
23217	prueba	$2y$10$8/SJRkV.nxTnt/8lQKB2FOZj.fECGdgGJdhvXwTER02wRXSEtvQRq	prueeeba@gmail.com	2018-10-15 16:17:20	127.0.0.1		127.0.0.1		2018-10-15 05:15:50	2018-10-14 22:51:43.871	\N	\N	1	3	\N	\N	\N	\N	\N	\N
\.


--
-- Name: users_a_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_a_seq', 23219, true);


--
-- Name: permissions_permkey_parent_id_lft_rgt_root_id_issys_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_permkey_parent_id_lft_rgt_root_id_issys_key UNIQUE (permkey, parent_id, lft, rgt, root_id, issys);


--
-- Name: permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: role_perms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role_perms
    ADD CONSTRAINT role_perms_pkey PRIMARY KEY (id);


--
-- Name: role_perms_roleid_permid_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY role_perms
    ADD CONSTRAINT role_perms_roleid_permid_key UNIQUE (roleid, permid);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id, issys, rolename);


--
-- Name: user_perms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_perms
    ADD CONSTRAINT user_perms_pkey PRIMARY KEY (id);


--
-- Name: user_perms_userid_permid_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_perms
    ADD CONSTRAINT user_perms_userid_permid_key UNIQUE (userid, permid);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles_userid_roleid_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_userid_roleid_key UNIQUE (userid, roleid);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

