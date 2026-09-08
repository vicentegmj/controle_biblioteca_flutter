# Controle de Biblioteca Escolar

Sistema desktop para Windows, feito em Flutter, para controle de empréstimos
e devoluções de livros de uma biblioteca escolar.

## Objetivo

O sistema controla **quem pegou qual livro, de qual turma, quando pegou,
quando deveria devolver e quando devolveu**. Não é um sistema de gestão de
acervo, e não exige nenhum cadastro prévio: aluno, turma e livro são
informados livremente a cada empréstimo, com sugestões vindas do próprio
histórico.

Módulos: Dashboard, Novo Empréstimo, Devolução, Empréstimos em Aberto,
Atrasados, Histórico, Configurações e Backup.

## Como instalar no Windows

1. Obtenha o arquivo `BibliotecaEscolar-Setup-1.0.0.exe` gerado na pasta
   `dist/`.
2. Feche uma versão anterior do Biblioteca Escolar, caso esteja aberta.
3. Execute `BibliotecaEscolar-Setup-1.0.0.exe`.
4. Escolha se deseja criar um atalho na área de trabalho e avance até
   **Instalar**.
5. Ao finalizar, mantenha marcada a opção **Abrir Biblioteca Escolar** ou
   use o atalho criado no menu Iniciar.

O aplicativo é instalado somente para o usuário atual em
`%LOCALAPPDATA%\Programs\Biblioteca Escolar` e não exige permissão de
administrador. Como o instalador ainda não possui assinatura digital, o
Windows pode exibir o Microsoft Defender SmartScreen. Nesse caso, confira a
origem do arquivo e use **Mais informações** → **Executar assim mesmo**.

Na primeira execução, um banco vazio é criado automaticamente. Os dados da
versão instalada ficam separados dos dados usados por `flutter run`.
Atualizações e reinstalações preservam o banco de produção existente. Para desinstalar, use
**Configurações do Windows** → **Aplicativos** → **Biblioteca Escolar**.

## Requisitos de desenvolvimento

