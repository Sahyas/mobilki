#!/bin/bash
# upload_books.sh - Batch upload books to Firebase Storage

BUCKET="flutter-zaliczenie-f9528.appspot.com"
EMULATOR_HOST="http://127.0.0.1:9199"
USE_EMULATOR=true  # Set to false for production

if [ "$USE_EMULATOR" = true ]; then
  STORAGE_URL="$EMULATOR_HOST/v0/b/$BUCKET/o"
else
  STORAGE_URL="https://firebasestorage.googleapis.com/v0/b/$BUCKET/o"
fi

shopt -s nullglob  # Prevent errors when no files match

uploaded=0

for file in ./resources/books/*.pdf ./resources/books/*.epub; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    extension="${filename##*.}"

    # Extract metadata from PDF
    if [ "$extension" = "pdf" ]; then
      title=$(pdfinfo "$file" 2>/dev/null | grep "Title:" | cut -d: -f2 | xargs)
      author=$(pdfinfo "$file" 2>/dev/null | grep "Author:" | cut -d: -f2 | xargs)
    else
      title="${filename%.*}"
      author="Unknown"
    fi

    [ -z "$title" ] && title="${filename%.*}"
    [ -z "$author" ] && author="Unknown"

    # URL-encode the path
    encoded_path=$(printf '%s' "books/$filename" | jq -sRr @uri)

    # Determine content type
    if [ "$extension" = "pdf" ]; then
      content_type="application/pdf"
    else
      content_type="application/epub+zip"
    fi

    # Upload with custom metadata
    response=$(curl -X POST "$STORAGE_URL?name=$encoded_path" \
      -H "Content-Type: $content_type" \
      -H "X-Goog-Meta-title: $title" \
      -H "X-Goog-Meta-author: $author" \
      -H "X-Goog-Meta-format: $extension" \
      --data-binary @"$file" \
      --silent --write-out "%{http_code}")

    http_code="${response: -3}"

    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
      echo "✓ Uploaded: $filename | Title: $title | Author: $author"
      ((uploaded++))
    else
      echo "✗ Failed: $filename (HTTP $http_code)"
    fi
  fi
done

shopt -u nullglob

echo ""
if [ $uploaded -eq 0 ]; then
  echo "No files found in ./resources/books/"
  echo "Add .pdf or .epub files and run again."
else
  echo "Done! Uploaded $uploaded file(s)."
  echo "Cloud Function will save metadata to Firestore automatically."
fi
