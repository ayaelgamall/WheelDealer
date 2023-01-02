import functions = require("firebase-functions");
import admin = require("firebase-admin");

admin.initializeApp();

exports.sendChatNotifications = functions.firestore
    .document("chats/{chatId}/messages/{messageId}")
    .onCreate((snapshot: { data: () => any; }) => {
      const msg = snapshot.data();
      console.log(msg);

      const idTo = msg.to;
      const idFrom = msg.from;
      const content = msg.text;

      admin
          .firestore()
          .collection("users")
          .doc(idTo)
          .get()
          .then(async (user) => {
            console.log(user.data());

            const userFrom = await admin
                .firestore().collection("users").doc(idFrom).get();

            const payload = {
              notification: {
                title: `New Message From: ${userFrom.data()?.display_name}`,
                body: content,
                sound: "default",
              },
            };

            admin
                .messaging()
                .sendToDevice(user.data()?.fcm_token, payload)
                .then((response: any) => {
                  console.log("Notification Sent successfully");
                  console.log(response);
                });
          });
    });
