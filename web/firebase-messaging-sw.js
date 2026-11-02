importScripts("https://www.gstatic.com/firebasejs/13.1.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/13.1.0/firebase-messaging-compat.js");

firebase.initializeApp({
     apiKey: "AIzaSyDExy_grFk6NIWexn_qGQ6AZ7wl_6mRlKM",
     authDomain: "ukr-messaging.firebaseapp.com",
     projectId: "ukr-messaging",
     storageBucket: "ukr-messaging.firebasestorage.app",
     messagingSenderId: "768020536323",
     appId: "1:768020536323:web:e231717272871449340236",
     measurementId: "G-FQCY8EYT8D"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log("Background message:", payload);
  const title = payload.notification?.title ?? "Notification";
  self.registration.showNotification(title, {
    body: payload.notification?.body,
    data: payload.data,
  });
});