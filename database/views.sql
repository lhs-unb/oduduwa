
-- Views de recuperação de dados
CREATE VIEW busca_geral AS
 SELECT DISTINCT cl.sequencia,
    l.id AS codigo,
    l.nome,
    ((((
        CASE l.referencia_inicio
            WHEN 1 THEN ''::text
            WHEN 2 THEN 'antes de '::text
            WHEN 3 THEN 'depois de '::text
            WHEN 4 THEN 'por volta de '::text
            ELSE NULL::text
        END || COALESCE(to_char((l.data_inicio)::timestamp with time zone, 'DD/MM/YYYY'::text), ((l.ano_inicio)::character varying)::text)) || ' atÃ© '::text) ||
        CASE l.referencia_termino
            WHEN 1 THEN ''::text
            WHEN 2 THEN 'antes de '::text
            WHEN 3 THEN 'depois de '::text
            WHEN 4 THEN 'por volta de '::text
            ELSE NULL::text
        END) || COALESCE(to_char((l.data_termino)::timestamp with time zone, 'DD/MM/YYYY'::text), ((l.ano_termino)::character varying)::text)) AS periodo,
    l.ano_inicio AS inicio,
    l.ano_termino AS termino,
    (((p.nome)::text || ' - '::text) || (p.descricao)::text) AS precisao,
    l.autor_pesquisa AS autor_da_pesquisa,
    m.nome AS metodo,
    COALESCE(to_char(l.data_alteracao, 'DD/MM/YYYY'::text), to_char(l.data_inclusao, 'DD/MM/YYYY'::text)) AS ultima_alteracao,
    l.tipo_geometria AS tipo_de_geometria,
    l.observacao AS observacoes,
    pai.id AS classificacaoassu,
    filho.id AS classificacaomirim,
        CASE
            WHEN (pai.id > 0) THEN (COALESCE((((pai.nome)::text || ' > '::text) || (filho.nome)::text)))::character varying
            ELSE filho.nome
        END AS hierarquia,
    l.ponto,
    l.linha,
    l.poligono,
        CASE
            WHEN ((l.link)::text <> ''::text) THEN COALESCE((('<a href="http://164.41.2.93/biblioatlas/'::text || (l.link)::text) || '" target="atlas_wiki">Abrir Wiki</a><br>'::text))
            ELSE NULL::text
        END AS link,
    l.status,
    capitania.nome AS capitania,
    contexto.nome AS estado,
    l.data_inicio
   FROM (((((((((localidades l
     JOIN precisoes p ON ((p.id = l.precisao_id)))
     JOIN metodos m ON ((m.id = l.metodo_id)))
     JOIN classificacaolocalidade cl ON ((cl.localidade_id = l.id)))
     JOIN classificacoes filho ON ((filho.id = cl.classificacao_id)))
     LEFT JOIN classificacoes pai ON ((filho.pai_id = pai.id)))
     LEFT JOIN classificacaolocalidade rel_capitania ON (((rel_capitania.localidade_id = l.id) AND (rel_capitania.classificacao_id IN ( SELECT classificacoes.id
           FROM classificacoes
          WHERE (classificacoes.pai_id = 479))))))
     LEFT JOIN classificacoes capitania ON ((capitania.id = rel_capitania.classificacao_id)))
     LEFT JOIN classificacaolocalidade rel_contexto ON (((rel_contexto.localidade_id = l.id) AND (rel_contexto.classificacao_id IN ( SELECT classificacoes.id
           FROM classificacoes
          WHERE (classificacoes.pai_id = 150))))))
     LEFT JOIN classificacoes contexto ON ((contexto.id = rel_contexto.classificacao_id)))
  WHERE ((l.status <> 9) AND (pai.id <> ALL (ARRAY[479, 150])))
  ORDER BY l.nome, l.id;