import 'package:aoc/solver.dart';

/// To begin, find all of the directories with a total size of at most 100000,
/// then calculate the sum of their total sizes. In the example above, these
/// directories are a and e; the sum of their total sizes is 95437 (94853 + 584).
/// (As in this example, this process can count files more than once!)
///
/// Find all of the directories with a total size of at most 100000.
/// What is the sum of the total sizes of those directories?

class Solver7a extends ISolver {
  @override
  String get key => '7a';

  @override
  String get question => 'Find all of the directories with a total size of at most 100000.\n'
      'What is the sum of the total sizes of those directories?';

  FileSystem? fileSystem;

  @override
  int solve(List<String> input) {
    fileSystem = FileSystem();

    fileSystem?.explore(input
        .asMap()
        .keys
        .map(
          (index) {
            // Only parse instructions
            if (input[index].startsWith('\$')) {
              return Instruction.fromInput(input, index);
            } else {
              return null;
            }
          },
        )
        .where((element) => element != null)
        .cast<Instruction>()
        .toList());

    final results = fileSystem?.findDirsWithLessSize(100000);
    final total = results?.map((e) => e.dirSize).reduce((v, e) => v + e);
    return total ?? 0;
  }
}

class Instruction {
  InstructionType type;
  String input;
  List<String>? output;

  Instruction(
    this.type,
    this.input,
    this.output,
  );

  factory Instruction.fromInput(List<String> allInput, int myIndex) {
    final instruction = allInput[myIndex];

    final InstructionType type;
    if (instruction.startsWith('\$ cd')) {
      type = InstructionType.cd;
    } else if (instruction.startsWith('\$ ls')) {
      type = InstructionType.ls;
    } else {
      throw UnsupportedError('Instruction not supported');
    }

    // Check for output on next line
    final List<String>? output;
    if (!allInput[myIndex + 1].startsWith("\$")) {
      final start = myIndex + 1;
      int nextInstructionIndex = allInput.sublist(start).indexWhere((element) => element.startsWith('\$'));
      if (nextInstructionIndex == -1) {
        nextInstructionIndex = allInput.length;
      } else {
        nextInstructionIndex += start;
      }

      // Holds the ls instruction output
      output = allInput.sublist(start, nextInstructionIndex);
    } else {
      output = null;
    }

    return Instruction(
      // Command
      type,
      // Command input (given $ cd /, this will hold the /)
      instruction.substring(4).trim(),
      // All subsequent rows between this command and the next (command output)
      output,
    );
  }
}

class FileSystem {
  final rootDir = Directory(
    level: 0,
    parent: null,
    name: '/',
  );

  Directory? currentDir;

  explore(List<Instruction> input) {
    for (var instruction in input) {
      switch (instruction.type) {
        case InstructionType.cd:
          cd(instruction.input);
          break;
        case InstructionType.ls:
          ls(instruction.output!);
          break;
      }
    }
  }

  void cd(String dirName) {
    if (dirName == '/') {
      currentDir = rootDir;
    } else if (currentDir != null) {
      currentDir = currentDir?.cd(dirName);
    }
  }

  void ls(List<String> output) {
    currentDir?.ls(output);
  }

  @override
  String toString() {
    return rootDir.toString();
  }

  List<Directory> findDirsWithLessSize(int i) {
    final dirs = rootDir.allDirectoriesRecursive();

    return dirs.where((dir) => dir.dirSize < i).toList();
  }
}

class Directory extends FileSystemEntity {
  final children = <FileSystemEntity>[];

  Directory({
    required super.level,
    required super.parent,
    required super.name,
  });

  Directory? cd(String dir) {
    if (dir == '..') {
      return parent ?? this; // no parent? stay in this dir.
    }

    return children.whereType<Directory?>().firstWhere(
          (element) => element?.name == dir,
          orElse: () => null,
        );
  }

  void ls(List<String> output) {
    for (var element in output) {
      final FileSystemEntity entity;
      if (element.startsWith('dir')) {
        entity = Directory(
          level: level + 1,
          parent: this,
          name: element.substring(4).trim(),
        );
      } else {
        final parts = element.split(' ');
        entity = File(
          level: level + 1,
          size: int.parse(parts[0]),
          name: parts[1],
          parent: this,
        );
      }
      children.add(entity);
    }
  }

  int get dirSize {
    // No files in systeml
    if (children.isEmpty) return 0;

    return children.map((child) {
      if (child is Directory) return child.dirSize;
      if (child is File) return child.size;

      // Unknown type is counted as zero size
      return 0;
    }).reduce((value, element) => value + element);
  }

  List<Directory> allDirectoriesRecursive() {
    final dirs = children.whereType<Directory>().toList();

    final results = <Directory>[];
    for (final dir in dirs) {
      results.add(dir);
      results.addAll(dir.allDirectoriesRecursive());
    }

    return results;
  }

  @override
  String toString() {
    final stringList = children.map((e) => e.toString()).toList()..insert(0, '$levelIndent- $name (dir)');
    return stringList.join('\n');
  }
}

class File extends FileSystemEntity {
  final int size;

  File({
    required this.size,
    required super.level,
    required super.name,
    super.parent,
  });

  @override
  String toString() => '$levelIndent- $name (file, size=$size)';
}

class FileSystemEntity {
  final int level;
  final String name;
  final Directory? parent;

  FileSystemEntity({
    required this.level,
    required this.name,
    this.parent,
  });

  // Indent with 2 spaces
  String get levelIndent => List.generate(level, (index) => '  ').join('');
}

enum InstructionType { cd, ls }
