# AtendeLab — frontend mínimo para integração

Este pacote contém telas simples para integrar o backend já construído nas aulas. O objetivo é validar o fluxo completo sem investir tempo em um layout definitivo.

## Estratégia adotada

- As telas são arquivos PHP com HTML e Bootstrap.
- O backend existente continua responsável por banco, regras e autenticação.
- As páginas usam `fetch()` para chamar as rotas já existentes.
- Os POSTs são enviados como `application/x-www-form-urlencoded`, conforme os controllers didáticos.
- Não foi criado CRUD visual de usuários, dashboard complexo, relatórios, paginação ou busca global.

## Estrutura do pacote

```text
app/
├── Controllers/
│   └── FrontendController.php
└── Views/
    ├── layouts/
    ├── auth/login.php
    ├── dashboard/index.php
    ├── pessoas/index.php
    ├── tipos-atendimentos/index.php
    └── atendimentos/index.php
assets/
├── css/style.css
└── js/api.js
docs/
└── TRECHO_ROUTES_FRONTEND.txt
```

## Como integrar no projeto de cada acadêmico

1. Faça backup do projeto atual e confirme que o login ainda funciona.
2. Copie as pastas `app/Views`, `assets` e o arquivo `app/Controllers/FrontendController.php` para o projeto `atendelab`.
3. No `routes.php`, adicione o bloco disponível em `docs/TRECHO_ROUTES_FRONTEND.txt` dentro do `switch ($controller)`.
4. Preserve os controllers de backend já existentes.
5. Confirme que o middleware possui a função `exigirAutenticacao()`.
6. Abra `http://localhost/atendelab/public/`, autentique-se e use os links do dashboard.

## Rotas de interface adicionadas

| Tela | URL |
|---|---|
| Dashboard | `?controller=auth&action=dashboard` |
| Pessoas | `?controller=frontend&action=pessoas` |
| Tipos | `?controller=frontend&action=tipos` |
| Atendimentos | `?controller=frontend&action=atendimentos` |

## Rotas de backend esperadas

| Módulo | Ações utilizadas |
|---|---|
| Pessoas | `listar`, `buscar`, `criar`, `atualizar`, `inativar` |
| Tipos | `listar`, `buscar`, `criar`, `atualizar`, `inativar` |
| Atendimentos | `listar`, `criar`, `alterarStatus` |

## Campos esperados

### Pessoas

`id`, `nome`, `documento`, `telefone`, `email`, `curso`, `periodo`, `observacoes`, `status`

### Tipos de atendimento

`id`, `nome`, `descricao`, `status`

### Atendimentos

`id`, `pessoa_id`, `tipo_atendimento_id`, `descricao`, `data_atendimento`, `horario_atendimento`, `status`, `observacao_final`

O campo `usuario_id` não aparece no formulário de atendimento. O backend deve utilizar o usuário autenticado na sessão como responsável pelo novo registro.

## Ajustes que podem ser necessários

Os projetos dos acadêmicos podem possuir pequenas diferenças de nomenclatura. Antes de copiar arquivos completos, compare:

- nome das ações no `routes.php`;
- formato JSON retornado pelos controllers;
- nomes das colunas no banco;
- nome da função do middleware;
- caminho base `/atendelab/public/`.

Caso a pasta do projeto tenha outro nome, ajuste:

- `app/Views/layouts/config-view.php`;
- `assets/js/api.js`;
- referências de CSS e JS nos layouts.

## Checklist rápido

- [ ] Login válido abre o dashboard.
- [ ] Logout encerra a sessão.
- [ ] Dashboard mostra totais ou informa erro de integração.
- [ ] Pessoas podem ser listadas, cadastradas, editadas e inativadas.
- [ ] Tipos podem ser listados, cadastrados, editados e inativados.
- [ ] Atendimento pode ser registrado com pessoa e tipo ativos.
- [ ] Status pode ser alterado.
- [ ] Ao concluir, o backend valida a observação final.
- [ ] Rotas administrativas continuam protegidas.

## Observação didática

O pacote é intencionalmente simples. Ele permite discutir integração entre View, rota, controller, sessão e banco sem transformar a atividade em uma implementação visual extensa.
