#!/bin/bash
# upload_books.sh - Batch upload books to Firebase Storage

BUCKET="gs://flutter-zaliczenie-f9528.firebasestorage.app"
FIRESTORE_PROJECT="flutter-zaliczenie-f9528"

for file in ./books/*.{pdf,epub}; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    extension="${filename##*.}"

    # Extract metadata from PDF
    if [ "$extension" = "pdf" ]; then
      title=$(pdfinfo "$file" | grep "Title:" | cut -d: -f2 | xargs)
      author=$(pdfinfo "$file" | grep "Author:" | cut -d: -f2 | xargs)
    else
      title="${filename%.*}"
      author="Unknown"
    fi

    # Upload to Cloud Storage
    gsutil cp "$file" "$BUCKET/books/$filename"

    echo "Uploaded: $filename (Title: $title, Author: $author)"
  fi
done
