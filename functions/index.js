const { onObjectFinalized } = require("firebase-functions/v2/storage");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");

initializeApp();
const db = getFirestore();

exports.onBookUploaded = onObjectFinalized(
    { bucket: "flutter-zaliczenie-f9528.appspot.com" },
    async (event) => {
        const filePath = event.data.name;
        const contentType = event.data.contentType;
        const bucketName = event.data.bucket;

        console.log("Triggered for:", filePath);

        if (!filePath || !filePath.startsWith("books/")) {
            console.log("Skipping: not in books/ folder");
            return null;
        }

        const fileName = filePath.split("/").pop();
        const metadata = event.data.metadata || {};

        const encodedPath = encodeURIComponent(filePath);

        // Check if running in emulator
        const isEmulator = process.env.FUNCTIONS_EMULATOR === "true" ||
            process.env.FIREBASE_STORAGE_EMULATOR_HOST;

        let downloadUrl;
        if (isEmulator) {
            const host = process.env.FIREBASE_STORAGE_EMULATOR_HOST || "127.0.0.1:9199";
            downloadUrl = `http://${host}/v0/b/${bucketName}/o/${encodedPath}?alt=media`;
        } else {
            downloadUrl = `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${encodedPath}?alt=media`;
        }

        const bookData = {
            fileName: fileName,
            filePath: filePath,
            fileUrl: filePath,
            downloadUrl: downloadUrl,
            title: metadata.title || fileName.replace(/\.[^/.]+$/, ""),
            author: metadata.author || "Unknown",
            format: fileName.split(".").pop(),
            contentType: contentType,
            size: parseInt(event.data.size, 10),
            uploadedAt: FieldValue.serverTimestamp(),
        };

        await db.collection("books").doc(fileName).set(bookData);
        console.log(`Book metadata saved: ${fileName}`);
        console.log(`Download URL: ${downloadUrl}`);
        return null;
    }
);
