CREATE TABLE classificacaolocalidade (
    classificacao_id serial NOT NULL,
    localidade_id integer,
    sequencia integer NOT NULL
);

CREATE TABLE classificacoes (
    id serial NOT NULL,
    nome character varying,
    pai_id integer
);

CREATE TABLE localidades (
    id serial NOT NULL,
    nome character varying NOT NULL,
    data_inicio date,
    referencia_inicio integer NOT NULL,
    data_termino date,
    referencia_termino integer,
    status integer NOT NULL,
    precisao_id integer NOT NULL,
    autor_id integer NOT NULL,
    revisor_id integer,
    data_inclusao timestamp without time zone NOT NULL,
    data_alteracao timestamp without time zone,
    observacao text,
    metodo_id integer,
    geometria geometry,
    ponto geometry,
    poligono geometry,
    linha geometry,
    tipo_geometria character varying(255) DEFAULT 'ponto'::character varying NOT NULL,
    autor_pesquisa character varying(255),
    ano_inicio integer DEFAULT 1499 NOT NULL,
    ano_termino integer DEFAULT 1808,
    link character varying,
    nome_atual character varying,
    importacao character varying,
    CONSTRAINT enforce_dims_geometria CHECK ((st_ndims(geometria) = 2)),
    CONSTRAINT enforce_dims_linha CHECK ((st_ndims(linha) = 2)),
    CONSTRAINT enforce_dims_poligono CHECK ((st_ndims(poligono) = 2)),
    CONSTRAINT enforce_dims_ponto CHECK ((st_ndims(ponto) = 2)),
    CONSTRAINT enforce_geotype_geometria CHECK (((geometrytype(geometria) = 'POINT'::text) OR (geometria IS NULL))),
    CONSTRAINT enforce_geotype_linha CHECK (((geometrytype(linha) = 'MULTILINESTRING'::text) OR (linha IS NULL))),
    CONSTRAINT enforce_geotype_poligono CHECK (((geometrytype(poligono) = 'MULTIPOLYGON'::text) OR (poligono IS NULL))),
    CONSTRAINT enforce_geotype_ponto CHECK (((geometrytype(ponto) = 'MULTIPOINT'::text) OR (ponto IS NULL))),
    CONSTRAINT enforce_srid_geometria CHECK ((st_srid(geometria) = 4291)),
    CONSTRAINT enforce_srid_linha CHECK ((st_srid(linha) = 4291)),
    CONSTRAINT enforce_srid_poligono CHECK ((st_srid(poligono) = 4291)),
    CONSTRAINT enforce_srid_ponto CHECK ((st_srid(ponto) = 4291))
);

CREATE TABLE metodos (
    id serial NOT NULL,
    nome character varying(255) NOT NULL,
    abreviacao character varying(255) NOT NULL,
    descricao text
);

CREATE TABLE precisoes (
    id serial NOT NULL,
    nome character varying,
    descricao character varying
);

CREATE TABLE fontelocalidade (
    fonte_id integer,
    localidade_id integer,
    referencia character varying,
    fonte text,
    tipo_informacao_id integer
);

CREATE TABLE fontes (
    id serial NOT NULL,
    fonte character varying NOT NULL,
    tipo_fonte_id integer
);

CREATE TABLE parametrolocalidade (
    parametro_id integer NOT NULL,
    localidade_id integer NOT NULL,
    valor character varying NOT NULL,
    ano character varying NOT NULL
);

CREATE TABLE parametros (
    id serial NOT NULL,
    nome character varying NOT NULL,
    descricao text
);

CREATE TABLE tipofonte (
    id serial NOT NULL,
    nome character varying NOT NULL
);

CREATE TABLE tipoinformacao (
    id serial NOT NULL,
    nome character varying NOT NULL
);

CREATE TABLE tipousuario (
    id serial NOT NULL,
    nome character varying
);

CREATE TABLE usuarios (
    id integer NOT NULL,
    nome character varying NOT NULL,
    login character varying NOT NULL,
    senha character varying NOT NULL,
    email character varying,
    tipo_usuario_id integer,
    status integer NOT NULL
);


-- Insere dados predefinidos
INSERT INTO tipousuario (id, nome) VALUES (1, 'Administrador');
INSERT INTO tipousuario (id, nome) VALUES (2, 'Autor');
INSERT INTO tipousuario (id, nome) VALUES (3, 'Editor');


-- Usuário 'admin'; Senha "oduduwa"
INSERT INTO usuarios (id, nome, login, senha, email, tipo_usuario_id, status) VALUES (1, 'admin', 'admin', 'de5bbeab0de7171f70f899638a4c9ac0', 'admin@adminland.com', 1, 1);

-- Cria sequence em usuarios
CREATE SEQUENCE usuarios_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios_id_seq'::regclass);