// We use print to output the progress to the console
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

void main() async {
  print('Fetching lint rules from GitHub...');
  final url = Uri.parse('https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/pkg/linter/tool/machine/rules.json');
  final request = await HttpClient().getUrl(url);
  final response = await request.close();
  
  if (response.statusCode != 200) {
    print('Failed to fetch rules: ${response.statusCode}');
    exit(1);
  }

  final content = await response.transform(utf8.decoder).join();
  final rulesJson = jsonDecode(content) as List<dynamic>;

  
  final rules = <String>[];
  for (final dynamic rule in rulesJson) {
    final ruleMap = rule as Map<String, dynamic>;
    final name = ruleMap['name'] as String;
    final state = ruleMap['state'] as String;
    
    // Skip removed rules but keep deprecated ones to match the dart.dev list
    if (state == 'removed') {
      continue;
    }
    
    rules.add(name);
  }
  
  rules.sort();
  
  print('Found ${rules.length} active lint rules.');
  
  final buffer = StringBuffer()
    ..writeln(
      '# All lint rules are activated in this file. Latest rules can be found at:',
    )
    ..writeln('# https://dart.dev/tools/linter-rules/all')
    ..writeln('linter:')
    ..writeln('  rules:');
  for (final rule in rules) {
    buffer.writeln('    - $rule');
  }
  
  final file = File('all_lint_rules.yaml');
  await file.writeAsString(buffer.toString());
  
  print('Successfully updated all_lint_rules.yaml');
}
