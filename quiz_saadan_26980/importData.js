const admin = require('firebase-admin');
const fs = require('fs');

const serviceAccount = require('./serviceAccountKey.json'); // Replace with your Firebase service account key

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const data = JSON.parse(fs.readFileSync('transactions.json', 'utf8'));

const uploadData = async () => {
  const collectionRef = db.collection('transactions');
  for (const key in data) {
    await collectionRef.doc(key).set(data[key]);
    console.log(`Uploaded: ${key}`);
  }
};

uploadData();
