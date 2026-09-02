import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/database/database.dart';
import '../core/utils/date_formatters.dart';
import '../core/utils/turma_utils.dart';
import '../models/emprestimo_extensions.dart';

enum TipoRelatorioEmprestimos { emAberto, atrasados }

enum OrdenacaoRelatorioEmprestimos { dataEmprestimo, aluno, serie }

class RelatorioEmprestimosPdfService {
  const RelatorioEmprestimosPdfService();

  List<Emprestimo> prepararDados({
    required List<Emprestimo> emprestimos,
    required TipoRelatorioEmprestimos tipo,
    required OrdenacaoRelatorioEmprestimos ordenacao,
  }) {
    final itens = emprestimos
        .where(
          (item) => tipo == TipoRelatorioEmprestimos.atrasados
              ? item.atrasado
              : item.emAberto,
        )
        .toList();

    itens.sort((a, b) {
      final comparacao = switch (ordenacao) {
        OrdenacaoRelatorioEmprestimos.dataEmprestimo =>
          b.dataEmprestimo.compareTo(a.dataEmprestimo),
        OrdenacaoRelatorioEmprestimos.aluno => _compararTexto(
          a.alunoNome,
          b.alunoNome,
        ),
        OrdenacaoRelatorioEmprestimos.serie => _compararSerie(a, b),
      };
      return comparacao != 0 ? comparacao : a.id.compareTo(b.id);
    });
    return itens;
  }

  Future<File> gerarEabrir({
    required List<Emprestimo> emprestimos,
    required TipoRelatorioEmprestimos tipo,
    required OrdenacaoRelatorioEmprestimos ordenacao,
    String? nomeEscola,
  }) async {
    final itens = prepararDados(
      emprestimos: emprestimos,
      tipo: tipo,
      ordenacao: ordenacao,
    );
    final bytes = await gerarPdf(
      itens: itens,
      tipo: tipo,
      ordenacao: ordenacao,
      nomeEscola: nomeEscola,
    );
    final diretorio = await getTemporaryDirectory();
    final sufixo = DateTime.now().millisecondsSinceEpoch;
    final nomeTipo = tipo == TipoRelatorioEmprestimos.atrasados
        ? 'atrasados'
        : 'em_aberto';
    final arquivo = File(
      p.join(diretorio.path, 'emprestimos_${nomeTipo}_$sufixo.pdf'),
    );
    await arquivo.writeAsBytes(bytes, flush: true);

    await _abrirPdf(arquivo);
    return arquivo;
  }

