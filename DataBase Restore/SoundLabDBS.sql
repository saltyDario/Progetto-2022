PGDMP                          z            SoundLab    14.0    14.0 [    `           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            a           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            b           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            c           1262    41737    SoundLab    DATABASE     f   CREATE DATABASE "SoundLab" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';
    DROP DATABASE "SoundLab";
                postgres    false            �            1255    41738    inc_collab()    FUNCTION     �   CREATE FUNCTION public.inc_collab() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE traccia SET num_artisti = num_artisti + 1
	WHERE NEW.id_traccia = traccia.id_traccia;
    RETURN NEW;
END;
$$;
 #   DROP FUNCTION public.inc_collab();
       public          postgres    false            �            1255    41739    incrementa_libreria()    FUNCTION     �  CREATE FUNCTION public.incrementa_libreria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   CASE TG_OP
   WHEN 'INSERT' THEN            -- single quotes
      UPDATE libreria AS l
      SET    num_playlist = l.num_playlist + 1
      WHERE  l.id_libreria = NEW.id_libappartenenza;  -- fixed
   WHEN 'DELETE' THEN
      UPDATE libreria AS l
      SET    num_playlist = l.num_playlist - 1 
      WHERE  l.id_libreria = OLD.id_libappartenenza
      AND    l.num_playlist > 0;
   ELSE
      RAISE EXCEPTION 'Unexpected TG_OP: "%". Should not occur!', TG_OP;
   END CASE;
   
   RETURN NULL;      -- for AFTER trigger this can be NULL
END
$$;
 ,   DROP FUNCTION public.incrementa_libreria();
       public          postgres    false            �            1255    41740    incrementa_playlist()    FUNCTION     u  CREATE FUNCTION public.incrementa_playlist() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   CASE TG_OP
   WHEN 'INSERT' THEN            -- single quotes
      UPDATE playlist AS p
      SET    numerotracce = p.numerotracce + 1
      WHERE  p.id_playlist = NEW.id_playlist;  -- fixed
   WHEN 'DELETE' THEN
      UPDATE playlist AS p
      SET    numerotracce = p.numerotracce - 1 
      WHERE  p.id_playlist = OLD.id_playlist
      AND    p.numerotracce > 0;
   ELSE
      RAISE EXCEPTION 'Unexpected TG_OP: "%". Should not occur!', TG_OP;
   END CASE;

   RETURN NULL;      -- for AFTER trigger this can be NULL
END
$$;
 ,   DROP FUNCTION public.incrementa_playlist();
       public          postgres    false            �            1255    41741    insert_lib()    FUNCTION     �   CREATE FUNCTION public.insert_lib() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO libreria (id_libreria, num_playlist)
        VALUES (NEW.id_utente, 0);
    RETURN NEW;
END;
$$;
 #   DROP FUNCTION public.insert_lib();
       public          postgres    false            �            1259    41742    playlist    TABLE     �  CREATE TABLE public.playlist (
    id_playlist integer NOT NULL,
    id_libappartenenza integer NOT NULL,
    nome character varying(20) NOT NULL,
    numerotracce integer DEFAULT 0 NOT NULL,
    genere character varying(20),
    preferita character varying(6) DEFAULT false NOT NULL,
    CONSTRAINT tipo_pref CHECK ((((preferita)::text = 'true'::text) OR ((preferita)::text = 'false'::text)))
);
    DROP TABLE public.playlist;
       public         heap    postgres    false            �            1259    41748    Playlist_id_playlist_seq    SEQUENCE     �   CREATE SEQUENCE public."Playlist_id_playlist_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."Playlist_id_playlist_seq";
       public          postgres    false    209            d           0    0    Playlist_id_playlist_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."Playlist_id_playlist_seq" OWNED BY public.playlist.id_playlist;
          public          postgres    false    210            �            1259    41749    Playlist_numerotracce_seq    SEQUENCE     �   CREATE SEQUENCE public."Playlist_numerotracce_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."Playlist_numerotracce_seq";
       public          postgres    false    209            e           0    0    Playlist_numerotracce_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."Playlist_numerotracce_seq" OWNED BY public.playlist.numerotracce;
          public          postgres    false    211            �            1259    41750    traccia    TABLE     �  CREATE TABLE public.traccia (
    id_traccia integer NOT NULL,
    nometraccia character varying(50) NOT NULL,
    anno integer NOT NULL,
    genere character varying(20) NOT NULL,
    tipo_can character varying(20) NOT NULL,
    id_album integer,
    num_artisti integer DEFAULT 0,
    CONSTRAINT tipo_traccia CHECK ((((tipo_can)::text = 'Original'::text) OR ((tipo_can)::text = 'Cover'::text) OR ((tipo_can)::text = 'Remaster'::text)))
);
    DROP TABLE public.traccia;
       public         heap    postgres    false            �            1259    41755    Traccia_id_traccia_seq    SEQUENCE     �   CREATE SEQUENCE public."Traccia_id_traccia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."Traccia_id_traccia_seq";
       public          postgres    false    212            f           0    0    Traccia_id_traccia_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."Traccia_id_traccia_seq" OWNED BY public.traccia.id_traccia;
          public          postgres    false    213            �            1259    41756    aggiungi    TABLE     d   CREATE TABLE public.aggiungi (
    id_playlist integer NOT NULL,
    id_traccia integer NOT NULL
);
    DROP TABLE public.aggiungi;
       public         heap    postgres    false            �            1259    41759    aggiungi_id_playlist_seq    SEQUENCE     �   CREATE SEQUENCE public.aggiungi_id_playlist_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.aggiungi_id_playlist_seq;
       public          postgres    false    214            g           0    0    aggiungi_id_playlist_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.aggiungi_id_playlist_seq OWNED BY public.aggiungi.id_playlist;
          public          postgres    false    215            �            1259    41760    aggiungi_id_traccia_seq    SEQUENCE     �   CREATE SEQUENCE public.aggiungi_id_traccia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.aggiungi_id_traccia_seq;
       public          postgres    false    214            h           0    0    aggiungi_id_traccia_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.aggiungi_id_traccia_seq OWNED BY public.aggiungi.id_traccia;
          public          postgres    false    216            �            1259    41761    album    TABLE     �   CREATE TABLE public.album (
    nomealbum character varying(30),
    id_album integer NOT NULL,
    id_artista integer NOT NULL,
    anno integer
);
    DROP TABLE public.album;
       public         heap    postgres    false            �            1259    41764    album_id_album_seq    SEQUENCE     �   CREATE SEQUENCE public.album_id_album_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.album_id_album_seq;
       public          postgres    false    217            i           0    0    album_id_album_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.album_id_album_seq OWNED BY public.album.id_album;
          public          postgres    false    218            �            1259    41765    artista    TABLE     �   CREATE TABLE public.artista (
    id_artista integer NOT NULL,
    nome character varying(25) NOT NULL,
    datanascita date,
    "nazionalità" character varying(25) NOT NULL
);
    DROP TABLE public.artista;
       public         heap    postgres    false            �            1259    41768    artista_id_artista_seq    SEQUENCE     �   CREATE SEQUENCE public.artista_id_artista_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.artista_id_artista_seq;
       public          postgres    false    219            j           0    0    artista_id_artista_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.artista_id_artista_seq OWNED BY public.artista.id_artista;
          public          postgres    false    220            �            1259    41769    ascolto    TABLE     �  CREATE TABLE public.ascolto (
    id_utente integer NOT NULL,
    id_traccia integer NOT NULL,
    fasciaoraria character varying(20) NOT NULL,
    data timestamp without time zone NOT NULL,
    CONSTRAINT tipo_orario CHECK ((((fasciaoraria)::text = 'Mattina'::text) OR ((fasciaoraria)::text = 'Pomeriggio'::text) OR ((fasciaoraria)::text = 'Sera'::text) OR ((fasciaoraria)::text = 'Notte'::text)))
);
    DROP TABLE public.ascolto;
       public         heap    postgres    false            �            1259    41773    ascolto_id_traccia_seq    SEQUENCE     �   CREATE SEQUENCE public.ascolto_id_traccia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.ascolto_id_traccia_seq;
       public          postgres    false    221            k           0    0    ascolto_id_traccia_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.ascolto_id_traccia_seq OWNED BY public.ascolto.id_traccia;
          public          postgres    false    222            �            1259    41774    ascolto_id_utente_seq    SEQUENCE     �   CREATE SEQUENCE public.ascolto_id_utente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.ascolto_id_utente_seq;
       public          postgres    false    221            l           0    0    ascolto_id_utente_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.ascolto_id_utente_seq OWNED BY public.ascolto.id_utente;
          public          postgres    false    223            �            1259    41775    collab    TABLE     a   CREATE TABLE public.collab (
    id_artista integer NOT NULL,
    id_traccia integer NOT NULL
);
    DROP TABLE public.collab;
       public         heap    postgres    false            �            1259    41778    libreria    TABLE     ]   CREATE TABLE public.libreria (
    id_libreria integer NOT NULL,
    num_playlist integer
);
    DROP TABLE public.libreria;
       public         heap    postgres    false            �            1259    41781    playlist_id_playlist_seq    SEQUENCE     �   ALTER TABLE public.playlist ALTER COLUMN id_playlist ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.playlist_id_playlist_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    209            �            1259    41782    utente    TABLE     C  CREATE TABLE public.utente (
    username character varying(20) NOT NULL,
    password character varying(20) NOT NULL,
    id_utente integer NOT NULL,
    email character varying(30) NOT NULL,
    datanascita date NOT NULL,
    sesso character varying(20),
    tipo_ut character varying(10) DEFAULT 'Cliente'::character varying,
    CONSTRAINT tipo_pers CHECK ((((sesso)::text = 'Uomo'::text) OR ((sesso)::text = 'Donna'::text) OR ((sesso)::text = 'Altro'::text))),
    CONSTRAINT tipo_utente CHECK ((((tipo_ut)::text = 'Cliente'::text) OR ((tipo_ut)::text = 'Admin'::text)))
);
    DROP TABLE public.utente;
       public         heap    postgres    false            �            1259    41788    utente_id_utente_seq    SEQUENCE     �   CREATE SEQUENCE public.utente_id_utente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.utente_id_utente_seq;
       public          postgres    false    227            m           0    0    utente_id_utente_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.utente_id_utente_seq OWNED BY public.utente.id_utente;
          public          postgres    false    228            �           2604    41789    aggiungi id_playlist    DEFAULT     |   ALTER TABLE ONLY public.aggiungi ALTER COLUMN id_playlist SET DEFAULT nextval('public.aggiungi_id_playlist_seq'::regclass);
 C   ALTER TABLE public.aggiungi ALTER COLUMN id_playlist DROP DEFAULT;
       public          postgres    false    215    214            �           2604    41790    aggiungi id_traccia    DEFAULT     z   ALTER TABLE ONLY public.aggiungi ALTER COLUMN id_traccia SET DEFAULT nextval('public.aggiungi_id_traccia_seq'::regclass);
 B   ALTER TABLE public.aggiungi ALTER COLUMN id_traccia DROP DEFAULT;
       public          postgres    false    216    214            �           2604    41791    album id_album    DEFAULT     p   ALTER TABLE ONLY public.album ALTER COLUMN id_album SET DEFAULT nextval('public.album_id_album_seq'::regclass);
 =   ALTER TABLE public.album ALTER COLUMN id_album DROP DEFAULT;
       public          postgres    false    218    217            �           2604    41792    artista id_artista    DEFAULT     x   ALTER TABLE ONLY public.artista ALTER COLUMN id_artista SET DEFAULT nextval('public.artista_id_artista_seq'::regclass);
 A   ALTER TABLE public.artista ALTER COLUMN id_artista DROP DEFAULT;
       public          postgres    false    220    219            �           2604    41793    ascolto id_utente    DEFAULT     v   ALTER TABLE ONLY public.ascolto ALTER COLUMN id_utente SET DEFAULT nextval('public.ascolto_id_utente_seq'::regclass);
 @   ALTER TABLE public.ascolto ALTER COLUMN id_utente DROP DEFAULT;
       public          postgres    false    223    221            �           2604    41794    ascolto id_traccia    DEFAULT     x   ALTER TABLE ONLY public.ascolto ALTER COLUMN id_traccia SET DEFAULT nextval('public.ascolto_id_traccia_seq'::regclass);
 A   ALTER TABLE public.ascolto ALTER COLUMN id_traccia DROP DEFAULT;
       public          postgres    false    222    221            �           2604    41795    traccia id_traccia    DEFAULT     z   ALTER TABLE ONLY public.traccia ALTER COLUMN id_traccia SET DEFAULT nextval('public."Traccia_id_traccia_seq"'::regclass);
 A   ALTER TABLE public.traccia ALTER COLUMN id_traccia DROP DEFAULT;
       public          postgres    false    213    212            �           2604    41796    utente id_utente    DEFAULT     t   ALTER TABLE ONLY public.utente ALTER COLUMN id_utente SET DEFAULT nextval('public.utente_id_utente_seq'::regclass);
 ?   ALTER TABLE public.utente ALTER COLUMN id_utente DROP DEFAULT;
       public          postgres    false    228    227            O          0    41756    aggiungi 
   TABLE DATA           ;   COPY public.aggiungi (id_playlist, id_traccia) FROM stdin;
    public          postgres    false    214   +q       R          0    41761    album 
   TABLE DATA           F   COPY public.album (nomealbum, id_album, id_artista, anno) FROM stdin;
    public          postgres    false    217   Lq       T          0    41765    artista 
   TABLE DATA           P   COPY public.artista (id_artista, nome, datanascita, "nazionalità") FROM stdin;
    public          postgres    false    219   �u       V          0    41769    ascolto 
   TABLE DATA           L   COPY public.ascolto (id_utente, id_traccia, fasciaoraria, data) FROM stdin;
    public          postgres    false    221   {y       Y          0    41775    collab 
   TABLE DATA           8   COPY public.collab (id_artista, id_traccia) FROM stdin;
    public          postgres    false    224   �z       Z          0    41778    libreria 
   TABLE DATA           =   COPY public.libreria (id_libreria, num_playlist) FROM stdin;
    public          postgres    false    225   �{       J          0    41742    playlist 
   TABLE DATA           j   COPY public.playlist (id_playlist, id_libappartenenza, nome, numerotracce, genere, preferita) FROM stdin;
    public          postgres    false    209   �{       M          0    41750    traccia 
   TABLE DATA           i   COPY public.traccia (id_traccia, nometraccia, anno, genere, tipo_can, id_album, num_artisti) FROM stdin;
    public          postgres    false    212   :|       \          0    41782    utente 
   TABLE DATA           c   COPY public.utente (username, password, id_utente, email, datanascita, sesso, tipo_ut) FROM stdin;
    public          postgres    false    227   Ӏ       n           0    0    Playlist_id_playlist_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."Playlist_id_playlist_seq"', 28, true);
          public          postgres    false    210            o           0    0    Playlist_numerotracce_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."Playlist_numerotracce_seq"', 1, false);
          public          postgres    false    211            p           0    0    Traccia_id_traccia_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."Traccia_id_traccia_seq"', 89, true);
          public          postgres    false    213            q           0    0    aggiungi_id_playlist_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.aggiungi_id_playlist_seq', 1, false);
          public          postgres    false    215            r           0    0    aggiungi_id_traccia_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.aggiungi_id_traccia_seq', 1, false);
          public          postgres    false    216            s           0    0    album_id_album_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.album_id_album_seq', 79, true);
          public          postgres    false    218            t           0    0    artista_id_artista_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.artista_id_artista_seq', 56, true);
          public          postgres    false    220            u           0    0    ascolto_id_traccia_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.ascolto_id_traccia_seq', 1, false);
          public          postgres    false    222            v           0    0    ascolto_id_utente_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ascolto_id_utente_seq', 1, false);
          public          postgres    false    223            w           0    0    playlist_id_playlist_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.playlist_id_playlist_seq', 7, true);
          public          postgres    false    226            x           0    0    utente_id_utente_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.utente_id_utente_seq', 4, true);
          public          postgres    false    228            �           2606    41798    aggiungi aggiungi_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.aggiungi
    ADD CONSTRAINT aggiungi_pkey PRIMARY KEY (id_playlist, id_traccia);
 @   ALTER TABLE ONLY public.aggiungi DROP CONSTRAINT aggiungi_pkey;
       public            postgres    false    214    214            �           2606    41800    album album_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pk PRIMARY KEY (id_album);
 8   ALTER TABLE ONLY public.album DROP CONSTRAINT album_pk;
       public            postgres    false    217            �           2606    41802    artista artista_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.artista
    ADD CONSTRAINT artista_pkey PRIMARY KEY (id_artista);
 >   ALTER TABLE ONLY public.artista DROP CONSTRAINT artista_pkey;
       public            postgres    false    219            �           2606    41804    ascolto ascolto_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.ascolto
    ADD CONSTRAINT ascolto_pk PRIMARY KEY (data, fasciaoraria);
 <   ALTER TABLE ONLY public.ascolto DROP CONSTRAINT ascolto_pk;
       public            postgres    false    221    221            �           2606    41806    collab collab_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_pk PRIMARY KEY (id_artista, id_traccia);
 :   ALTER TABLE ONLY public.collab DROP CONSTRAINT collab_pk;
       public            postgres    false    224    224            �           2606    41808    utente email_unique 
   CONSTRAINT     O   ALTER TABLE ONLY public.utente
    ADD CONSTRAINT email_unique UNIQUE (email);
 =   ALTER TABLE ONLY public.utente DROP CONSTRAINT email_unique;
       public            postgres    false    227            �           2606    41810    libreria id_libreria_unique 
   CONSTRAINT     b   ALTER TABLE ONLY public.libreria
    ADD CONSTRAINT id_libreria_unique PRIMARY KEY (id_libreria);
 E   ALTER TABLE ONLY public.libreria DROP CONSTRAINT id_libreria_unique;
       public            postgres    false    225            �           2606    41812    utente id_utente_unique 
   CONSTRAINT     W   ALTER TABLE ONLY public.utente
    ADD CONSTRAINT id_utente_unique UNIQUE (id_utente);
 A   ALTER TABLE ONLY public.utente DROP CONSTRAINT id_utente_unique;
       public            postgres    false    227            �           2606    41814    playlist playlist_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_pkey PRIMARY KEY (id_playlist);
 @   ALTER TABLE ONLY public.playlist DROP CONSTRAINT playlist_pkey;
       public            postgres    false    209            �           2606    41816    traccia traccia_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.traccia
    ADD CONSTRAINT traccia_pkey PRIMARY KEY (id_traccia);
 >   ALTER TABLE ONLY public.traccia DROP CONSTRAINT traccia_pkey;
       public            postgres    false    212            �           2606    41818    utente utente_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.utente
    ADD CONSTRAINT utente_pkey PRIMARY KEY (username);
 <   ALTER TABLE ONLY public.utente DROP CONSTRAINT utente_pkey;
       public            postgres    false    227            �           2620    41819    collab inc_artisti    TRIGGER     l   CREATE TRIGGER inc_artisti AFTER INSERT ON public.collab FOR EACH ROW EXECUTE FUNCTION public.inc_collab();
 +   DROP TRIGGER inc_artisti ON public.collab;
       public          postgres    false    229    224            �           2620    41820    playlist inc_lib    TRIGGER     }   CREATE TRIGGER inc_lib AFTER INSERT OR DELETE ON public.playlist FOR EACH ROW EXECUTE FUNCTION public.incrementa_libreria();
 )   DROP TRIGGER inc_lib ON public.playlist;
       public          postgres    false    230    209            �           2620    41821    aggiungi inc_plst    TRIGGER     ~   CREATE TRIGGER inc_plst AFTER INSERT OR DELETE ON public.aggiungi FOR EACH ROW EXECUTE FUNCTION public.incrementa_playlist();
 *   DROP TRIGGER inc_plst ON public.aggiungi;
       public          postgres    false    214    231            �           2620    41822    utente ins_lib    TRIGGER     h   CREATE TRIGGER ins_lib AFTER INSERT ON public.utente FOR EACH ROW EXECUTE FUNCTION public.insert_lib();
 '   DROP TRIGGER ins_lib ON public.utente;
       public          postgres    false    232    227            �           2606    41823    aggiungi aggiugni_fkey1    FK CONSTRAINT     �   ALTER TABLE ONLY public.aggiungi
    ADD CONSTRAINT aggiugni_fkey1 FOREIGN KEY (id_playlist) REFERENCES public.playlist(id_playlist) ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.aggiungi DROP CONSTRAINT aggiugni_fkey1;
       public          postgres    false    3228    209    214            �           2606    41828    aggiungi aggiungi_fkey2    FK CONSTRAINT     �   ALTER TABLE ONLY public.aggiungi
    ADD CONSTRAINT aggiungi_fkey2 FOREIGN KEY (id_traccia) REFERENCES public.traccia(id_traccia) ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.aggiungi DROP CONSTRAINT aggiungi_fkey2;
       public          postgres    false    212    3230    214            �           2606    41833    album album_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_fk FOREIGN KEY (id_artista) REFERENCES public.artista(id_artista) ON DELETE CASCADE NOT VALID;
 8   ALTER TABLE ONLY public.album DROP CONSTRAINT album_fk;
       public          postgres    false    217    3236    219            �           2606    41838    ascolto ascolto_fkey1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.ascolto
    ADD CONSTRAINT ascolto_fkey1 FOREIGN KEY (id_utente) REFERENCES public.utente(id_utente);
 ?   ALTER TABLE ONLY public.ascolto DROP CONSTRAINT ascolto_fkey1;
       public          postgres    false    227    3246    221            �           2606    41843    ascolto ascolto_fkey2    FK CONSTRAINT     �   ALTER TABLE ONLY public.ascolto
    ADD CONSTRAINT ascolto_fkey2 FOREIGN KEY (id_traccia) REFERENCES public.traccia(id_traccia);
 ?   ALTER TABLE ONLY public.ascolto DROP CONSTRAINT ascolto_fkey2;
       public          postgres    false    3230    221    212            �           2606    41848    collab collab_fk1    FK CONSTRAINT     �   ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_fk1 FOREIGN KEY (id_artista) REFERENCES public.artista(id_artista) ON DELETE CASCADE NOT VALID;
 ;   ALTER TABLE ONLY public.collab DROP CONSTRAINT collab_fk1;
       public          postgres    false    219    3236    224            �           2606    41853    collab collab_fk2    FK CONSTRAINT     �   ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_fk2 FOREIGN KEY (id_traccia) REFERENCES public.traccia(id_traccia) ON DELETE CASCADE NOT VALID;
 ;   ALTER TABLE ONLY public.collab DROP CONSTRAINT collab_fk2;
       public          postgres    false    212    224    3230            �           2606    41858    libreria libreria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.libreria
    ADD CONSTRAINT libreria_fkey FOREIGN KEY (id_libreria) REFERENCES public.utente(id_utente) ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.libreria DROP CONSTRAINT libreria_fkey;
       public          postgres    false    3246    227    225            �           2606    41863    playlist playlist_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_fkey FOREIGN KEY (id_libappartenenza) REFERENCES public.libreria(id_libreria) ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.playlist DROP CONSTRAINT playlist_fkey;
       public          postgres    false    209    3242    225            �           2606    41868    traccia traccia_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.traccia
    ADD CONSTRAINT traccia_fk FOREIGN KEY (id_album) REFERENCES public.album(id_album) ON DELETE CASCADE NOT VALID;
 <   ALTER TABLE ONLY public.traccia DROP CONSTRAINT traccia_fk;
       public          postgres    false    3234    217    212            O      x�3�4����� }"      R   w  x�M�Kn#7���)���~?��-�q$�b9� ��[�D�"6�v�4������[3$�E�X��W���W�X�O�$8[���>(��i���{g%+X����|������{mY��mSD[��b{��Q�6�b��m˷�(���:�j���4�	���m+3r��K��(.�����Y%� .J�X�hS]����e�$K�7��gIn~��;��R���V��^�soN��N\H��`9�T?��x9"��gb-�T2�Z�
�ciŊz�m18��
A�h��H+�s��gi�r
1������YHR��^<yw�}U=�t��>}��/T�r�f��d��e���=�K�����3��O��2~PbaŲ�U�o���*G��Q�D�Hޖ_���l9cYE�}�/��;\�!+�,hk��휇ۆ��w��N�l����E�c�9�ʾ;��5��Z����m��Ok���4��DU��/K�Bvϔ�����y̠I�_��pp;�&n�g���X^P:$��`Io�Fq#�N�=�R�j�����B���˫3C9��9"�����z�7hXJ�PF�E/���'%��u��HX91�v�H�7�.�^y7�f�<V�-��|=���c8P�E��	��OB!��
/���ݱ�`g̮5|���x�C�e@��	�w�c���VT�~칇��Elu����I5}����:Jˊ�p�@.�����L~-� DJi����Q�{���Ω���ϲI�;p0]z�Q�ʜ��Z-_�A0(�d��\��A�' �܎P�V�Q贲�T�$�~�����ZƦEXǓQ�Z'��E㢚�x%��Nh��ē�E}��Ѱ�!ƠY�g��B>�⳥��xИ�eK�M�h���zPD[`Ua�޻S��8��U������ʱ*#�b�
b�	Ӌ�=�r�k�<��Ϊb2Ϲ�H;��8c;g%�Yں��! XUg{¿�dUMLN���@h�������ȋ#k�§^<H�,�n�U{ހ)k��>�:!�D�|�Gm4��S�1�Sm�Q�:#cZ��`uNhũ~�����Q�."Wm�c.HA+Oq$��<�`����c"�#ź��Q)�(2�7DCZ���{����u'V�ۢ1�������F#�6RD��=���)��      T   �  x�UTKr�8]ç�4#R?k��N&�$�jwOozٌ͊D�))�Ds��� �������Hx��Y��A��<��H���v1S�X��Z��'��e��b�k�A�(���)l��3V�]iOh����%Z��,�ox����K��e$U$�P#�}vv�߿��(.�8Ho�	q���nI���<����9�յ�!0SQL_��g%�Q�5��q>��i(,�!2�G�w�	.JK�	��qoh]�qv�ssj* e��ܚbP~�&p��7��T��-�HƑ��NaQ�z�KB�x3x6։Z3P�eL�,�������7=p��%^�]�ų���Pb��*��<;�����Y3��{HI!u��(�d_,]횊P�v]wΊ�;Z���	�P�G|5��EF}JU��tj���T�&X7���HY�b
�+��ql�H���&��U��8�!{����Y[.���h��h�:8�Ȃ�ɼ	l_�a��*l;������p�*�:ס|*�����6�1�/m�޼3�d8'�������2"�Co������~�{:�חK`5	�L�Hb��}ƾ5A�"�N�)�R��A=0��R�~���Y������� NnJh��k^���6�aB�{�Y}ۓY��!5d䢽�����r̹���8�?o�eR�F�������ˑŕЄlkj*�<��Րl�����ސ����֭�v�4cѷ'<X��1|5��3��.G���ĳ���s�T�CoZqKVlR�)��9�O����c��I�-9qG��	,u<k��L,i5�+M�I��05y�l�2o�‗Kp&�DC<�����Y����5˯�N�ښ�j��+���Ql��׍��X及t2���k=]�O6�ak�;��;F�b�Y��t*�1���ь��Դ^ܽ���� �e����l6��m�Y      V   D  x���Kn!���)z�X~b�*� �dQEY����_5�M+�O`�h���|�_���ZOH'���ְ��k�����5I����Uv�x�j)�#�� Z %P�ht�bc�b�FF&�B(���72�c���Upչ1u���س��F���9E0�ק�����[����g�m���(�L��1s��{lo�Ϗ���r��q�,�eТ<�8pv������2�j};�N*յ#t���s�	�� �>��|�^-�p����m�[��d�4�#hce=��fW�| �c��UP���p�% ����� �.�      Y   �   x�л�E1�X�c��^^�u,(�	<� *0Ʉ�"������{F�ᓘ%}����R=L<�N���A���֌�C��Uj��4龭3�td�vl��/�t�|;=�G�妈�
���%QJ�F-)��E[�C��U?���f��[P'�������m�zώ�a��ٮ�	�7��K�f�̱-o��?�|�>�      Z      x�3�4�2�4�2�4����� D      J   b   x�3�4��+�/K�4�J,�LK�)N�2����298�a�f@��ʜ�������Ң�D�����l�s���ԴԢ̒T�gIQi*W� �      M   �  x��V�r�6<����R")��)%��W�*ɻ�T��""P�^�kr�����t�-*�Jj�3��=ȇt/WҮ���������FV�):�4��KqRɵ�N��Z���V<���"����tb�UCq�S��Xk\��bDL�����g'C�✎�YX���4U��T[5d�өl��T�ښ��Wk嶀 �=�ډ�Fj#N��ŋ��+�P�F���ԶQ����/��#���V\��^X���gr@�.mWL����2Q��C�����D�4�3[m=5����H�o���[�8�׀yo0�Xň��sY�@J3/��X)�)����2��m,k��v-f��Kq2Q��^�Lԋ���CV��TN|q)]U��1�֫F�b��nCJ��hkj]ȧJ��z�W����b8d!���f��u~[��?�uc{ #�&��۞�%)�Gi�KP)K;}q5iDw�	��1&V�iz	]ZQH�j[��B��tH�z���}#7����6�X:�O�A�sR6NU�z�)��3ڕ����Jx ���BX*�Z�����Ɏ�}��:��1]K1/�\�q7d�l���%�^)�r(f�ҍ��ĲYD͙p���: ��F�R̤.�:Y#P�X�lHȢUk��p����C�m�	<�|-C�B���A�<��4Z� 2�q�X�R��g��E��N!<AYN_���C�����+ac�Z�':�}�Lx�F^�H���(�Fѹn*'Α�r�˺ӧ
ݼ�p+�[��MD�28���܆N>&׎ �yܔ s��߬d����yF3[+k�n�O�cYU��-8/�<��Rzl!F"1����#��k���P��6ͦE�_w8N���]�HbYlڭ���фl���
buDgR�6��f����C��l��/���}�4<�V�J��@�����K@+qB����,;(�V�u�kY�}	v� 󈙻���@#��o�a/~��#�G��
��"�׋K�j���M�"���3yϙ!=ʥ��jv��^����e䓶N��tǝ	�5S(統�U��9%\{��]v�P�����-d���Pa����G�5�TrsUyy�����-��W�hea2��j] ,����z�	y`K�*����С1��9�9��I�����GGG� h�,�      \   t   x�U�1
�0뽿Ȝ�	V�7�KsH"9��@(�����iv��U`Ҿ9+F�-o]�솘f<��ts<V�[�t/���xr�x��R�x>��OE�:̛�	�Z���4�����1�     