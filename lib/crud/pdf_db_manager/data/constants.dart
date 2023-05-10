const String dbName = 'pdf_files.db';
const String filesTable = 'files';
const String idColumn = 'id';
const String filePathColumn = 'filepath';
const String downloadDateColumn = 'download_date';

const String createFilesTableCommand = '''CREATE TABLE IF NOT EXISTS files(
   $idColumn INTEGER PRIMARY KEY NOT NULL,
   $filePathColumn TEXT NOT NULL UNIQUE,
   $downloadDateColumn DATETIME
)''';
