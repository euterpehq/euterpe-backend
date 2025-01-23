# This dir contains custom sql code

**run at owners risk**

It uses the git hook below with git event `pre-push`,
this generated the migration file so it will be pushed by `supabase db push` during the **CI/CD** pipeline.

if you recieve `cp: cannot create regular file './supabase/migrations/20250123221455_avatar_deletePolicy.sql': Permission denied`
you can run: `sudo chown $USER:$USER supabase/migration`

if you receive: `error: insufficient permission for adding an object to repository database .git/objects`
you can run `sudo chown -R $USER:$USER .git` i.e changes ownership of .git recursively from the current owner to the specified user and group


the script pushes to github again btw, if there is an addition

``` bash
#!/bin/bash

# Navigate to repo root
cd "$(git rev-parse --show-toplevel)" || exit 1

MIGRATIONS_DIR="./supabase/migrations"
CUSTOM_SQL_DIR="./supabase/customSQL"

# custom save file format <immediate-dir>_<filename>   

# Ensure directories exist
if [[ ! -d "$MIGRATIONS_DIR" || ! -d "$CUSTOM_SQL_DIR" ]]; then
  echo -e "\e[31mError: Migrations or customSQL directory not found.\e[0m"
  exit 1
fi

declare -A MIGRATION_FILES=()  # Use dict for fast lookup

# Step 1: Clean the migration files (remove timestamps)
for FILE in "$MIGRATIONS_DIR"/*.sql; do
  CLEAN_NAME=$(basename "$FILE" | sed -E 's/^[0-9]{14}_//')
  MIGRATION_FILES["$CLEAN_NAME"]=1
done

# Step 2: Check customSQL files are in the migrations dir
FILES_COPIED=0
for FILE in $(find "$CUSTOM_SQL_DIR" -maxdepth 5 -type f -name "*.sql"); do
  FILE_NAME=$(basename "$FILE")
  if [[ -z "${MIGRATION_FILES[$FILE_NAME]}" ]]; then
    # Convert the file name to the timestamp format
    new_file_path="$MIGRATIONS_DIR/$(date +"%Y%m%d%H%M%S")_$(dirname "$FILE" | xargs basename)_$FILE_NAME"

    echo -e "\e[32mMoving $FILE_NAME to $MIGRATIONS_DIR\e[0m"      
    cp "$FILE" "$new_file_path"
    git add "$new_file_path"
    FILES_COPIED=1
  fi
done

# Commit only if files were copied
if [[ "$FILES_COPIED" -eq 1 ]]; then
  git commit -m "new migrations"
  git push
else
  echo -e "\e[32mNo new migrations to add.\e[0m"
fi
```
