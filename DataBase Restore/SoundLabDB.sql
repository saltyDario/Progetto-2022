PGDMP                          z            SoundLab    14.0    14.0 [    `           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            a           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            b           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            c           1262    42009    SoundLab    DATABASE     f   CREATE DATABASE "SoundLab" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';
    DROP DATABASE "SoundLab";
                postgres    false            �            1255    42010    inc_collab()    FUNCTION     �   CREATE FUNCTION public.inc_collab() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE traccia SET num_artisti = num_artisti + 1
	WHERE NEW.id_traccia = traccia.id_traccia;
    RETURN NEW;
END;
$$;
 #   DROP FUNCTION public.inc_collab();
       public          postgres    false            �            1255    42011    incrementa_libreria()    FUNCTION     �  CREATE FUNCTION public.incrementa_libreria() RETURNS trigger
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
       public          postgres    false            �            1255    42012    incrementa_playlist()    FUNCTION     u  CREATE FUNCTION public.incrementa_playlist() RETURNS trigger
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
       public          postgres    false            �            1255    42013    insert_lib()    FUNCTION     �   CREATE FUNCTION public.insert_lib() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO libreria (id_libreria, num_playlist)
        VALUES (NEW.id_utente, 0);
    RETURN NEW;
END;
$$;
 #   DROP FUNCTION public.insert_lib();
       public          postgres    false            �            1259    42014    playlist    TABLE     �  CREATE TABLE public.playlist (
    id_playlist integer NOT NULL,
    id_libappartenenza integer NOT NULL,
    nome character varying(20) NOT NULL,
    numerotracce integer DEFAULT 0 NOT NULL,
    genere character varying(20),
    preferita character varying(6) DEFAULT false NOT NULL,
    CONSTRAINT tipo_pref CHECK ((((preferita)::text = 'true'::text) OR ((preferita)::text = 'false'::text)))
);
    DROP TABLE public.playlist;
       public         heap    postgres    false            �            1259    42020    Playlist_id_playlist_seq    SEQUENCE     �   CREATE SEQUENCE public."Playlist_id_playlist_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public."Playlist_id_playlist_seq";
       public          postgres    false    209            d           0    0    Playlist_id_playlist_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public."Playlist_id_playlist_seq" OWNED BY public.playlist.id_playlist;
          public          postgres    false    210            �            1259    42021    Playlist_numerotracce_seq    SEQUENCE     �   CREATE SEQUENCE public."Playlist_numerotracce_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public."Playlist_numerotracce_seq";
       public          postgres    false    209            e           0    0    Playlist_numerotracce_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public."Playlist_numerotracce_seq" OWNED BY public.playlist.numerotracce;
          public          postgres    false    211            �            1259    42022    traccia    TABLE     �  CREATE TABLE public.traccia (
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
       public         heap    postgres    false            �            1259    42027    Traccia_id_traccia_seq    SEQUENCE     �   CREATE SEQUENCE public."Traccia_id_traccia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public."Traccia_id_traccia_seq";
       public          postgres    false    212            f           0    0    Traccia_id_traccia_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."Traccia_id_traccia_seq" OWNED BY public.traccia.id_traccia;
          public          postgres    false    213            �            1259    42028    aggiungi    TABLE     d   CREATE TABLE public.aggiungi (
    id_playlist integer NOT NULL,
    id_traccia integer NOT NULL
);
    DROP TABLE public.aggiungi;
       public         heap    postgres    false            �            1259    42031    aggiungi_id_playlist_seq    SEQUENCE     �   CREATE SEQUENCE public.aggiungi_id_playlist_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.aggiungi_id_playlist_seq;
       public          postgres    false    214            g           0    0    aggiungi_id_playlist_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.aggiungi_id_playlist_seq OWNED BY public.aggiungi.id_playlist;
          public          postgres    false    215            �            1259    42032    aggiungi_id_traccia_seq    SEQUENCE     �   CREATE SEQUENCE public.aggiungi_id_traccia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.aggiungi_id_traccia_seq;
       public          postgres    false    214            h           0    0    aggiungi_id_traccia_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.aggiungi_id_traccia_seq OWNED BY public.aggiungi.id_traccia;
          public          postgres    false    216            �            1259    42033    album    TABLE     �   CREATE TABLE public.album (
    nomealbum character varying(30),
    id_album integer NOT NULL,
    id_artista integer NOT NULL,
    anno integer
);
    DROP TABLE public.album;
       public         heap    postgres    false            �            1259    42036    album_id_album_seq    SEQUENCE     �   CREATE SEQUENCE public.album_id_album_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.album_id_album_seq;
       public          postgres    false    217            i           0    0    album_id_album_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.album_id_album_seq OWNED BY public.album.id_album;
          public          postgres    false    218            �            1259    42037    artista    TABLE     �   CREATE TABLE public.artista (
    id_artista integer NOT NULL,
    nome character varying(25) NOT NULL,
    datanascita date,
    nazionalita character varying(25) NOT NULL
);
    DROP TABLE public.artista;
       public         heap    postgres    false            �            1259    42040    artista_id_artista_seq    SEQUENCE     �   CREATE SEQUENCE public.artista_id_artista_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.artista_id_artista_seq;
       public          postgres    false    219            j           0    0    artista_id_artista_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.artista_id_artista_seq OWNED BY public.artista.id_artista;
          public          postgres    false    220            �            1259    42041    ascolto    TABLE     �  CREATE TABLE public.ascolto (
    id_utente integer NOT NULL,
    id_traccia integer NOT NULL,
    fasciaoraria character varying(20) NOT NULL,
    data timestamp without time zone NOT NULL,
    CONSTRAINT tipo_orario CHECK ((((fasciaoraria)::text = 'Mattina'::text) OR ((fasciaoraria)::text = 'Pomeriggio'::text) OR ((fasciaoraria)::text = 'Sera'::text) OR ((fasciaoraria)::text = 'Notte'::text)))
);
    DROP TABLE public.ascolto;
       public         heap    postgres    false            �            1259    42045    ascolto_id_traccia_seq    SEQUENCE     �   CREATE SEQUENCE public.ascolto_id_traccia_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.ascolto_id_traccia_seq;
       public          postgres    false    221            k           0    0    ascolto_id_traccia_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.ascolto_id_traccia_seq OWNED BY public.ascolto.id_traccia;
          public          postgres    false    222            �            1259    42046    ascolto_id_utente_seq    SEQUENCE     �   CREATE SEQUENCE public.ascolto_id_utente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.ascolto_id_utente_seq;
       public          postgres    false    221            l           0    0    ascolto_id_utente_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.ascolto_id_utente_seq OWNED BY public.ascolto.id_utente;
          public          postgres    false    223            �            1259    42047    collab    TABLE     a   CREATE TABLE public.collab (
    id_artista integer NOT NULL,
    id_traccia integer NOT NULL
);
    DROP TABLE public.collab;
       public         heap    postgres    false            �            1259    42050    libreria    TABLE     ]   CREATE TABLE public.libreria (
    id_libreria integer NOT NULL,
    num_playlist integer
);
    DROP TABLE public.libreria;
       public         heap    postgres    false            �            1259    42053    playlist_id_playlist_seq    SEQUENCE     �   ALTER TABLE public.playlist ALTER COLUMN id_playlist ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.playlist_id_playlist_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    209            �            1259    42054    utente    TABLE     C  CREATE TABLE public.utente (
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
       public         heap    postgres    false            �            1259    42060    utente_id_utente_seq    SEQUENCE     �   CREATE SEQUENCE public.utente_id_utente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.utente_id_utente_seq;
       public          postgres    false    227            m           0    0    utente_id_utente_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.utente_id_utente_seq OWNED BY public.utente.id_utente;
          public          postgres    false    228            �           2604    42061    aggiungi id_playlist    DEFAULT     |   ALTER TABLE ONLY public.aggiungi ALTER COLUMN id_playlist SET DEFAULT nextval('public.aggiungi_id_playlist_seq'::regclass);
 C   ALTER TABLE public.aggiungi ALTER COLUMN id_playlist DROP DEFAULT;
       public          postgres    false    215    214            �           2604    42062    aggiungi id_traccia    DEFAULT     z   ALTER TABLE ONLY public.aggiungi ALTER COLUMN id_traccia SET DEFAULT nextval('public.aggiungi_id_traccia_seq'::regclass);
 B   ALTER TABLE public.aggiungi ALTER COLUMN id_traccia DROP DEFAULT;
       public          postgres    false    216    214            �           2604    42063    album id_album    DEFAULT     p   ALTER TABLE ONLY public.album ALTER COLUMN id_album SET DEFAULT nextval('public.album_id_album_seq'::regclass);
 =   ALTER TABLE public.album ALTER COLUMN id_album DROP DEFAULT;
       public          postgres    false    218    217            �           2604    42064    artista id_artista    DEFAULT     x   ALTER TABLE ONLY public.artista ALTER COLUMN id_artista SET DEFAULT nextval('public.artista_id_artista_seq'::regclass);
 A   ALTER TABLE public.artista ALTER COLUMN id_artista DROP DEFAULT;
       public          postgres    false    220    219            �           2604    42065    ascolto id_utente    DEFAULT     v   ALTER TABLE ONLY public.ascolto ALTER COLUMN id_utente SET DEFAULT nextval('public.ascolto_id_utente_seq'::regclass);
 @   ALTER TABLE public.ascolto ALTER COLUMN id_utente DROP DEFAULT;
       public          postgres    false    223    221            �           2604    42066    ascolto id_traccia    DEFAULT     x   ALTER TABLE ONLY public.ascolto ALTER COLUMN id_traccia SET DEFAULT nextval('public.ascolto_id_traccia_seq'::regclass);
 A   ALTER TABLE public.ascolto ALTER COLUMN id_traccia DROP DEFAULT;
       public          postgres    false    222    221            �           2604    42067    traccia id_traccia    DEFAULT     z   ALTER TABLE ONLY public.traccia ALTER COLUMN id_traccia SET DEFAULT nextval('public."Traccia_id_traccia_seq"'::regclass);
 A   ALTER TABLE public.traccia ALTER COLUMN id_traccia DROP DEFAULT;
       public          postgres    false    213    212            �           2604    42068    utente id_utente    DEFAULT     t   ALTER TABLE ONLY public.utente ALTER COLUMN id_utente SET DEFAULT nextval('public.utente_id_utente_seq'::regclass);
 ?   ALTER TABLE public.utente ALTER COLUMN id_utente DROP DEFAULT;
       public          postgres    false    228    227            O          0    42028    aggiungi 
   TABLE DATA           ;   COPY public.aggiungi (id_playlist, id_traccia) FROM stdin;
    public          postgres    false    214   (q       R          0    42033    album 
   TABLE DATA           F   COPY public.album (nomealbum, id_album, id_artista, anno) FROM stdin;
    public          postgres    false    217   �q       T          0    42037    artista 
   TABLE DATA           M   COPY public.artista (id_artista, nome, datanascita, nazionalita) FROM stdin;
    public          postgres    false    219   iv       V          0    42041    ascolto 
   TABLE DATA           L   COPY public.ascolto (id_utente, id_traccia, fasciaoraria, data) FROM stdin;
    public          postgres    false    221   hz       Y          0    42047    collab 
   TABLE DATA           8   COPY public.collab (id_artista, id_traccia) FROM stdin;
    public          postgres    false    224   8�       Z          0    42050    libreria 
   TABLE DATA           =   COPY public.libreria (id_libreria, num_playlist) FROM stdin;
    public          postgres    false    225   s�       J          0    42014    playlist 
   TABLE DATA           j   COPY public.playlist (id_playlist, id_libappartenenza, nome, numerotracce, genere, preferita) FROM stdin;
    public          postgres    false    209   ā       M          0    42022    traccia 
   TABLE DATA           i   COPY public.traccia (id_traccia, nometraccia, anno, genere, tipo_can, id_album, num_artisti) FROM stdin;
    public          postgres    false    212   ��       \          0    42054    utente 
   TABLE DATA           c   COPY public.utente (username, password, id_utente, email, datanascita, sesso, tipo_ut) FROM stdin;
    public          postgres    false    227   ��       n           0    0    Playlist_id_playlist_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."Playlist_id_playlist_seq"', 28, true);
          public          postgres    false    210            o           0    0    Playlist_numerotracce_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."Playlist_numerotracce_seq"', 1, false);
          public          postgres    false    211            p           0    0    Traccia_id_traccia_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."Traccia_id_traccia_seq"', 125, true);
          public          postgres    false    213            q           0    0    aggiungi_id_playlist_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.aggiungi_id_playlist_seq', 1, false);
          public          postgres    false    215            r           0    0    aggiungi_id_traccia_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.aggiungi_id_traccia_seq', 1, false);
          public          postgres    false    216            s           0    0    album_id_album_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.album_id_album_seq', 84, true);
          public          postgres    false    218            t           0    0    artista_id_artista_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.artista_id_artista_seq', 62, true);
          public          postgres    false    220            u           0    0    ascolto_id_traccia_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.ascolto_id_traccia_seq', 1, false);
          public          postgres    false    222            v           0    0    ascolto_id_utente_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.ascolto_id_utente_seq', 1, false);
          public          postgres    false    223            w           0    0    playlist_id_playlist_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.playlist_id_playlist_seq', 27, true);
          public          postgres    false    226            x           0    0    utente_id_utente_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.utente_id_utente_seq', 21, true);
          public          postgres    false    228            �           2606    42070    aggiungi aggiungi_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.aggiungi
    ADD CONSTRAINT aggiungi_pkey PRIMARY KEY (id_playlist, id_traccia);
 @   ALTER TABLE ONLY public.aggiungi DROP CONSTRAINT aggiungi_pkey;
       public            postgres    false    214    214            �           2606    42072    album album_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pk PRIMARY KEY (id_album);
 8   ALTER TABLE ONLY public.album DROP CONSTRAINT album_pk;
       public            postgres    false    217            �           2606    42074    artista artista_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.artista
    ADD CONSTRAINT artista_pkey PRIMARY KEY (id_artista);
 >   ALTER TABLE ONLY public.artista DROP CONSTRAINT artista_pkey;
       public            postgres    false    219            �           2606    42076    ascolto ascolto_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.ascolto
    ADD CONSTRAINT ascolto_pk PRIMARY KEY (data, fasciaoraria);
 <   ALTER TABLE ONLY public.ascolto DROP CONSTRAINT ascolto_pk;
       public            postgres    false    221    221            �           2606    42078    collab collab_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_pk PRIMARY KEY (id_artista, id_traccia);
 :   ALTER TABLE ONLY public.collab DROP CONSTRAINT collab_pk;
       public            postgres    false    224    224            �           2606    42080    utente email_unique 
   CONSTRAINT     O   ALTER TABLE ONLY public.utente
    ADD CONSTRAINT email_unique UNIQUE (email);
 =   ALTER TABLE ONLY public.utente DROP CONSTRAINT email_unique;
       public            postgres    false    227            �           2606    42082    libreria id_libreria_unique 
   CONSTRAINT     b   ALTER TABLE ONLY public.libreria
    ADD CONSTRAINT id_libreria_unique PRIMARY KEY (id_libreria);
 E   ALTER TABLE ONLY public.libreria DROP CONSTRAINT id_libreria_unique;
       public            postgres    false    225            �           2606    42084    utente id_utente_unique 
   CONSTRAINT     W   ALTER TABLE ONLY public.utente
    ADD CONSTRAINT id_utente_unique UNIQUE (id_utente);
 A   ALTER TABLE ONLY public.utente DROP CONSTRAINT id_utente_unique;
       public            postgres    false    227            �           2606    42086    playlist playlist_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_pkey PRIMARY KEY (id_playlist);
 @   ALTER TABLE ONLY public.playlist DROP CONSTRAINT playlist_pkey;
       public            postgres    false    209            �           2606    42088    traccia traccia_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.traccia
    ADD CONSTRAINT traccia_pkey PRIMARY KEY (id_traccia);
 >   ALTER TABLE ONLY public.traccia DROP CONSTRAINT traccia_pkey;
       public            postgres    false    212            �           2606    42090    utente utente_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.utente
    ADD CONSTRAINT utente_pkey PRIMARY KEY (username);
 <   ALTER TABLE ONLY public.utente DROP CONSTRAINT utente_pkey;
       public            postgres    false    227            �           2620    42091    collab inc_artisti    TRIGGER     l   CREATE TRIGGER inc_artisti AFTER INSERT ON public.collab FOR EACH ROW EXECUTE FUNCTION public.inc_collab();
 +   DROP TRIGGER inc_artisti ON public.collab;
       public          postgres    false    229    224            �           2620    42092    playlist inc_lib    TRIGGER     }   CREATE TRIGGER inc_lib AFTER INSERT OR DELETE ON public.playlist FOR EACH ROW EXECUTE FUNCTION public.incrementa_libreria();
 )   DROP TRIGGER inc_lib ON public.playlist;
       public          postgres    false    230    209            �           2620    42093    aggiungi inc_plst    TRIGGER     ~   CREATE TRIGGER inc_plst AFTER INSERT OR DELETE ON public.aggiungi FOR EACH ROW EXECUTE FUNCTION public.incrementa_playlist();
 *   DROP TRIGGER inc_plst ON public.aggiungi;
       public          postgres    false    214    231            �           2620    42094    utente ins_lib    TRIGGER     h   CREATE TRIGGER ins_lib AFTER INSERT ON public.utente FOR EACH ROW EXECUTE FUNCTION public.insert_lib();
 '   DROP TRIGGER ins_lib ON public.utente;
       public          postgres    false    232    227            �           2606    42095    aggiungi aggiugni_fkey1    FK CONSTRAINT     �   ALTER TABLE ONLY public.aggiungi
    ADD CONSTRAINT aggiugni_fkey1 FOREIGN KEY (id_playlist) REFERENCES public.playlist(id_playlist) ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.aggiungi DROP CONSTRAINT aggiugni_fkey1;
       public          postgres    false    3228    209    214            �           2606    42100    aggiungi aggiungi_fkey2    FK CONSTRAINT     �   ALTER TABLE ONLY public.aggiungi
    ADD CONSTRAINT aggiungi_fkey2 FOREIGN KEY (id_traccia) REFERENCES public.traccia(id_traccia) ON DELETE CASCADE NOT VALID;
 A   ALTER TABLE ONLY public.aggiungi DROP CONSTRAINT aggiungi_fkey2;
       public          postgres    false    212    3230    214            �           2606    42105    album album_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_fk FOREIGN KEY (id_artista) REFERENCES public.artista(id_artista) ON DELETE CASCADE NOT VALID;
 8   ALTER TABLE ONLY public.album DROP CONSTRAINT album_fk;
       public          postgres    false    217    3236    219            �           2606    42110    ascolto ascolto_fkey1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.ascolto
    ADD CONSTRAINT ascolto_fkey1 FOREIGN KEY (id_utente) REFERENCES public.utente(id_utente);
 ?   ALTER TABLE ONLY public.ascolto DROP CONSTRAINT ascolto_fkey1;
       public          postgres    false    227    3246    221            �           2606    42115    ascolto ascolto_fkey2    FK CONSTRAINT     �   ALTER TABLE ONLY public.ascolto
    ADD CONSTRAINT ascolto_fkey2 FOREIGN KEY (id_traccia) REFERENCES public.traccia(id_traccia);
 ?   ALTER TABLE ONLY public.ascolto DROP CONSTRAINT ascolto_fkey2;
       public          postgres    false    3230    221    212            �           2606    42120    collab collab_fk1    FK CONSTRAINT     �   ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_fk1 FOREIGN KEY (id_artista) REFERENCES public.artista(id_artista) ON DELETE CASCADE NOT VALID;
 ;   ALTER TABLE ONLY public.collab DROP CONSTRAINT collab_fk1;
       public          postgres    false    219    3236    224            �           2606    42125    collab collab_fk2    FK CONSTRAINT     �   ALTER TABLE ONLY public.collab
    ADD CONSTRAINT collab_fk2 FOREIGN KEY (id_traccia) REFERENCES public.traccia(id_traccia) ON DELETE CASCADE NOT VALID;
 ;   ALTER TABLE ONLY public.collab DROP CONSTRAINT collab_fk2;
       public          postgres    false    212    224    3230            �           2606    42130    libreria libreria_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.libreria
    ADD CONSTRAINT libreria_fkey FOREIGN KEY (id_libreria) REFERENCES public.utente(id_utente) ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.libreria DROP CONSTRAINT libreria_fkey;
       public          postgres    false    3246    227    225            �           2606    42135    playlist playlist_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_fkey FOREIGN KEY (id_libappartenenza) REFERENCES public.libreria(id_libreria) ON DELETE CASCADE NOT VALID;
 @   ALTER TABLE ONLY public.playlist DROP CONSTRAINT playlist_fkey;
       public          postgres    false    209    3242    225            �           2606    42140    traccia traccia_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.traccia
    ADD CONSTRAINT traccia_fk FOREIGN KEY (id_album) REFERENCES public.album(id_album) ON DELETE CASCADE NOT VALID;
 <   ALTER TABLE ONLY public.traccia DROP CONSTRAINT traccia_fk;
       public          postgres    false    3234    217    212            O   o   x�%��1�P�)�d����qv��&\=��6r�ܴ�1��5�t�cSO��ȋ2�ʠ�,�V�gR�tImd��kT
st��(3u����~�+����Uc�������      R   �  x�M�Kn#7���)���~?��-�q$�c9� ��[�D�"6�v�4������[3$�"Y����ǽW�X�O�$<[���>(��i������JV�4�%m�J����;mY��mSD��b���Q��Y�2�iۖo�QB�q��,#�i�^��Vf�$�ڇQ\*��ť�J�A\�<��Ѧ��˷�E�lI��o,�ϒ��JYwď�؟��柽��4ޜ�ߝ��6`K�r�+�~�u�刐ҟ���Rɰk��*莥+�I����+��YZ#���A�˞��)�$�+'��Gg!I�7��z���Q(�U����>`��MR�4P�˭���S.��G��2��SF8/��b�w� 3H?e���A��ˊsV�ѻ��Ep�F�#y[~5��ֳ�e��0�nq�������m×�sn�.�� ;��u���(�a��+���jA����y�O<�����<@$�Uyv�,��(����A���a��M����X^P:$�noIo�Fq#�V��R�j�����B���˫3C9��9"������Xo���|��V/�
^LmNJ�u��HX91����H��]ڝ�n��Hy��C[
4��z��ǰ�������B��^����cE�Θ]k����_��Nˀ�-�b�^!�N�������s�1�#:��$<��9 �"j���5|u��-��\`��K��ZX�$:��:+�XM�)�`��ݝSGM�e��w�2`�����91�Z�8�`P��R�x��p� ��-�L�t��ie�$I�������o�aOFIk�X���j��|~:�у��c�BD�ʆ�f5��f�4�ϖf�W�Qc��-q6M<��Ə��^m�UI��z�N��[�FV�gk�og+Ǫ� �ͿV*��&L/F?���	7�A��;���<�#Ali���4��D^di��4� `U��	����U519�nm�j~w�"/���
�z�(�A̟�&^���S�F�}`uBƉb����h0S�c,�5�� ��uF4ƴ>���ЊS���vcF�X]D��6�\��V��H`uy^�H��c"�#ź��Q)�(2�7DCZ���{����u'Vxmјcus^l�=�½FJm��ݸ��F�l����MB]ߙY.��7)�N���uh���4�^����|�d	Ǖ-k
�1��{�9�g$�4      T   �  x�UUKv�8\C��4#R?k��I&�$/��Lozˌ��tSR&Ή�s�(YI��
 ��,�w'q���E���Z���"Rp��s����%J�b�[�A�8���_3X]o��4z�=�U�O$�hq�Q���:/6���ӫX�X��F���l��/Fd�Tq���o�	q���nE��*����������8�_	�=��
n(�q�8�C�,����=z�5v{�ˊ�Rj�%��+Z���]ܜ�HE���s;nM1(?rS�ƭ7��l=[�Lb����E+.�un,�����X'Vh�Hy�3���#
���_��)7��x	7����C�E³�|X���߽���f�����B�ဓ��}�t�;l	�n���Y�v{�3��9�J�f�/f��¨O�
�>��*�;פ	���'�����n�$V��.ؒ��vb�ךt�V%��4j���b�f��\�O&��K�7�5�8l���2�f�y����v�]������.�V�Nm(�ɠ���<��9�;o�f��\���vh���2&�B���m������5^~ro��k���]��!��@@�|p�W�؝F%��6�y�bE�o�]T$��[O#���G+ݰ�d L1������tF3�-��_��#z���OC���4��#�	�+3&��|���P�b��]��1.Jܙ��E���)�����A@�c0^����$6G=A����w�Z�:����B�	5g��%�5�r��sG���*�f�<��2-[���M�������zCk)n�Vw��v9�rs��b�%���/'�mD-C�T�������]�I�L'�i��z���W�b�G6Q!�	��u��,�%����8.T,�X�jڀ,�����etv~Ƽ������N4$��Y_О����~��y�2�>Mq����m��o{$S�>hP	-��Q��:U�m��?�O����:w+�4g	�հQt��`��9�������~���˜��(����      V   �  x��WK��F\kN1�?���6/ËĀ��TQ��5� �kN7Y�*R������Ǐ�.:Ƹ�ޤ_��RV�ݝ���\���:B,Yoobz��[�i�Xݓ�� {ԓ��	ʚrfгײ��S-1�,WI����tܓ_�ت%i��,����r~S$��^���r~�W��c��܁b*����1�
+K%��*��no=�1t#y{���˘B��k�˟?�������?~��Z�Z@�^76>�+�{O=0xW,��Q�eXI��:�q�d����8�$��G��#�2���D���J�({��֠��������a`�� ��B�k��a#�*z��&0-){g���8XRI"=�f7�V�"+T�ռ���W0�F{s�*\������O���6hw5��e�叟�x,7iLG�fS�R�|8u���HsQ�]�	��튳� ��r<6�.P�4zX�F��ۥ/�`?x�(
����~���M��� ��e
+t��_�eK^�S�����#����H`�u���l�yA73���U��]�b;|���*N��ӓ6 @�Y!B 4T8�9�#�
)��L_z��h,���QgfF���V0�zC����1^�0�ͣ��l�T���F�u�I��������YAX=b���h,g8��:9��	��{V:��}b>�����}	F>����Ɗ'�Xr�d- op��6m+u��GU�ß����BY�<�)
4"�`�N@n�E�0���}���Dr�j��ܠ�#	0�j���EB�{DAI��a��>u���%�Ꝡ\ ,
���Y��hE0;�Z����pӺO�i��˅��,�͛{x3�.�,c�+��f�ac�Z�GWbKhS�lM��e��5b߰�����j��h�_��3�NS�LW���"�4&ʵ��}r5_�<G���H05��TP��ah$�DZ0bir6�B0ȿ��2��=�� T�E������=���6���I�m=mJ%(��hj��U�#��CG~� r��!��3"D=N	������E�I���-�b�U?Ϭ|�T"a���R@���Eh���C�}�@�y�[9*Vnċ,��9��WZG���wC	���k	�2n�1�:GΌ=E9(*�41$:��5v�kF	s���G!l�oēQґ[��,��[ho���6~g��&���ܔ�F�_��j�=���q02(��5�>��A�n�0Y��cD�
�i���iek�6ߘW�c)v_`.�N0���a�Z����C%XxV�����6U�=O<�s8ݜ�Сؐ �.	��O�-'����i��`@j�q��G̢�j�?s�(Bt�s��QNټ�L�6�kܰ��s)�b��9��}��v�>VJ�������56��j�1�N��8���W�Ŋ��s��>�*Ă��l 7qm��,'���Rc��H4���m���pP���r��*4�      Y   +  x�%�ɑ1C�̔�!��#ԇ~��l���4��fJ��ŗj!�._��d ��N�-\#ł�dj�X�OgZ=�f�4��P7�K&����.��֖�N��%S�(�q$�t��8�mE�*��K.�R@J�j��b!�d�Oc����z�4����B���$k�y��}��vt�)�4[�p5�K��Ѹ)���{�m ���`f2���]��L�A�]�Ct�
�:���N�w�+��O0���'?�w�p>��P0}�}�p+@���'���l&aA��`2Z�F��A�m�a5(���ߟ��]Ve      Z   A   x�ȹ�@�X�:�׋������#1���f�+*��� 8�v�⺤i���,��5��cX_      J   �   x�u��j�0�������KzM(>�bT#�J�RJۧ��d�R�A;��1+Q��8%F��	/�-L	j���˻��i�UP��XG7z'ww����4�7\R�T�^2KL%��qx��<]D���ѥ!f;0�|_A�ׁY8z�9%�JÊ� ��>:@w�Ou�*�.��7B��k #�z�G��/э�����l�Q�h*�[ϟ"����.S�Y;�4jj����F��@��|_��s��      M   �  x��W�r�6]�_�U�j�O�\u$;~ů��x2�,�"*�PIP��5]6��� SK�n��t ���E�;��1B���Cv���RU��)�|��Di?.DS��*�h��_JZ�K��;;�Y� ���c�Z�u�JI����z���#��Oأ29���8���i2f�z�|�����x^���+Q�����*Yd5���L�N�>h���.��_��`�r�c¥�DTK~��J�!}6-Y� = C�=���P%?�密ό^�\V�O��JWҭ߿�[�����+Tu�cKY�S1��d��>��M��O
M=�%65�����OG	;��ήaL?�?K�}]�m��*��x䥇����L�� `�fFl4_˲e����R��X�ט}���Z/�5���ިEN�B�@�S�0Ī��
c��W�(�)�5�J�Âs{�Xx��([�R�x*�SιZ��C��"��z%�y��CKS�[��[Wz �3Q����pĂ������xԹ�f�[�Ǩ� ہ ���Z����]h���v�߇�AG�RK���Ubk��t�M���7���9ZYղx���14��|1f�94 �� �����|��Q��V�F�;+Z��+�繚��Ft�w�=��4���z!�&��ki y�R+�>�(��-�*��h���J�P�;��70�^ 5o1x��Ij���ױ}k:�p�ch�60I2�/�f{�D�l�5��1�q]�z-�QTSq�q� Ġq�>��ZY'�� ��OB�F:�:0
(���"��<wH���(q#�ٙ��a�}�5�j�n���6� �r�ǈ`D�1�ڛ:�����4D7�Q���o��G�d��Ǚ^I]Jn��_w��(�;p
�1��"$S�>f纩w".�'����:ľ���GP����TY��`��ab� _����,�
�-������0����JI�3�ԩ�zJ�O!�v��@��4Ֆ�9���!�!��5?-��T}[:lDQd��*�86��|��vi̦����A�st�#v#�Ԗ�)����H.h�-��	P.�b�oH�R4�4������i�\7������A%���B�1f[�����^�8��']-0�)�$�S�vL�>�ٴ�і�ȫ�/t]K~#�6E�����A�\�.(�I�V"%J�V���%�7"��( �3W�\V��h�c��ц2k�ԝ�bj:)�ZOG!Twd���d��C��%�V>��p�'�<��T��#���b�Q�_B��iS.;(� ,�Y�V�bM.�7Oؒ��\��(a�b]k�D������2��^��jX߀��w�"Z�=�A������]��{�˦6�}F� �i�#bM2�&b�b)8�q�Wz;���:��xR�=��2�{ᘼQ�F���7EH��Z���E���b��55�'$�h�%�|pu�>.bJ�z.#��a��b��ڷEw��:"`��M�Aᣲ��&z�<P�HȘ���E)͜s%�������S	�ۑþ�5�@x;�b�~�iT%��>���B:L_X�H8�Ȕsȩ5�ΎvƧ'�ē�u�^���a�uE�,ᴖ2��|���ށ�좤��h_�'��2S[fsĭ������m��`!��e��h�}E��r�xv�c�yk%xl����s���>�A|dA���V��0B�K�����qg��΂�_�����ѿ�u�
      \   �  x�e�Ow�:����b�؆����ir��k���!	P@��9�ӿ��/������{G�z/)(j[�$D�)���a�� ��!�eখB{1Ys%5���y����ϥ� �ɟs�����J�MS�:�޷�'��o�5]@Z��L�v8���/��s��@�\����ZH�JaCRS�b��`�����i(H�{m�����BXgtDZ-��g�H�\N�6Fk�_�{j�����g���uTk1'����#�I�
M���?x>=V/���J�ݷ��W�iM��%��X��-�=�v��:�GH��&˄���AR������U��R%h����b�0�ҚLXO�G�$�>�)����b��/�a�1�%�+��F4��9�Qp�"���@�����FjmX�C�Z�g/���az���h���u���j}J:YI�P&ܩ}�����;j%V(|*��?@���(PKMI��9��bt��O΋~����-�<�6�����9`�ic�>��H���)/(��qw��|����;�K(\�1w=gi���J�+d�י�>��y^�"�oA'!\A��<��ʹ7T�g?�lc�u���ske�C�����e�y/�kJ4�9�ϫ�����<~��z�:�FL'�':��	���?]���5�4�ƹ3=���U�ϻ5F ޳��*���$G{3c�3%�@L�/�ۆ�O����D!�\�uI0l��l���;��l2���V�a     