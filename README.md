# Montreal

PoC para um Sistema de Controle de Tarefas implementado em duas aplicações: cliente e servidor.

# Infra

- Foi utilizado o Delphi versão 7 e seus componentes padrão, na aplicação cliente.
- Ambas as aplicações (cliente e serviço) foram compiladas com a mesma versão do Delphi.
- Para banco de dados foi utilizado o SQL Server.

# Código

- Todo o código fonte (cliente e serviço) está disponível na pasta `src`.
- Todas as unidades com prefixo `server.*` pertencem ao serviço.
- Todas as unidades com prefixo `client.*` pertencem a aplicação VCL.
- A unidade `task.core` mantém o código que é compartilhado entre cliente e serviço.
- Na pasta `script` está disponível scripts para a criação das tabelas e adição de dados para testes.

# Dependências

- [mORMot2](https://github.com/synopse/mORMot2) — client-server ORM SOA MVC framework for Delphi 7 up to latest Delphi and FPC.
- (https://github.com/pleriche/FastMM4) — a fast replacement memory manager for Embarcadero Delphi applications.
