# Controle de Biblioteca Escolar

Sistema desktop para Windows, feito em Flutter, para controle de empréstimos
e devoluções de livros de uma biblioteca escolar.

## Objetivo

O sistema controla **quem pegou qual livro, quando pegou, quando deveria
devolver e quando devolveu**. Não é um sistema de gestão de acervo: não há
controle de estoque, aquisição, financeiro, patrimonial ou de fornecedores.
O cadastro de livros/exemplares existe apenas para identificar o que foi
emprestado.

Módulos: Dashboard, Alunos, Turmas, Livros (com exemplares), Novo Empréstimo,
Devolução, Empréstimos em Aberto, Atrasados, Histórico, Configurações e
Backup.

## Requisitos

- Flutter SDK 3.35+ (canal stable), Dart 3.9+
- Windows 10/11 com Visual Studio 2022 (workload "Desenvolvimento para
  desktop com C++") para compilar o runner nativo do Windows
- `flutter doctor` sem pendências na linha "Visual Studio"

## Como instalar

```bash
flutter pub get
```

## Como executar (desenvolvimento)

```bash
flutter run -d windows
```

## Como compilar (release)

```bash
flutter build windows
```

O executável fica em `build/windows/x64/runner/Release/`.

## Banco de dados

SQLite local, acessado via [Drift](https://drift.simonbinder.eu/). O arquivo
fica no diretório de dados do aplicativo (obtido via `path_provider`,
tipicamente `%APPDATA%/com.biblioteca.controle_biblioteca/`), não dentro da
pasta do projeto. Logs técnicos ficam em `logs/app.log` no mesmo diretório.

O schema é normalizado em: `turmas`, `alunos`, `livros`, `exemplares`,
`emprestimos`, `emprestimo_itens`, `configuracoes`. Um empréstimo pode ter
vários itens (exemplares), e cada item é devolvido individualmente; o
empréstimo só é encerrado quando todos os itens forem devolvidos. Atraso não
é armazenado — é calculado a partir de `data_prevista_devolucao` dos itens
ainda em aberto.

## Como fazer backup

Tela **Backup** → "Fazer Backup Agora". Gera um arquivo `.sqlite` consistente
(via `VACUUM INTO`) no diretório configurado em Configurações (ou em um
diretório escolhido na hora).

## Como restaurar um backup

Tela **Backup** → "Restaurar de um Arquivo...". O arquivo é validado antes de
qualquer alteração, uma cópia de segurança do banco atual é criada
automaticamente, e a aplicação precisa ser reiniciada após a restauração para
carregar os dados restaurados.

## Como executar os testes

```bash
flutter test
```

Os testes priorizam as regras de negócio (`test/services`,
`test/repositories`): impedir empréstimo duplicado de um mesmo exemplar,
bloquear aluno/exemplar inativo, devolução total e parcial, cálculo de
atraso, limite de empréstimos simultâneos, bloqueio por atraso, cancelamento
e preservação de histórico.

## Estrutura do projeto

```
lib/
  core/          # banco de dados (Drift), tema, utilitários, navegação
  models/        # DTOs de leitura que combinam dados de várias tabelas
  repositories/  # acesso a dados (uma classe por tabela/agregado)
  services/      # regras de negócio (empréstimo, backup, log)
  features/      # uma pasta por tela (dashboard, alunos, turmas, livros,
                 # emprestimos, devolucoes, atrasados, historico,
                 # configuracoes, backup), cada uma com seus providers
                 # Riverpod e widgets
  shared/widgets/# widgets reaproveitados entre telas
test/
  services/      # testes das regras de negócio (prioridade)
  repositories/  # testes de acesso a dados e restrições de unicidade
```

## Pacotes principais e motivo da escolha

- **drift** + **sqlite3_flutter_libs**: ORM/SQL type-safe maduro para SQLite,
  com bom suporte a Windows e geração de código para queries e migrations.
- **flutter_riverpod**: gerenciamento de estado explícito e testável, sem
  necessidade de `BuildContext` para acessar dados.
- **path_provider**: localizar o diretório de dados do aplicativo de forma
  multiplataforma.
- **file_selector**: diálogos nativos de escolha de arquivo/diretório
  (mantido pela equipe Flutter, com suporte oficial a Windows) — usado nas
  telas de Configurações e Backup.
- **intl**: formatação de datas em pt-BR.

## Decisões técnicas relevantes

- **Leitor de código de barras USB**: tratado como teclado comum — os campos
  de código nas telas de Empréstimo/Devolução reagem ao evento de "Enter"
  (`onSubmitted`), sem depender de nenhuma biblioteca ou marca específica.
- **Status de atraso não persistido**: um item é considerado atrasado apenas
  em tempo de consulta (`data_prevista_devolucao` no passado e item ainda
  sem devolução), evitando redundância de dados que poderia ficar
  dessincronizada.
- **Restauração de backup exige reiniciar o app**: como o banco é uma
  conexão SQLite única mantida durante toda a execução, a restauração fecha
  essa conexão e substitui o arquivo; a interface informa isso claramente ao
  usuário ao final da operação.
- **Sem controle de estoque**: times de exemplares fisicos existem apenas
  para permitir identificar qual cópia foi emprestada; a "disponibilidade" é
  sempre derivada dos empréstimos em aberto, nunca de um contador.

## Pendências conhecidas

- Não há testes de widget para cada tela individualmente (apenas um smoke
  test do shell principal) — a prioridade dada, conforme escopo do projeto,
  foi a cobertura das regras de negócio.
- A restauração de backup não recarrega o banco em tempo real dentro da
  mesma sessão do app; é necessário reiniciar a aplicação manualmente após
  restaurar (ver decisão técnica acima).