  Future<Uint8List> gerarPdf({
    required List<Emprestimo> itens,
    required TipoRelatorioEmprestimos tipo,
    required OrdenacaoRelatorioEmprestimos ordenacao,
    required String? nomeEscola,
  }) async {
    final documento = pw.Document();
    final tema = await _criarTemaPdf();
    final titulo = tipo == TipoRelatorioEmprestimos.atrasados
        ? 'Empréstimos atrasados'
        : 'Empréstimos em aberto';

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        theme: tema,
        maxPages: 1000,
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (nomeEscola != null && nomeEscola.trim().isNotEmpty)
              pw.Text(
                nomeEscola.trim(),
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            pw.Text(
              titulo,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Emitido em ${formatDateTime(DateTime.now())} | '
              '${itens.length} registro(s) | '
              'Ordem: ${_rotuloOrdenacao(ordenacao)}',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.SizedBox(height: 12),
          ],
        ),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Página ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
        build: (context) => [
          pw.TableHelper.fromTextArray(
            headers: const [
              'Aluno',
              'Série/Turma',
              'Livro',
              'Empréstimo',
              'Previsto',
              'Situação',
            ],
            data: itens
                .map(
                  (item) => [
                    item.alunoNome,
                    TurmaUtils.rotulo(item.serie, item.turmaLetra),
                    item.livroTitulo,
                    formatDate(item.dataEmprestimo),
                    formatDate(item.dataPrevistaDevolucao),
                    item.atrasado ? '${item.diasAtraso} dia(s)' : 'Em dia',
                  ],
                )
                .toList(),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xff2c5f7c),
            ),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(fontSize: 8),
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 4,
            ),
            oddRowDecoration: const pw.BoxDecoration(
              color: PdfColor.fromInt(0xfff1f5f8),
            ),
            columnWidths: const {
              0: pw.FlexColumnWidth(2.2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(2.5),
              3: pw.FlexColumnWidth(1.1),
              4: pw.FlexColumnWidth(1.1),
              5: pw.FlexColumnWidth(1.1),
            },
          ),
        ],
      ),
    );
    return documento.save();
  }

  static int _compararTexto(String a, String b) =>
      a.toLowerCase().compareTo(b.toLowerCase());

  static int _compararSerie(Emprestimo a, Emprestimo b) {
    final serie = a.serie.compareTo(b.serie);
    if (serie != 0) return serie;
    final turma = _compararTexto(a.turmaLetra, b.turmaLetra);
    if (turma != 0) return turma;
    return _compararTexto(a.alunoNome, b.alunoNome);
  }

  static String _rotuloOrdenacao(OrdenacaoRelatorioEmprestimos ordenacao) {
    return switch (ordenacao) {
      OrdenacaoRelatorioEmprestimos.dataEmprestimo => 'data do empréstimo',
      OrdenacaoRelatorioEmprestimos.aluno => 'nome do aluno',
      OrdenacaoRelatorioEmprestimos.serie => 'série e turma',
    };
  }

  static Future<pw.ThemeData> _criarTemaPdf() async {
    final diretorioWindows = Platform.environment['WINDIR'];
    final candidatosRegulares = [
      if (diretorioWindows != null)
        p.join(diretorioWindows, 'Fonts', 'arial.ttf'),
      '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
      '/System/Library/Fonts/Supplemental/Arial.ttf',
    ];
    final candidatosNegrito = [
      if (diretorioWindows != null)
        p.join(diretorioWindows, 'Fonts', 'arialbd.ttf'),
      '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
      '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
    ];

    final regular = await _carregarFonte(candidatosRegulares);
    final negrito = await _carregarFonte(candidatosNegrito) ?? regular;
    if (regular == null) return pw.ThemeData.base();
    return pw.ThemeData.withFont(base: regular, bold: negrito);
  }

  static Future<pw.Font?> _carregarFonte(List<String> candidatos) async {
    for (final caminho in candidatos) {
      final arquivo = File(caminho);
      if (await arquivo.exists()) {
        final bytes = await arquivo.readAsBytes();
        return pw.Font.ttf(
          bytes.buffer.asByteData(bytes.offsetInBytes, bytes.lengthInBytes),
        );
      }
    }
    return null;
  }

  static Future<void> _abrirPdf(File arquivo) async {
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'A abertura automática do PDF está disponível no Windows.',
      );
    }

    final localAppData = Platform.environment['LOCALAPPDATA'];
    final programFiles = Platform.environment['ProgramFiles'];
    final programFilesX86 = Platform.environment['ProgramFiles(x86)'];
    final candidatosChrome = [
      if (localAppData != null)
        p.join(localAppData, 'Google', 'Chrome', 'Application', 'chrome.exe'),
      if (programFiles != null)
        p.join(programFiles, 'Google', 'Chrome', 'Application', 'chrome.exe'),
      if (programFilesX86 != null)
        p.join(
          programFilesX86,
          'Google',
          'Chrome',
          'Application',
          'chrome.exe',
        ),
    ];

    for (final caminhoChrome in candidatosChrome) {
      if (await File(caminhoChrome).exists()) {
        await Process.start(caminhoChrome, [Uri.file(arquivo.path).toString()]);
        return;
      }
    }

    await Process.start('explorer.exe', [arquivo.path]);
  }
}
