// Give the service worker access to Firebase SDK.
// Make sure to use the latest compatible version of Firebase.
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
const firebaseConfig = {
  apiKey: "AIzaSyB_gOddlDtmOEsSwJgJKv95zmHg49FWzt4",
  authDomain: "pray-iafcj.firebaseapp.com",
  projectId: "pray-iafcj",
  storageBucket: "pray-iafcj.firebasestorage.app",
  messagingSenderId: "412324001254",
  appId: "1:412324001254:web:1eddaa0fb146e76d325227",
};

firebase.initializeApp(firebaseConfig);

// Retrieve an instance of Firebase Messaging so that it can handle background messages.
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification?.title || 'Mensaje de Oración';
  const notificationOptions = {
    body: payload.notification?.body || 'Tienes un nuevo mensaje.',
    icon: '/favicon.png', // Asegúrate de que este icono exista en tu directorio web
    data: payload.data, // Pasa cualquier dato personalizado
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});