importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyA553np3TvR19VDqij2I1WdXHT9I8nm1Kg",
  authDomain: "soynote-aad8d.firebaseapp.com",
  projectId: "soynote-aad8d",
  storageBucket: "soynote-aad8d.appspot.com",
  messagingSenderId: "1021708879332",
  appId: "1:1021708879332:web:3fa410583b46dd9aba73f1",
  measurementId: "G-M91YK32LPL"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

messaging.onBackgroundMessage(payload => {
  console.log('Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle,
    notificationOptions);
});