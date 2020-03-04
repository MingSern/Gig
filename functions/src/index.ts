import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const chatNotification = functions.firestore
    .document("chatRooms/{chatRoomsId}/messages/{messagesId}")
    .onCreate(async snapshot => {
        const message = snapshot.data();

        if (message == undefined) {
            console.log("--------------------------- CHATROOM NOT EXIST ---------------------------");
            return;
        }

        const user = db
            .collection("accounts")
            .doc(message.uid)
            .get();

        const querySnapshot = db
            .collection("accounts")
            .doc(message.to)
            .collection("token")
            .get();

        let [userResult, querySnapshotResult] = await Promise.all([user, querySnapshot]);

        const tokens = querySnapshotResult.docs.map(snap => snap.id);

        const userData = userResult.data();

        if (userData == undefined) {
            console.log("--------------------------- USER NOT EXIST ---------------------------");
            return;
        }

        var titleMessage = " messaged you.";
        var username = "Someone";

        if (userData.businessName != null) {
            username = userData.businessName;
        } else if (userData.fullname != null) {
            username = userData.fullname;
        }

        titleMessage = username + titleMessage;

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: titleMessage,
                body: message.message,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
                sound: "default",
            },
        }

        return fcm.sendToDevice(tokens, payload);
    });