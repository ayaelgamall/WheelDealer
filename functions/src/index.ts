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
                title: `💬 ${userFrom.data()?.display_name}`,
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

exports.sendBidNotifications = functions.firestore
    .document("cars/{carId}/bids/{bidId}")
    .onCreate(async (snapshot, context) => {
      console.log(snapshot.data());

      const carId = context.params.carId;
      const car = await admin
          .firestore().collection("cars").doc(carId).get();

      const sellerId = car.data()?.seller;
      const seller = await admin
          .firestore().collection("users").doc(sellerId).get();
      const sellerFcmToken = seller.data()?.fcm_token;
      console.log(seller);

      const bidderId = snapshot.data().user;
      const bidder = await admin
          .firestore().collection("users").doc(bidderId).get();
      console.log(bidder);

      const sellerNotificationPayload = {
        notification: {
          title: "💰 New Bid!",
          body: `${bidder.data()?.display_name} 
            has placed a new bid of value ${snapshot.data().value} 
            on your listing`,
          sound: "default",
        },
      };

      admin.messaging()
          .sendToDevice(sellerFcmToken, sellerNotificationPayload)
          .then((_) => {
            console.log("Notification sent successfully to seller");
          });

      const biddersNotificationPayload = {
        notification: {
          title: "💵 New Winning Bid",
          body: `${bidder.data()?.display_name} has outbid you for 
          the listing ${car.data()?.brand} ${car.data()?.model}`,
          sound: "default",
        },
      };

      admin.messaging()
          .sendToTopic(`car-${carId}`, biddersNotificationPayload)
          .then((_) => {
            console.log("Notification sent successfully to bidders");
          });
    });
