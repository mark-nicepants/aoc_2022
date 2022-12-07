import 'package:aoc/solver.dart';

/// Directories e and a are both too small; deleting them would not free up enough space.
/// However, directories d and / are both big enough! Between these,
/// choose the smallest: d, increasing unused space by 24933642.

/// Find the smallest directory that, if deleted, would free up enough space
/// on the filesystem to run the update.
///
/// What is the total size of that directory?

class Solver7b extends ISolver {
  @override
  String get key => '7b';

  @override
  String get question => 'What is the total size of that directory?';

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

    final spaceNeededForUpdate = 30000000;
    final spaceNeeded = spaceNeededForUpdate - (fileSystem?.spaceLeft ?? 0);

    final result = fileSystem?.findBestCandidateToRemove(spaceNeeded);
    return result?.dirSize ?? -1;
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

  int totalSpace = 70000000;
  int get spaceLeft => totalSpace - rootDir.dirSize;

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

  Directory? findBestCandidateToRemove(int spaceNeededForUpdate) {
    final dirs = rootDir.allDirectoriesRecursive();
    dirs.sort((l, r) => l.dirSize.compareTo(r.dirSize));

    return dirs.cast<Directory?>().firstWhere(
          (element) => (element?.dirSize ?? 0) > spaceNeededForUpdate,
          orElse: () => null,
        );
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
}

class File extends FileSystemEntity {
  final int size;

  File({
    required this.size,
    required super.level,
    required super.name,
    super.parent,
  });
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
}

enum InstructionType { cd, ls }
