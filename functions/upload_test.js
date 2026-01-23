const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.onBookUploaded = functions.storage.object().onFinalize(async (object) => {
    const filePath = object.name;
    const contentType = object.contentType;

    console.log("Function triggered for:", filePath);

    if (!filePath || !filePath.startsWith("books/")) {
        console.log("Skipping: not in books/ folder");
        return null;
    }

    if (contentType !== "application/pdf" && contentType !== "application/epub+zip") {
        console.log("Skipping: not PDF or EPUB");
        return null;
    }

    const fileName = filePath.split("/").pop();
    const metadata = object.metadata || {};

    const bookData = {
        fileName: fileName,
        filePath: filePath,
        title: metadata.title || fileName.replace(/\.[^/.]+$/, ""),
        author: metadata.author || "Unknown",
        format: fileName.split(".").pop(),
        contentType: contentType,
        size: parseInt(object.size, 10),
        uploadedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await db.collection("books").doc(fileName).set(bookData);
    console.log(`Book metadata saved: ${fileName}`);
    return null;
});
