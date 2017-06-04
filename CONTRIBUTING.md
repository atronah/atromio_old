Commit message
---------------
Old commit messages prefixes:

- `[AD]` - new functionality
- `[FX]` - fixes
- `[DL]` - remove functionality
- `[RF]` - refactoring
- `[CH]` - changes in existing functionality
- `[TR]` - translate changes
- `[MT]` - meta data changes (documentation, comments, project settings)
- `[DB]` - database changes
- `[FS]` - file structure changes

Release new version
-------------------
### Steps for preparing new release
- change version in app.pro
- make <type>_init.sql script for database and clear sqlite database file
- add tag into liquibase with release version
- make release database docs


