import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
    .document("chatRooms/{chatRoomsId}/messages/{messagesId}")
    .onCreate(async snapshot => {
        const message = snapshot.data();

        const querySnapshot = await db
            .collection("accounts")
            .doc(message.uid)
            .collection("token")
            .get();

        const tokens = querySnapshot.docs.map(snapshot => snapshot.id);

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "You got a new message.",
                body: `${message.message}`,
                clickAction: "FLUTTER_NOTIFICATION_CLICK"
            }
        }

        return fcm.sendToDevice(tokens, payload);
    });