- Flutter SDK 3.35+ (canal stable), Dart 3.9+
- Windows 10/11 com Visual Studio 2022 (workload "Desenvolvimento para
  desktop com C++") para compilar o runner nativo do Windows
- `flutter doctor` sem pendências na linha "Visual Studio"

## Como preparar o projeto

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

## Como gerar o instalador Windows

Com o Inno Setup 6 instalado, execute no PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File installer\build_installer.ps1
```

O script gera o build Release e cria
`dist/BibliotecaEscolar-Setup-1.0.0.exe`. O instalador é instalado por usuário,
não exige permissão de administrador e oferece um atalho opcional na área
de trabalho. O banco de dados do usuário não é removido na desinstalação.

## Banco de dados

SQLite local, acessado via [Drift](https://drift.simonbinder.eu/). O arquivo
fica no diretório de dados do aplicativo (obtido via `path_provider`). Builds
Release usam a subpasta `production`, enquanto execuções de desenvolvimento
usam `development`, evitando que dados fake apareçam na versão instalada. O
arquivo não fica dentro da pasta do projeto. Logs técnicos ficam em
`logs/app.log` no mesmo diretório.

O schema tem apenas duas tabelas: `emprestimos` e `configuracoes`. Não há
cadastros de alunos, turmas ou livros — cada empréstimo é um registro
autocontido com `aluno_nome`, `serie` (1 a 9), `turma_letra` (A, B, C...),
`ano_letivo` (derivado automaticamente do ano de `data_emprestimo`, nunca
digitado), `livro_titulo`, datas e status. Atraso não é armazenado — é
calculado a partir de `data_prevista_devolucao` dos empréstimos ainda em
aberto. As sugestões de autocomplete de aluno/livro são consultas
`SELECT DISTINCT ... LIKE ?` diretamente sobre o histórico de empréstimos.

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

## Como gerar dados fake

Com o aplicativo fechado, execute:

```bash
dart run tool/gerar_dados_fake.dart
```

**Atenção:** o script apaga todos os empréstimos e configurações antes de
inserir 24 empréstimos variados e as configurações de desenvolvimento. Use-o
somente em ambiente de desenvolvimento. Para usar outro banco:

```bash
dart run tool/gerar_dados_fake.dart --database=C:\caminho\biblioteca.sqlite
```

Os testes priorizam as regras de negócio (`test/services`): validação dos
campos obrigatórios, letra da turma normalizada para maiúscula, ano letivo
derivado da data do empréstimo, cálculo da data prevista pelo prazo padrão,
devolução e cancelamento (com suas restrições de estado), cálculo de atraso,
preservação do histórico, e as sugestões de autocomplete (distintas,
case-insensitive, por trecho do texto).

## Estrutura do projeto

```
lib/
  core/          # banco de dados (Drift), tema, utilitários, navegação
  models/        # extensões com propriedades calculadas (ex.: atraso)
  repositories/  # acesso a dados (EmprestimoRepository, ConfiguracaoRepository)
  services/      # regras de negócio (empréstimo, backup, log)
  features/      # uma pasta por tela (dashboard, emprestimos, devolucoes,
                 # atrasados, historico, configuracoes, backup), cada uma
                 # com seus providers Riverpod e widgets
  shared/widgets/# widgets reaproveitados entre telas (inclui o SuggestField,
                 # o campo de autocomplete usado em Aluno e Livro)
test/
  services/      # testes das regras de negócio (prioridade)
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

- **Sem cadastros prévios**: por decisão explícita de escopo, o sistema não
  mantém tabelas de alunos, turmas ou livros. Cada empréstimo grava esses
  dados diretamente. Isso significa que não há como "editar" o nome de um
  aluno em todos os empréstimos antigos de uma vez, nem impedir duas grafias
  diferentes do mesmo nome — é uma troca deliberada de simplicidade por
  rigidez, aceitável para o objetivo de apenas registrar quem pegou o quê.
- **Turma estruturada, mas sem cadastro**: `serie` e `turma_letra` são campos
  próprios (não uma string livre) para permitir filtros exatos no Histórico;
  o `ano_letivo` nunca é digitado, é sempre `ano(data_emprestimo)`.
- **Autocomplete via consulta direta**: as sugestões de aluno/livro usam
  `SELECT DISTINCT coluna FROM emprestimos WHERE coluna LIKE '%termo%' LIMIT
  10`, sem carregar todo o histórico em memória.
- **Leitor de código de barras USB**: não se aplica mais a um campo de código
  de exemplar (não existe mais exemplar/código); o fluxo rápido agora depende
  do autocomplete por nome/título.
- **Status de atraso não persistido**: um empréstimo é considerado atrasado
  apenas em tempo de consulta (`data_prevista_devolucao` no passado e ainda
  não devolvido), evitando redundância de dados que poderia dessincronizar.
- **Restauração de backup exige reiniciar o app**: como o banco é uma conexão
  SQLite única mantida durante toda a execução, a restauração fecha essa
  conexão e substitui o arquivo; a interface informa isso claramente ao
  usuário ao final da operação.

## Histórico do projeto

A primeira versão deste sistema incluía cadastros completos de alunos,
turmas, livros e exemplares (com controle de disponibilidade por exemplar
físico). Essa versão foi deliberadamente substituída por decisão de escopo
posterior, em favor de um modelo mais simples sem cadastros. O ponto do
histórico do Git anterior a essa mudança está marcado com a tag
`v1-cadastros-completos`, caso seja necessário consultá-lo.

## Pendências conhecidas

- Não há testes de widget para cada tela individualmente (apenas um smoke
  test do shell principal) — a prioridade dada, conforme escopo do projeto,
  foi a cobertura das regras de negócio.
- A restauração de backup não recarrega o banco em tempo real dentro da
  mesma sessão do app; é necessário reiniciar a aplicação manualmente após
  restaurar (ver decisão técnica acima).
- Como não há cadastro de aluno/turma/livro, nomes digitados de forma
  inconsistente (ex.: "João Silva" vs. "joão silva ") geram sugestões
  separadas — não há normalização/deduplicação além de correspondência
  exata de texto.
