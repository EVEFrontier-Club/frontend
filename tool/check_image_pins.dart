/// Pin hygiene for this repo's copies of the shared Jaspr toolchain pins.
///
/// **The pins are chosen in `dip-develop/jaspr-build-image`, not here.** The
/// published tag `flutter-<flutterPin>-jaspr-<jasprCliPin>-tailwind-<tailwindPin>`
/// is the only place a version is decided; this file asserts that the copies in
/// this repo still agree with it, so a half-done toolchain bump fails CI instead
/// of shipping. It checks:
///
/// - `Dockerfile` starts the build stage FROM the shared Flutter image at the
///   exact pins below;
/// - `Dockerfile` mentions neither the dead `cirruslabs` mirror (it stops at
///   Flutter 3.44.0, so `:3.44.9` never existed) nor `dart run jaspr_cli:jaspr`,
///   which needs `jaspr_cli` resolvable through `.dart_tool/package_config.json`
///   while it is declared in neither dependency block;
/// - `ci.yml` sets `flutter-version:` to the same Flutter pin, so the PR gate
///   runs on the SDK the image ships.
///
/// Pin hygiene, not a release gate: it reports drift and exits non-zero so CI
/// shows it; nothing is measured against a threshold.
///
/// Run with: `dart run tool/check_image_pins.dart`
library;

import 'dart:io';

const String flutterPin = '3.44.9';
const String jasprCliPin = '0.23.5';
const String tailwindPin = '4.3.0';

const String imageRepo = 'ghcr.io/dip-develop/jaspr-build-image';
const String imageTag = 'flutter-$flutterPin-jaspr-$jasprCliPin-tailwind-$tailwindPin';

const String dockerfilePath = 'Dockerfile';
const String ciWorkflowPath = '.github/workflows/ci.yml';

void main() {
  final findings = <String>[];
  final dockerfile = File(dockerfilePath);
  final ciWorkflow = File(ciWorkflowPath);
  for (final file in <File>[dockerfile, ciWorkflow]) {
    if (!file.existsSync()) {
      findings.add('${file.path}: missing — this check cannot assert its pins without the file');
    }
  }
  if (findings.isNotEmpty) {
    _fail(findings);
  }

  final dockerfileText = dockerfile.readAsStringSync();
  final ciWorkflowText = ciWorkflow.readAsStringSync();

  _expectOnce(
    findings,
    dockerfilePath,
    dockerfileText,
    'FROM $imageRepo:$imageTag AS builder',
    change: 'the build stage must start FROM the shared image at exactly these pins',
  );

  if (dockerfileText.contains('cirruslabs')) {
    findings.add(
      '$dockerfilePath: mentions `cirruslabs` — that mirror stops at Flutter 3.44.0, so the '
      'pinned tag never existed; use `$imageRepo:$imageTag`',
    );
  }
  if (dockerfileText.contains('dart run jaspr_cli:jaspr')) {
    findings.add(
      '$dockerfilePath: runs `dart run jaspr_cli:jaspr` — that needs `jaspr_cli` in '
      '`.dart_tool/package_config.json`, and it is declared in neither dependency block; '
      'the shared image puts `jaspr` on PATH, so run `jaspr build`',
    );
  }
  if (!ciWorkflowText.contains('flutter-version: $flutterPin')) {
    findings.add(
      '$ciWorkflowPath: does not pin `flutter-version: $flutterPin` — the PR gate would run '
      'on a different SDK than the image that builds the release',
    );
  }

  if (findings.isNotEmpty) {
    _fail(findings);
  }
  stdout.writeln(
    'check_image_pins: OK — $dockerfilePath builds FROM $imageRepo:$imageTag and '
    '$ciWorkflowPath pins `flutter-version: $flutterPin`; no dead cirruslabs mirror, '
    'no `dart run jaspr_cli:jaspr` invocation.',
  );
}

/// Asserts that [needle] appears exactly once in [text].
void _expectOnce(List<String> findings, String path, String text, String needle, {required String change}) {
  final count = needle.allMatches(text).length;
  if (count != 1) {
    findings.add('$path: `$needle` appears $count times — $change');
  }
}

/// Prints the findings and exits non-zero. `Never` so `main` knows the run stops
/// here.
Never _fail(List<String> findings) {
  stderr.writeln('check_image_pins: ${findings.length} pin hygiene finding(s):');
  for (final finding in findings) {
    stderr.writeln('  - $finding');
  }
  exit(1);
}
